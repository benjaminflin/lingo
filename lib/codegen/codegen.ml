module L = Llvm
module C = Closure.Cast
exception CodegenError
exception NotImplemented
let (<<<) f g x = f (g x)
let translate (prog : C.program) = 
  (* Create LLVM Context *)
  let context = L.global_context () in

  (* Create LLVM compilation module into which
     we will generate code *)
  let _module = L.create_module context "lingo" in

  (* Build LLVM types *)
  let i32_t       = L.i32_type context in
  let i64_t       = L.i64_type context in
  let char_t      = L.i8_type context in
  let void_t      = L.void_type context in
  let i8_ptr_t  = L.pointer_type (L.i8_type context) in
  let bool_t      = L.i1_type context in
  let decl_struct_t name = L.named_struct_type context name in
  let def_struct_t name fields =  
    let llstruct_t = decl_struct_t name in
    L.struct_set_body llstruct_t (Array.of_list fields) false;
    llstruct_t
  in
  let adt_t = def_struct_t "adt" [i64_t; i8_ptr_t] in
  let clos_t = def_struct_t "clos" [i8_ptr_t; L.pointer_type i8_ptr_t] in
  let die_function = L.declare_function "__die__" (L.function_type void_t [||]) _module in
  let add_terminal builder instr =
      (match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder))
  in 
  ignore (adt_t); 
  let ltype_of_type = function
  | C.CIntT         -> i64_t
  | C.CBoolT        -> bool_t 
  | C.CharT         -> char_t
  | C.CDataTy _     -> adt_t 
  | C.CClosT        -> clos_t
  | C.BoxT          -> i8_ptr_t 
  in
  let create_function_t (cname, _, _, cty) = 
    let fun_t = L.function_type (L.pointer_type @@ ltype_of_type cty) ([| i8_ptr_t; L.pointer_type i8_ptr_t |]) in
    L.define_function cname fun_t _module
  in
  let cons_ts = 
    let cons_t i (cname, cty_list) = 
      let ts = List.map ltype_of_type cty_list in
      cname, (i, def_struct_t cname ts) in
    List.concat @@ List.map (List.mapi cons_t <<< snd) prog.datatys
  in
  let function_vals = List.map (fun ((name,_,_,_) as gl) -> name, create_function_t gl) prog.funs in
  let create_decl (name, (arg_ctys, out_cty)) =  
    let fn_t = L.function_type (ltype_of_type out_cty) (Array.map ltype_of_type @@ Array.of_list arg_ctys) in
    L.declare_function name fn_t _module
  in
  let _ = List.map create_decl prog.decls in
  let translate_cexpr fn builder = 
    let rec translate_cexpr value_to_set bb extra_args = function
    | C.CInt i -> 
      L.build_store (L.const_int i64_t i) value_to_set builder
    | C.CChar c -> 
      L.build_store (L.const_int char_t (int_of_char c)) value_to_set builder
    | C.CBool b -> 
      L.build_store (L.const_int bool_t (if b then 1 else 0)) value_to_set builder
    | C.CIf (predicate, then_expr, else_expr, _ty) -> 
        let brend = L.append_block context "end" fn in
        L.position_at_end brend builder; 

        let brtrue = L.append_block context "brtrue" fn in
        L.position_at_end brtrue builder; 
        ignore (translate_cexpr value_to_set brtrue extra_args then_expr);
        add_terminal builder (L.build_br brend); 

        let brfalse = L.append_block context "brfalse" fn in
        L.position_at_end brfalse builder; 
        ignore (translate_cexpr value_to_set brfalse extra_args else_expr);
        add_terminal builder (L.build_br brend);

        L.move_block_after brfalse brend;
        L.position_at_end bb builder; 
        let branch = 
          let cond_ptr = L.build_alloca bool_t "ifcond" builder in
          ignore (translate_cexpr cond_ptr bb extra_args predicate);
          let cond_val = L.build_load cond_ptr "cond_val" builder in 
          L.build_cond_br cond_val brtrue brfalse
        in
        add_terminal builder branch;
        L.position_at_end brend builder;
        value_to_set
    | C.Box (cexpr, cty) ->
      let unbox = L.build_alloca (ltype_of_type cty) "unbox" builder in
      ignore (translate_cexpr unbox bb extra_args cexpr);
      let box = L.build_bitcast unbox i8_ptr_t "box" builder in
      L.build_store box value_to_set builder
    | C.Unbox (cexpr, cty) ->
      let boxed = L.build_alloca i8_ptr_t "boxed" builder in
      ignore (translate_cexpr boxed bb extra_args cexpr);
      let unbox_ptr_ptr = L.build_bitcast boxed (L.pointer_type @@ L.pointer_type @@ ltype_of_type cty) "unbox_ptr_ptr" builder in
      let unbox_ptr = L.build_load unbox_ptr_ptr "unbox_ptr" builder in
      let unbox_val = L.build_load unbox_ptr "unbox_val" builder in
      L.build_store unbox_val value_to_set builder
    | C.CClos (cname, env, env_tys) ->
      let clos = value_to_set in 
      let clos_fn_ptr = L.build_struct_gep clos 0 "clos_fn_ptr" builder in   
      let raw_fn_ptr = L.build_bitcast (List.assoc cname function_vals) i8_ptr_t "raw_fn_ptr" builder in
      let _ = L.build_store raw_fn_ptr clos_fn_ptr builder in
      let env_ptr = L.build_malloc (L.array_type i8_ptr_t (List.length env)) "env_aloc" builder in
      let translate_env i (cexpr, cexpr_cty) = 
        let arg_raw_ptr_ptr = L.build_in_bounds_gep env_ptr (Array.map (L.const_int i32_t) [|0; i|]) "raw_closarg_ptr_ptr" builder in
        let arg_ptr = L.build_malloc (ltype_of_type cexpr_cty) "closarg_ptr" builder in
        ignore (translate_cexpr arg_ptr bb extra_args cexpr);
        let arg_raw_ptr = L.build_bitcast arg_ptr i8_ptr_t "raw_arg_ptr" builder in
        ignore (L.build_store arg_raw_ptr arg_raw_ptr_ptr builder);
      in
      ignore (List.mapi translate_env (List.combine env env_tys));
      ignore (L.build_store (L.build_bitcast env_ptr (L.pointer_type i8_ptr_t) "env_ptr_raw" builder) (L.build_struct_gep clos 1 "env" builder) builder);
      value_to_set
    | C.CApp (cexpr1, _, cexpr2, cty2, out_ty) ->
      let clos = L.build_alloca clos_t "app_lhs" builder in  
      let _ = translate_cexpr clos bb extra_args cexpr1 in
      let to_apply = L.build_alloca (ltype_of_type cty2) "app_rhs" builder in
      let _ = translate_cexpr to_apply bb extra_args cexpr2 in
      let to_apply = L.build_bitcast to_apply i8_ptr_t "raw_app_rhs" builder in
      let fn_t = L.pointer_type @@ L.function_type (L.pointer_type @@ ltype_of_type out_ty) ([| i8_ptr_t; L.pointer_type i8_ptr_t |]) in
      let fn_ptr = L.build_bitcast (L.build_load (L.build_struct_gep clos 0 "raw_fn_ptr_ptr" builder) "raw_fn_ptr" builder) fn_t "fn_ptr" builder in
      let args = L.build_load (L.build_struct_gep clos 1 "args_ptr" builder) "args" builder in  
      let app_res_ptr = L.build_call fn_ptr [| to_apply; args |] "app_res_ptr" builder in
      let app_res = L.build_load app_res_ptr "app_res" builder in
      L.build_store app_res value_to_set builder  
    | C.CArg (idx, cty) -> 
      let len = List.length extra_args in 
      if idx < len then 
        L.build_store (List.nth extra_args idx) value_to_set builder
      else if idx - len == 0 then
        let ptr = L.build_bitcast (L.param fn 0) (L.pointer_type @@ ltype_of_type cty) "arg_ptr" builder in 
        let arg = L.build_load ptr "arg" builder in
        L.build_store arg value_to_set builder
      else (
        let gep_ptr = L.build_bitcast (L.param fn 1) (L.pointer_type @@ L.array_type i8_ptr_t (idx - len)) "arg_gep_ptr" builder in
        let raw_ptr_ptr = L.build_gep gep_ptr [|L.const_int i32_t 0; L.const_int i32_t (idx - len - 1)|] "raw_arg_ptr_ptr" builder in
        let raw_ptr = L.build_load raw_ptr_ptr "raw_arg_ptr" builder in
        let ptr = L.build_bitcast raw_ptr (L.pointer_type @@ ltype_of_type cty) "arg_ptr" builder in 
        let arg = L.build_load ptr "arg" builder in
        L.build_store arg value_to_set builder)
    | C.CConstruction (name, cargs, _) ->
      let tag, cons_t = List.assoc name cons_ts in
      let args = List.map (fun t -> L.build_malloc t "carg_aloc" builder) (Array.to_list @@ L.struct_element_types cons_t) in
      List.iter (fun (arg, carg) -> ignore (translate_cexpr arg bb extra_args carg)) @@ List.combine args cargs;  
      let cons  = L.build_malloc cons_t "cons" builder in
      let build_cons (arg, i) = 
        let arg_val = L.build_load arg "carg_aloc_val" builder in
        L.build_store arg_val (L.build_struct_gep cons i "carg" builder) builder
      in
      List.iter (ignore <<< build_cons) (List.combine args (List.init (List.length args) (fun x -> x))); 
      let cons_ptr = L.build_bitcast cons (i8_ptr_t) "cons_vptr" builder in
      let tag_ptr = L.build_struct_gep value_to_set 0 "tag" builder in
      let data_ptr = L.build_struct_gep value_to_set 1 "data_ptr" builder in
      ignore (L.build_store (L.const_int i64_t tag) tag_ptr builder);
      ignore (L.build_store cons_ptr data_ptr builder);
      value_to_set
    | C.CCase (cscrut, _, calts, _out_cty) -> 
      let scrut_var = L.build_alloca adt_t "scrut" builder in
      ignore (translate_cexpr scrut_var bb extra_args cscrut);
      let scrut_tag_ptr = L.build_struct_gep scrut_var 0 "switch_tag_ptr" builder in
      let scrut_data = L.build_struct_gep scrut_var 1 "scrut_data" builder in
      let scrut_tag = L.build_load scrut_tag_ptr "switch_tag" builder in
      let brend = L.append_block context "case_continue" fn in
      let first_wc = List.find_map (fun x ->
        match x with 
        | C.CWildcard   (cexpr, _) -> Some cexpr 
        | C.CDestructor _ -> None
      ) calts in
      let destructors = List.filter_map (fun x ->
        match x with
        | C.CWildcard _ -> None
        | C.CDestructor (cname, num_abstr, cexpr, _) -> Some (cname, num_abstr, cexpr)) calts
      in
      let default_bb = L.append_block context "default" fn in
      L.position_at_end default_bb builder; 
      (match first_wc with
        | Some default_expr -> 
        ignore (translate_cexpr value_to_set default_bb extra_args default_expr);
        | _ -> 
        ignore (L.build_call (die_function) [||] "" builder);
        );
      ignore (L.build_br brend builder);
      L.position_at_end bb builder; 
      let switch = L.build_switch scrut_tag default_bb (List.length calts) builder in
      let translate_destructor value_to_set case_bb (cname, num_abstr, cexpr) = 
        L.position_at_end case_bb builder;  
        let cons_tag, cons_t = List.assoc cname cons_ts in
        let scrut_data_deref = L.build_load scrut_data "scrut_data_deref" builder in   
        let cons_ptr = L.build_bitcast scrut_data_deref (L.pointer_type cons_t) "cons_cast" builder in
        let extra_args' = List.init (num_abstr) (fun i -> 
          L.build_load (L.build_struct_gep cons_ptr i "cons_destruct_ptr" builder) "cons_destruct" builder) in
        L.add_case switch (L.const_int i64_t cons_tag) case_bb;
        let expr = translate_cexpr value_to_set case_bb (extra_args' @ extra_args) cexpr in
        ignore (L.build_br brend builder);
        L.position_at_end bb builder;
        expr
      in
      let case_bbs = List.init (List.length destructors) (fun _ -> L.append_block context "case" fn) in
      let cases = List.map2 (translate_destructor value_to_set) case_bbs destructors in
      List.iter ignore cases;
      L.move_block_after (List.nth case_bbs (List.length case_bbs - 1)) brend;
      L.position_at_end brend builder;
      switch 
    | C.CCall (cname, cexpr_list) ->  
      let alloc_args = List.map (fun (_, cty) -> L.build_alloca (ltype_of_type cty) "call_arg_ptr" builder) cexpr_list in
      ignore (List.map2 (fun aloc (expr, _) -> translate_cexpr aloc bb extra_args expr) alloc_args cexpr_list);
      let args = List.map (fun aloc -> L.build_load aloc "call_arg" builder) alloc_args in
      let arg_ctys, out_cty  = List.assoc cname prog.decls in
      let arg_ts = List.map ltype_of_type arg_ctys in
      let out_t = ltype_of_type out_cty in 
      let fun_t = L.function_type out_t (Array.of_list arg_ts) in  
      let fun_decl = L.declare_function cname fun_t _module in
      let ret = L.build_call fun_decl (Array.of_list args) "call_ret" builder in
      L.build_store ret value_to_set builder 
    in translate_cexpr  
  in 
  let build_fun (name, _, cexpr, cty) = 
    let fn_def = List.assoc name function_vals in
    let builder = L.builder_at_end context (L.entry_block fn_def) in
    let rval_ptr = L.build_malloc (ltype_of_type cty) "rval_ptr" builder in
    ignore (translate_cexpr fn_def builder rval_ptr (L.entry_block fn_def) [] cexpr);
    add_terminal builder (L.build_ret rval_ptr); 
  in
  List.iter build_fun prog.funs;
  let main_t = L.function_type i64_t [||] in   
  let main_fn = L.define_function "main" main_t _module in
  let builder = L.builder_at_end context (L.entry_block main_fn) in
  let rval = L.build_alloca (i64_t) "ret" builder in  
  ignore (translate_cexpr main_fn builder rval (L.entry_block main_fn) [] prog.main);
  add_terminal builder (L.build_ret (L.build_load rval "retval" builder));
  _module 



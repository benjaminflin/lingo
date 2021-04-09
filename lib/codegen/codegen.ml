module L = Llvm
module C = Closure.Cast
exception NotImplemented
let (<<<) f g x = f (g x)
let _translate (prog : C.program) = 
  (* Create LLVM Context *)
  let context = L.global_context () in

  (* Create LLVM compilation module into which
     we will generate code *)
  let _module = L.create_module context "lingo" in

  (* Build LLVM types *)
  let i64_t       = L.i64_type context in
  let void_t      =  L.void_type context in 
  let char_t      = L.i8_type context in
  let void_ptr_t  = L.pointer_type (L.i8_type context) in
  let bool_t      = L.i1_type context in
  let decl_struct_t name = L.named_struct_type context name in
  let def_struct_t name fields =  
    let llstruct_t = decl_struct_t name in
    L.struct_set_body llstruct_t (Array.of_list fields) false;
    llstruct_t
  in
  let adt_t = def_struct_t "adt" [i64_t; void_ptr_t] in
  let _def_anon_struct_t fields = L.struct_type context (Array.of_list fields) 
  in
  let _add_terminal builder f = 
    match (L.block_terminator) (L.insertion_block builder) with
      | Some _ -> ()
      | None -> ignore (f builder)
  in

  let add_terminal builder instr =
      (match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder))
  in 

  let closure_ts = 
    let ts : (string * L.lltype) list ref = {contents = []} in
    let rec ltype_of_type = function
      | C.CIntT         -> i64_t
      | C.CBoolT        -> bool_t 
      | C.CharT         -> char_t
      | C.CDataTy cname -> L.named_struct_type context cname
      | C.CClosT cname  -> 
        (match List.assoc_opt cname !ts with
        | Some ty -> ty
        | None -> 
          snd @@ translate_closure_t (cname, List.assoc cname prog.closures))
      | C.BoxT          -> void_ptr_t 
    and translate_closure_t (cname, tys) = 
      let globals 
        = List.map (fun (cname, carg_ts, _, cret_t) -> cname, (carg_ts, cret_t)) prog.globals
      in
      let carg_ts, cret_t = List.assoc cname globals in
      let fun_ty = L.function_type (ltype_of_type cret_t) (Array.of_list @@ List.map (L.pointer_type <<< ltype_of_type) carg_ts) in
      let t = cname, def_struct_t cname (List.map L.pointer_type (fun_ty :: (List.map (ltype_of_type) tys))) in
      ts := t::!ts;
      t
    in List.map translate_closure_t prog.closures
  in
  ignore (adt_t); 
  let ltype_of_type = function
  | C.CIntT         -> i64_t
  | C.CBoolT        -> bool_t 
  | C.CharT         -> char_t
  | C.CDataTy _     -> adt_t 
  | C.CClosT cname  -> List.assoc cname closure_ts
  | C.BoxT          -> void_ptr_t 
  in
  let create_function_t (cname, carg_tys, _, cty) = 
    let fun_t = L.function_type (ltype_of_type cty) (Array.of_list @@ List.map ltype_of_type carg_tys) in
    L.declare_function cname fun_t _module
  in
  let cons_ts = 
    let cons_t i (cname, cty_list) = 
      let ts = List.map ltype_of_type cty_list in
      cname, (i, def_struct_t cname ts) in
    List.concat @@ List.map (List.mapi cons_t <<< snd) prog.datatys
  in
  let _function_ts = List.map create_function_t prog.globals in
  let translate_cexpr fn builder = 
    let rec translate_cexpr value_to_set bb = function
    | C.CInt i -> 
      L.build_store (L.const_int i64_t i) value_to_set builder
    | C.CChar c -> 
      L.build_store (L.const_int char_t (int_of_char c)) value_to_set builder
    | C.CBool b -> 
      L.build_store (L.const_int bool_t (if b then 1 else 0)) value_to_set builder
    | C.CIf (predicate, then_expr, else_expr, ty) -> 
        let value_to_set = L.build_alloca (ltype_of_type ty) "ifres" builder in
        let brend = L.append_block context "end" fn in
        L.position_at_end brend builder; 

        let brtrue = L.append_block context "brtrue" fn in
        L.position_at_end brtrue builder; 
        ignore (translate_cexpr value_to_set brtrue then_expr);
        add_terminal builder (L.build_br brend); 

        let brfalse = L.append_block context "brfalse" fn in
        L.position_at_end brfalse builder; 
        ignore (translate_cexpr value_to_set brfalse else_expr);
        add_terminal builder (L.build_br brend);

        L.move_block_after brfalse brend;
        L.position_at_end bb builder; 
        let branch = 
          let v = L.build_alloca bool_t "ifcond" builder in
          ignore (translate_cexpr v bb predicate);
          L.build_cond_br v brtrue brfalse
        in
        add_terminal builder branch;
        L.position_at_end brend builder;
        value_to_set
    | C.Box (cexpr, cty) ->
      let unbox = L.build_alloca (ltype_of_type cty) "unbox" builder in
      ignore (translate_cexpr unbox bb cexpr);
      let box = L.build_bitcast unbox void_ptr_t "box" builder in
      L.build_store box value_to_set builder
    | C.Unbox (cexpr, cty) ->
      let unbox = L.build_alloca void_ptr_t "box" builder in
      ignore (translate_cexpr unbox bb cexpr);
      let box = L.build_bitcast unbox (ltype_of_type cty) "unbox" builder in
      L.build_store box value_to_set builder
    | C.CClos (cname, env, _) ->
      let clos_t = (List.assoc cname closure_ts) in
      let clos = L.build_alloca 
        clos_t "clos" builder 
      in 
      let translate_env i cexpr = 
        let new_value_to_set = 
          L.build_load ( 
          L.build_struct_gep clos (i + 1) "closarg_ptr" builder) "closarg" builder in
        ignore (translate_cexpr new_value_to_set bb cexpr);
      in
      ignore (List.map2 translate_env (List.init (List.length env) (fun x -> x)) env);
      let to_set = L.build_pointercast value_to_set (L.pointer_type @@ L.pointer_type clos_t) "closc" builder in
      L.build_store clos to_set builder  
    | C.CApp (C.CClos (cname, env, _) as cclos, cty1, cexpr2, cty2, out_ty) ->
      let apply_fn = (match L.lookup_function ("apply_" ^ cname) _module with
      | Some vl -> vl
      | None -> 
        let app_fn_t = L.function_type (ltype_of_type out_ty) 
          [| L.pointer_type @@ ltype_of_type cty1; L.pointer_type @@ ltype_of_type cty2 |]  in 
        let app_fn = L.define_function ("apply_" ^ cname) app_fn_t _module in 
        let app_fn_body = 
          L.position_at_end (L.entry_block app_fn) builder;
          let clos = L.param app_fn 0 in
          let arg = L.param app_fn 1 in
          let fn_ptr = L.build_load (L.build_struct_gep clos 0 "fn_ptr_ptr" builder) "fn_ptr" builder in
          let args =  
            List.map (fun i -> 
              L.build_load (
              L.build_struct_gep clos (i + 1) "closarg_ptr" builder) "closarg" builder)
            (List.init (List.length env) (fun x -> x)) in
          let ret = L.build_call fn_ptr (Array.of_list (args @ [arg])) "ret" builder in
          L.build_ret ret builder
        in 
        ignore (app_fn_body);
        L.position_at_end bb builder;
        app_fn
      )
      in
      let clos = L.build_alloca (ltype_of_type cty1) "clos" builder in
      ignore (translate_cexpr clos bb cclos);
      let arg = L.build_alloca (ltype_of_type cty2) "arg" builder in
      ignore (translate_cexpr arg bb cexpr2);
      let ret_val = L.build_call apply_fn ([| clos; arg |]) "ret_val" builder in
      L.build_store ret_val value_to_set builder
    | CArg (idx, _) -> 
      L.build_store (L.param fn idx) value_to_set builder
    | CConstruction (name, cargs, _) ->
      let tag, cons_t = List.assoc name cons_ts in
      let args = List.map (fun t -> L.build_malloc t "carg_aloc" builder) (Array.to_list @@ L.struct_element_types cons_t) in
      List.iter (fun (arg, carg) -> ignore (translate_cexpr arg bb carg)) @@ List.combine args cargs;  
      let cons  = L.build_malloc cons_t "cons" builder in
      let build_cons (arg, i) = 
        let arg_val = L.build_load arg "carg_aloc_val" builder in
        L.build_store arg_val (L.build_struct_gep cons i "carg" builder) builder
      in
      List.iter (ignore <<< build_cons) (List.combine args (List.init (List.length args) (fun x -> x))); 
      let cons_ptr = L.build_bitcast cons (void_ptr_t) "cons_vptr" builder in
      let tag_ptr = L.build_struct_gep value_to_set 0 "tag" builder in
      let data_ptr = L.build_struct_gep value_to_set 1 "data_ptr" builder in
      ignore (L.build_store (L.const_int i64_t tag) tag_ptr builder);
      ignore (L.build_store cons_ptr data_ptr builder);
      value_to_set

    | CCase (cscrut, scrut_cty, calts, _out_cty) -> 
      let scrut_var = L.build_alloca (ltype_of_type scrut_cty) "scrut" builder in
      ignore (translate_cexpr scrut_var bb cscrut);
      let default_bb = in 
      ignore (L.build_switch (scrut_var) bb (List.length (calts)) builder);
      raise NotImplemented 
    | _ -> raise NotImplemented

    (*
    | CConstruction of cname * cexpr list * cty
    *)
    in translate_cexpr  
  in 
  let main_t = L.function_type void_t [||] in   
  let main_fn = L.define_function "main" main_t _module in
  let builder = L.builder_at_end context (L.entry_block main_fn) in
  let rval = L.build_alloca (adt_t) "retval" builder in  
  ignore (translate_cexpr main_fn builder rval (L.entry_block main_fn) prog.main);
  add_terminal builder L.build_ret_void;
  _module



(* OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD *)
module T = Core.Typecheck

let translate core_prog = 
  let context = L.global_context () in
  let _module = L.create_module context "lingo" in
  let i64_t   = L.i64_type context in
  let void_t  = L.void_type context in
(* 
  let ltype_of_type = function
      C.BaseT (C.IntT) -> i64_t
    | _ -> void_t (* CHANGE THIS LMAO YOU DUMB IDIOTS *)
  in *)

  let printi64_t : L.lltype = 
    L.function_type void_t [| i64_t |] in
  
  let printi64_func : L.llvalue = 
    L.declare_function "print_int" printi64_t _module in
  let rec convert_core_check_expr = function
      T.Infer (T.App (T.Global "printInt", body)) -> convert_core_check_expr body
    | T.Infer (T.Int i) -> L.const_int i64_t i
    | _ -> raise NotImplemented
  in
  
  let add_terminal builder instr =
      (match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder))
  in 
  let convert_core_prog = (function
    | T.LetDef ("main", _, expr) -> ( 
      let main_t = L.function_type void_t [||] in   
      let main  = L.define_function "main" main_t _module in
      let builder = L.builder_at_end context (L.entry_block main) in
      let _     = L.build_call printi64_func [| (convert_core_check_expr expr) |] "" builder in
      add_terminal builder L.build_ret_void)
    | _ -> raise NotImplemented) in
  let _ = List.map convert_core_prog core_prog in
  _module


  (* print_string @@ L.string_of_llmodule @@ _translate { datatys = [("Tuple", ["Tuple", [BoxT; BoxT]])]; closures = ["f", [CIntT]]; globals = ["f", [CIntT; CIntT], CInt 0, CIntT]; main = CClos ("f", [CInt 0], CClosT "f"); };; *)
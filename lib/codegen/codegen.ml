module L = Llvm
module C = Core.Typecheck

exception NotImplemented

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
      C.Infer (C.App (C.Var "printInt", body)) -> convert_core_check_expr body
    | C.Infer (C.Lit i) -> L.const_int i64_t i
    | _ -> raise NotImplemented
  in
  
  let add_terminal builder instr =
      (match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder))
  in 
  let convert_core_prog = (function
    | C.LetDef ("main", _, expr) -> ( 
      let main_t = L.function_type void_t [||] in   
      let main  = L.define_function "main" main_t _module in
      let builder = L.builder_at_end context (L.entry_block main) in
      let _     = L.build_call printi64_func [| (convert_core_check_expr expr) |] "" builder in
      add_terminal builder L.build_ret_void)
    | _ -> raise NotImplemented) in
  let _ = List.map convert_core_prog core_prog in
  _module

open Monad
module StringMap = Map.Make (String)

type name = string

type mult 
  = One 
  | Unr
  | MVar of name 
  | Times of (mult * mult)

type base_t = IntT | BoolT
type ty
  = BaseT of base_t 
  | TVar of name
  | Data of (name * mult list * ty list)  
  | LamT of (mult * ty * ty)
  | Forall of (name * ty)
  | ForallM of (name * ty)

type base_e 
  = IntE of int
  | BoolE of bool
  | CharE of char

type expr  
  = BaseE of base_e
  | Var of name
  | Lam of (name * mult * ty * expr)
  | App of (expr * expr) 
  | MLam of (name * expr) 
  | MApp of (expr * mult) 
  | TLam of (name * expr)
  | TApp of (expr * ty)
  | Construction of (name)
  | Let of ((name * mult * ty * expr) list * expr) 
  | Case of (mult * expr * case_alt list)
  | If of (expr * expr * expr) 
and case_alt 
  = Constructor of (name * name list * expr)
  | Wildcard of expr


exception NotImplemented 
exception NotAMLam of ty
exception NotInScope of name
exception NotAFunction of expr
exception Mismatch of (ty * ty)
exception UnsatisfiableConstraint of (mult * mult)
exception AlreadyBound of name
exception NotADataType of ty 
exception InvalidConstructor 

type env    = ty StringMap.t
type usage  = mult StringMap.t 
type constr = LE of (mult * mult)

module Check = RWS (struct type t = env end) (UnitMonoid) (struct type t = constr list end)
module M = StringMap
open Check
let (let*) = bind
let (&) m m' = bind m (fun _ -> m')

let (<<<) f g x = f (g x)
let add_constr c = 
  let* cs = get in 
  put (c::cs)

let lookup_var x =
  let* map = ask in 
  match M.find_opt x map with
    | Some ty -> pure (ty, M.singleton x One)
    | _ -> raise (NotInScope x)

let simp = function
  | Times (a, One)  -> a
  | Times (One, a)  -> a
  | Times (Unr, _)  -> Unr
  | Times (_, Unr)  -> Unr
  | a               -> a
let add a b = 
  let f _ _ _ = Some Unr in
  M.map (simp) (M.union f a b)

let mult_usage a b = 
  let f _ a b = Some (Times (a, b)) in
  M.map (simp) (M.union f a b)
let mult_mult m a = M.map (simp) (M.map (fun a -> Times (m, a)) a)

let rec subst_mult_mult subst mult = match (subst, mult) with
  | (MVar a, b), (MVar c) -> if a = c then b else (MVar c)
  | x, Times (a, b)       -> Times ((subst_mult_mult x a), (subst_mult_mult x b))
  | _, m                  -> m 
let rec subst_mult_ty subst ty = match (subst, ty) with
  | x, LamT (m, t, t') -> LamT ((subst_mult_mult x m), (subst_mult_ty x t), (subst_mult_ty x t'))
  | x, ForallM (p, t)  -> ForallM (p, subst_mult_ty x t)
  | x, Forall (p, t)   -> Forall (p, subst_mult_ty x t)
  | _, t                -> t

let subst_mult_constr subst (LE (m, m')) = LE (subst_mult_mult subst m, subst_mult_mult subst m')
let subst_mult_constr_list subst = List.map (subst_mult_constr subst)

let rec subst_ty_name subst ty = match (subst, ty) with
  | (x, t), (TVar y)   -> if x = y then t else (TVar y)
  | s, LamT (m, t, t') -> LamT (m, subst_ty_name s t, subst_ty_name s t')
  | s, Forall (x, t)   -> Forall (x, subst_ty_name s t)
  | s, ForallM (x, t)  -> ForallM (x, subst_ty_name s t)
  | _, t               -> t

let reduce_constraints =
  let* cs = get in 
  let  cs = List.map (fun (LE (m, m')) -> LE (simp m, simp m')) cs in
  let reduce cs = function
    | LE (Unr, One) -> raise (UnsatisfiableConstraint (Unr, One))
    | LE (One, Unr) -> cs
    | LE (Unr, Unr) -> cs
    | LE (One, One) -> cs
    | c             -> (c :: cs)
  in 
  put (List.fold_left reduce [] cs)

let check_fresh name = 
  let* env = ask in
  if StringMap.mem name env then
    raise (AlreadyBound name)
  else
    pure ()

(* extracts multiplicites from a constructor type *)
(* Just : @a a -> Maybe {a} *)
(* Just : @a (a -> a) -> Maybe {a} *)
let rec extract_mults = function
| ForallM(_, t)   -> extract_mults t 
| Forall(_, t)    -> extract_mults t 
| Data(_, _, _)   -> [] 
| LamT(m, _, t2)  -> m :: (extract_mults t2)
| _               -> raise InvalidConstructor

(* Assumes rank-1 data constructors *)
let rec extract_names = function
| ForallM(n, t)   -> n :: (extract_names t)
| Forall(_, t)    -> extract_names t
| _               -> raise InvalidConstructor

  (* = BaseT of base_t 
  | TVar of name
  | Data of (name * mult list * ty list)  
  | LamT of (mult * ty * ty)
  | Forall of (name * ty)
  | ForallM of (name * ty *)


let rec check expr = 
  match expr with
  | BaseE (IntE _) -> 
    pure (BaseT IntT, M.empty) 

  | BaseE (BoolE _) -> 
    pure (BaseT BoolT, M.empty)

  | (Var x) -> lookup_var x
  | (Construction x) -> lookup_var x
  | (Lam (x, m, t, e)) ->
    let* (t', u) = local (M.add x t) (check e) in
    let m' = (match M.find_opt x u with 
      | Some u -> u
      | None -> Unr) in 
    add_constr (LE (m', m)) &
    pure (LamT (m, t, t'), M.remove x u)
  
  | App (e1, e2) -> 
    let* (t1, u1) = check e1 in
    let* (t2, u2) = check e2 in
    (match t1 with
      | LamT (p, a, b) -> 
        if a = t2 then 
          pure (b, add u1 (mult_mult p u2))
        else
          raise (Mismatch (t2, a))
      | _ -> raise (NotAFunction e1))
  | MLam (x, e) -> 
    check_fresh x &
    let* (t, u) = check e in
    pure (ForallM (x, t), u)
  | MApp (e, p) -> 
    let* (t', u) = check e in
    (match t' with 
      | ForallM(q, t) ->
          modify (subst_mult_constr_list (MVar q, p)) &
          reduce_constraints &
          pure (subst_mult_ty (MVar q, p) t, u)
      | _ -> raise (NotAMLam t')
    )
  | TLam (name, e) ->
    check_fresh name &
    let* (t, u) = check e in
    pure (Forall (name, t), u)
  | TApp (e, t) -> 
    let* (t', u) = check e in
    (match t' with 
      | Forall(name, t'') ->
          pure (subst_ty_name (name, t) t'', u)
      | _ -> raise (NotAMLam t')
    )
  | Let (l, e) ->
    let to_map = StringMap.of_seq <<< List.to_seq in
    let add_vars = 
      StringMap.union (fun _ _ _ -> None)
      @@ to_map 
      @@ List.map (fun (name, _, ty, _) -> name, ty) l in
    let* tu_pairs = 
      map_m (fun x -> x) 
      @@ List.map (fun (_, _, _, e) -> local add_vars @@ check e) l in
    let u_total = 
      List.fold_left (fun u' (p, u) -> add u' (mult_mult p u)) (StringMap.empty)
      @@ List.combine (List.map (fun (_, m, _, _) -> m) l)
      @@ List.map snd tu_pairs in
    let* (t, u) = local add_vars @@ check e in
    pure (t, add u u_total)  
  | If (e1, e2, e3) -> 
      let* (t1, u1) = check e1 in
      let* (t2, u2) = check e2 in 
      let* (t3, u3) = check e3 in
      (match t1 with
        | BaseT (BoolT) -> 
            if t2 = t3 then
              pure (t2, add u1 (mult_usage u2 u3))
            else 
              raise (Mismatch (t2, t3))
        | _ -> raise (Mismatch (t1, BaseT (BoolT))))
  | Case (m, e, alts) ->
      let* (t1, u1) = check e in
      let _ = (match t1 with 
        | Data(name, ml, tl) -> raise NotImplemented 
        | _ -> raise @@ NotADataType t1
      ) in
      pure (BaseT BoolT, u1)
  | _ -> raise NotImplemented


(* let check_case_alt m ml = function 
| Constructor(c, nl, e) -> 
  let* (t, _) = lookup_var c in
  let us = extract_mults t in
  let ps = extract_names ml in
  List.fold_left (subst_mult_mult) ml
| Wildcard e -> pure () *)
            
(* Construction and Cases *)

(* 
let _ =
  let lexbuf = Lexing.from_channel stdin in
  let expr = Parser.expr Scanner.tokenize lexbuf in
  let result = eval expr in
  print_endline (string_of_int result)
*)

(* MLam ("p", TLam ("t", Lam ("x", MVar "p", TBase TInt, Var "x"))*)

(* 
Example 1: UnsatisfiableConstraint
let add2 = App (App (Var "+", Var "x"), Var "x") in 
let rws = check @@ MApp (MLam ("p", Lam ("x", MVar "p", BaseT IntT, add2)), One) in 
let plus_ty = LamT (One, BaseT IntT, LamT (One, BaseT IntT, BaseT (IntT))) in 
Check.run_rws rws (StringMap.singleton "+" plus_ty) []

Example 2: If Statement UnsatisfiableConstraint
let add x = App (App (Var "+", Var "x"), x) in 
let ifstmt = If (BaseE (BoolE true), add (Var "x"), add (BaseE (IntE 1))) in 
let rws = check @@ MApp (MLam ("p", Lam ("x", MVar "p", BaseT IntT, ifstmt)), One) in 
let plus_ty = LamT (One, BaseT IntT, LamT (One, BaseT IntT, BaseT (IntT))) in 
Check.run_rws rws (StringMap.singleton "+" plus_ty) []

Example 3: Constructors vs Vars
let just_ty = Forall ("a", LamT (Unr, TVar "a", TVar "Maybe")) in
let rws = check @@ (Construction "Just") in
Check.run_rws rws (StringMap.singleton "Just" just_ty) []
*)
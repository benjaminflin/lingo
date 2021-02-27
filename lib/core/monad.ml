module type FUNCTOR = sig
    type 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
end

module type APPLICATIVE = sig
    include FUNCTOR
    val ap : ('a -> 'b) t -> 'a t -> 'b t
    val pure : 'a -> 'a t 
end

module type MONAD = sig
    include APPLICATIVE
    val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module type MONOID = sig
    type t
    val empty : t
    val append : t -> t -> t
end

module UnitMonoid : MONOID = struct
    type t = unit
    let empty = ()
    let append _ _ = ()
end

module FromBind (M : sig 
    type 'a t
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val pure : 'a -> 'a t
end) : (MONAD with type 'a t = 'a M.t) = struct
    type 'a t = 'a M.t
    let (let*) = M.bind
    let map f ma = let* a = ma in M.pure (f a)
    let ap mf ma =
        let* f = mf in
        let* a = ma in 
        M.pure (f a)  
    let pure = M.pure 
    let bind = M.bind
end

module Identity : MONAD = FromBind (struct
    type 'a t = 'a
    let bind a f = f a
    let pure a = a
end)

module type T = sig
    type t
end


module RWS = functor (R : T) (W : MONOID) (S : T) -> struct 
    type ('s, 'a, 'w) rwsresult = ('s * 'a * 'w) 
    type ('r, 'w, 's, 'a) rws = RWS of ('r -> 's -> ('s, 'a, 'w) rwsresult)
    include FromBind (struct 
        type 'a t = (R.t, W.t, S.t, 'a) rws 
        let bind (RWS m) f = RWS (fun r s -> 
            let (s', a, w) = m r s in 
            let (RWS f') = f a in
            let (s'', a', w') = f' r s' in
            (s'', a', W.append w w')
        )
        let pure x = RWS (fun _ s -> (s, x, W.empty))  
    end)
    let ask = RWS (fun r s -> (s, r, W.empty))
    let asks f = RWS (fun r s -> (s, f r, W.empty))
    let get = RWS (fun _ s -> (s, s, W.empty))

    let put x = RWS (fun _ _ -> (x, (), W.empty))

    let modify f = let (let*) = bind in 
        let* x = get in
        put (f x)
    let local f (RWS m) = RWS (fun r s -> m (f r) s)
    let tell w = RWS (fun _ s -> (s, (), w))
    let run_rws (RWS m) = m

    let map_m f xs = 
        let g a r =
            let (let*) = bind in
            let* x = f a in
            let* xs = r in
            pure (x::xs)
        in
        List.fold_right g xs (pure [])
end

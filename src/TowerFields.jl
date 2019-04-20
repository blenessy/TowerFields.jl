module TowerFields
    # export FQ2, FQ3, FQ4, FQ6, FQ12, AfflinePoint
    # include("Common.jl")

    # module Types
    #     export FQ2, FQ3, FQ4, FQ6, FQ12, AfflinePoint
    #     include("Common.jl")
    # end

    module Common
        const FQ2 = Tuple{T, T} where T
        const FQ3 = Tuple{T, T, T} where T
        const FQ6 = Tuple{T, T, T} where {T <: FQ2}
        const FQ12 = Tuple{T, T} where {T <: FQ6}    
        zero(a::FQ2) = (zero(a[1]), zero(a[2]))
        zero(a::FQ3) = (zero(a[1]), zero(a[2]), zero(a[3]))
        zero(a) = Base.zero(a)
        one(a::FQ2) = (one(a[1]), zero(a[2]))
        one(a::FQ3) = (one(a[1]), zero(a[2]), zero(a[3]))
        one(a) = Base.one(a)
    end

    module BigIntField
        using ..Common: FQ2, FQ3, zero, one, iszero, isone
        include("BigIntField.jl")
    end

    module TowerField12
        using ..Common: FQ2, FQ6, FQ12
        using ..BigIntField
        const β = -1
        const ξ = (1, 1)
        const γ = ((0, 0), (1, 0), (0, 0))
        mulroot(x) = -x # β = -1
        mulroot(x::FQ2) = (x[1] - x[2], x[1] + x[2]) # ξ = (1, 1)
        mulroot(x::FQ6) = (mulroot(x[3]), x[1], x[2]) # γ = ((0, 0), (1, 0), (0, 0))
        function create_frobmap(q)
            g2 = BigIntField.powmod(q, mulroot, β, fld(q - 1, 2))
            g2sq = BigIntField.sqmod(q, mulroot, g2)
            g6 = BigIntField.powmod(q, mulroot, ξ, fld(q - 1, 3))
            g6sq = BigIntField.sqmod(q, mulroot, g6)
            g12 = BigIntField.powmod(q, mulroot, γ, fld(q - 1, 2))
            g12sq = BigIntField.sqmod(q, mulroot, g12)
            frobmap(x::FQ2) = (g2, g2sq)
            frobmap(x::FQ6) = (g6, g6sq)
            frobmap(x::FQ12) = (g12, g12sq)
            return frobmap
        end
    end

    module BLS12381Field
        using ..Common: zero, one, iszero, isone, FQ2
        using ..BigIntField
        using ..TowerField12

        # Field Params
        const ABS_X = 15132376222941642752
        const X_IS_NEG = true
        const R = 52435875175126190479447740508185965837690552500527637822603658699938581184513
        const Q = 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559787

        # Frobenius map function
        const frobmap = TowerField12.create_frobmap(Q)

        # API
        add(a, b) = BigIntField.addmod(Q, a, b)
        double(a) = BigIntField.addmod(Q, a, a)
        sub(a, b) = BigIntField.submod(Q, a, b)
        sub(a) = BigIntField.submod(Q, zero(a), a)
        mul(a, b) = BigIntField.mulmod(Q, TowerField12.mulroot, a, b)
        square(a) = BigIntField.sqmod(Q, TowerField12.mulroot, a)
        inv(a) = BigIntField.invmod(Q, TowerField12.mulroot, a)
        pow(a, b) = BigIntField.powmod(Q, TowerField12.mulroot, a, b)
        frob(a) = BigIntField.frobmod(Q, frobmap, TowerField12.mulroot, a)
        conj(a::FQ2) = (a[1], sub(a[2]))
        powx(a::FQ2) =  X_IS_NEG ? conj(pow(a, ABS_X)) : pow(a, ABS_X)
        div(a, b) = mul(a, inv(b))
        const +, -, *, //, ^, neg = add, sub, mul, div, pow, sub
    end

end

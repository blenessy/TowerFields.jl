# define FQ
const FQ = Integer

# GMP lib dependency
addmod(q::Integer, a::Integer, b::Integer) = mod(a + b, q)
submod(q::Integer, a::Integer, b::Integer) = mod(a - b, q)
mulmod(q::Integer, _::Function, a::Integer, b::Integer) = mod(a * b, q)
invmod(a::Integer, q::Integer) = Base.invmod(a, q)

sub(a::Integer, b::Integer) = a - b
sub(a::FQ2, b::FQ2) = (sub(a[1], b[1]), sub(a[2], b[2]))
sub(a::FQ3, b::FQ3) = (sub(a[1], b[1]), sub(a[2], b[2]), sub(a[3], b[3]))

add(a::Integer, b::Integer) = a + b
add(a::FQ2, b::FQ2) = (add(a[1], b[1]), add(a[2], b[2]))
add(a::FQ3, b::FQ3) = (add(a[1], b[1]), add(a[2], b[2]), add(a[3], b[3]))

# modular addition function
addmod(q::Integer, a::FQ2, b::FQ2) = (
    addmod(q, a[1], b[1]),
    addmod(q, a[2], b[2]),
)
addmod(q::Integer, a::FQ3, b::FQ3) = (
    addmod(q, a[1], b[1]),
    addmod(q, a[2], b[2]),
    addmod(q, a[3], b[3]),
)

# modular subtraction
submod(q::Integer, a::FQ2, b::FQ2) = (
    submod(q, a[1], b[1]),
    submod(q, a[2], b[2]),
)
submod(q::Integer, a::FQ3, b::FQ3) = (
    submod(q, a[1], b[1]),
    submod(q, a[2], b[2]),
    submod(q, a[3], b[3]),
)

# modular multiplication
sqmod(q::Integer, mulroot::Function, a::Integer) = mulmod(q, mulroot, a, a)

function sqmod(q::Integer, mulroot::Function, a::FQ2)
    # Squaring: Guide to PBC Algo. 5.17
    a0, a1 = a 
    v0 = sub(a0, a1)
    v3 = mulroot(a1)
    v3 = sub(a0, v3)
    v2 = mulmod(q, mulroot, a0, a1)
    v0 = add(mulmod(q, mulroot, v0, v3), v2)
    c1 = addmod(q, v2, v2)
    c0 = addmod(q, v0, mulroot(v2))
    return (c0, c1)
end

mulmod(q::Integer, mulroot::Function, a::FQ2, b::Integer) = (
    mulmod(q, mulroot, b, a[1]),
    mulmod(q, mulroot, b, a[2]),
)
mulmod(q::Integer, mulroot::Function, a::Integer, b::FQ2) = (
    mulmod(q, mulroot, a, b[1]),
    mulmod(q, mulroot, a, b[2]),
)
function mulmod(q::Integer, mulroot::Function, a::FQ2, b::FQ2)
    # Multiplication: Guide to PBC Algo. 5.16
    a0, a1 = a
    b0, b1 = b
    v0 = mulmod(q, mulroot, a0, b0)
    v1 = mulmod(q, mulroot, a1, b1)
    c0 = addmod(q, v0, mulroot(v1))
    c1 = mulmod(q, mulroot, add(a0, a1), add(b0, b1))
    c1 = submod(q, c1, add(v0, v1))
    return (c0, c1)
end

mulmod(q::Integer, mulroot::Function, a::FQ3, b::Integer) = (
    mulmod(q, mulroot, b, a[1]),
    mulmod(q, mulroot, b, a[2]),
    mulmod(q, mulroot, b, a[3]),
)
mulmod(q::Integer, mulroot::Function, a::Integer, b::FQ3) = (
    mulmod(q, mulroot, a, b[1]),
    mulmod(q, mulroot, a, b[2]),
    mulmod(q, mulroot, a, b[3]),
)
function sqmod(q::Integer, mulroot::Function, a::FQ3)
    # Squaring: Guide to PBC Algo. 5.22
    a0, a1, a2 = a
    v4 = mulmod(q, mulroot, a0, a1)
    v4 = add(v4, v4)
    v5 = sqmod(q, mulroot, a2)
    c1 = addmod(q, mulroot(v5), v4)
    v2 = sub(v4, v5)
    v3 = sqmod(q, mulroot, a0)
    v4 = add(sub(a0, a1), a2)
    v5 = mulmod(q, mulroot, a1, a2)
    v5 = add(v5, v5)
    v4 = sqmod(q, mulroot, v4)
    c0 = addmod(q, mulroot(v5), v3)
    c2 = addmod(q, v2, add(v4, sub(v5, v3)))
    return (c0, c1, c2)
end

function mulmod(q::Integer, mulroot::Function, a::FQ3, b::FQ3)
    # Multiplication: Guide to PBC Algo. 5.21
    a0, a1, a2 = a
    b0, b1, b2 = b
    v0 = mulmod(q, mulroot, a0, b0)
    v1 = mulmod(q, mulroot, a1, b1)
    v2 = mulmod(q, mulroot, a2, b2)
    c0 = mulmod(q, mulroot, add(a1, a2), add(b1, b2))
    c0 = sub(c0, add(v1, v2))
    c0 = addmod(q, mulroot(c0), v0)
    c1 = mulmod(q, mulroot, add(a0, a1), add(b0, b1))
    c1 = sub(c1, add(v0, v1))
    c1 = addmod(q, c1, mulroot(v2))
    c2 = mulmod(q, mulroot, add(a0, a2), add(b0, b2))
    c2 = addmod(q, sub(c2, add(v0, v2)), v1)
    return (c0, c1, c2)
end

invmod(q::Integer, _::Function, a::Integer) = invmod(a, q)
function invmod(q::Integer, mulroot::Function, a::FQ2)
    # Inversion: Guide to PBC Algo. 5.19
    a0, a1 = a
    v0 = sqmod(q, mulroot, a0)
    v1 = sqmod(q, mulroot, a1)
    v0 = sub(v0, mulroot(v1))
    v1 = invmod(q, mulroot, v0)
    c0 = mulmod(q, mulroot, a0, v1)
    c1 = mulmod(q, mulroot, sub(zero(a1), a1), v1)
    return (c0, c1)
end

function invmod(q::Integer, mulroot::Function, a::FQ3)
    # Inversion: Guide to PBC Algo. 5.23
    a0, a1, a2 = a
    v0 = sqmod(q, mulroot, a0)
    v1 = sqmod(q, mulroot, a1)
    v2 = sqmod(q, mulroot, a2)
    v3 = mulmod(q, mulroot, a0, a1)
    v4 = mulmod(q, mulroot, a0, a2)
    v5 = mulmod(q, mulroot, a1, a2)
    A = sub(v0, mulroot(v5))
    B = sub(mulroot(v2), v3)
    C = sub(v1, v4)
    v6a = mulmod(q, mulroot, a0, A)
    v6b = mulroot(mulmod(q, mulroot, a2, B))
    v6c = mulroot(mulmod(q, mulroot, a1, C))
    v6 = add(v6a, add(v6b, v6c))
    F = invmod(q, mulroot, v6)
    c0 = mulmod(q, mulroot, A, F)
    c1 = mulmod(q, mulroot, B, F)
    c2 = mulmod(q, mulroot, C, F)
    return (c0, c1, c2)
end

# modular exponentiation
# TODO: Optimise
function powmod(q::Integer, mulroot::Function, base, exp::Integer)
    if exp < 2
        if exp < 0
            return invmod(q, mulroot, powmod(q, mulroot, base, -exp))
        end
        return exp == 0 ? one(base) : base
    end
    c = powmod(q, mulroot, sqmod(q, mulroot, base), fld(exp, 2))
    return isodd(exp) ? mulmod(q, mulroot, c, base) : c
end

frobmod(q::Integer, frobmap::Function, mulroot::Function, a::Integer) = a
function frobmod(q::Integer, frobmap::Function, mulroot::Function, a::FQ2)
    g = frobmap(a)[1]
    a1 = frobmod(q, frobmap, mulroot, a[1])
    a2 = frobmod(q, frobmap, mulroot, a[2])
    a = (a1, mulmod(q, mulroot, a2, g))
    return a
end
function frobmod(q::Integer, frobmap::Function, mulroot::Function, a::FQ3)
    g, g2 = frobmap(a)
    a1 = frobmod(q, frobmap, mulroot, a[1])
    a2 = frobmod(q, frobmap, mulroot, a[2])
    a3 = frobmod(q, frobmap, mulroot, a[3])
    a = (a1, mulmod(q, mulroot, a2, g), mulmod(q, mulroot, a3, g2))
    return a
end

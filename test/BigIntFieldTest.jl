module GenericFieldTest

using Test

using TowerFields.BigIntField: addmod, submod, mulmod, sqmod, invmod, powmod, frobmod, FQ2, FQ3

const Q = 7

mulroot(x) = -x

@testset "addmod: FQ" begin
    @test addmod(Q, 0, 1) == 1  # additive identity
    @test addmod(Q, 2, 6) == 1  # basic arithmetic with modulus
    @test addmod(Q, 1, -2) == Q - 1  # signed arithmetic
end

@testset "addmod: FQ2" begin
    @test addmod(Q, (0, 0), (1, 1)) == (1, 1)  # additive identity
    @test addmod(Q, (1, 2), (2, 6)) == (3, 1)  # basic arithmetic with modulus
end

@testset "addmod: FQ3" begin
    @test addmod(Q, (0, 0, 0), (1, 1, 1)) == (1, 1, 1)  # additive identity
    @test addmod(Q, (1, 2, 3), (2, 3, 4)) == (3, 5, 0)  # basic arithmetic and modulus
end

@testset "submod: FQ" begin
    @test submod(Q, 1, 0) == 1  # additive identity
    @test submod(Q, 1, 2) == Q - 1  # basic arithmetic with modulus
    @test submod(Q, 1, -2) == 3  # signed arithmetic
end

@testset "submod: FQ2" begin
    @test submod(Q, (1, 1), (0, 0)) == (1, 1)  # additive identity
    @test submod(Q, (2, 3), (3, 2)) == (Q - 1, 1)  # basic arithmetic with modulus
end

@testset "submod: FQ3" begin
    @test submod(Q, (1, 1, 1), (0, 0, 0)) == (1, 1, 1) # additive identity
    @test submod(Q, (2, 3, 4), (4, 3, 2)) == (Q - 2, 0, 2)  # basic arithmetic and modulus
end

@testset "submod: FQ3" begin
    @test submod(Q, (1, 1, 1), (0, 0, 0)) == (1, 1, 1)  # additive identity
    @test submod(Q, (2, 3, 4), (4, 3, 2)) == (Q - 2, 0, 2)  # basic arithmetic and modulus
end

@testset "submod: FQ3" begin
    @test submod(Q, (1, 1, 1), (0, 0, 0)) == (1, 1, 1) # additive identity
    @test submod(Q, (2, 3, 4), (4, 3, 2)) == (Q - 2, 0, 2)  # basic arithmetic and modulus
end

@testset "mulmod: FQ1" begin
    @test mulmod(Q, mulroot, 2, 0) == 0 # additive identity
    @test mulmod(Q, mulroot, 2, 1) == 2 # multiplicative identity
    @test mulmod(Q, mulroot, 2, 4) == 1  # basic arithmetic and modulus
    @test mulmod(Q, mulroot, 1, -1) == Q - 1  # signed arithmetic
end

@testset "mulmod: FQ2" begin
    x = (2, 3)
    @test mulmod(Q, mulroot, x, (0, 0)) == (0, 0) # additive identity
    @test mulmod(Q, mulroot, x, (1, 0)) == x # multiplicative identity
    @test mulmod(Q, mulroot, x, (3, 4)) == (1, 3)  # basic arithmetic and modulus
    @test mulmod(Q, mulroot, x, (-3, -4)) == (6, 4)  # signed arithmetic
    @test mulmod(Q, mulroot, x, 2) == addmod(Q, x, x)  # scalar arithmetic
    @test mulmod(Q, mulroot, 2, x) == addmod(Q, x, x)  # scalar arithmetic
end

@testset "mulmod: FQ3" begin
    x = (2, 3, 4)
    @test mulmod(Q, mulroot, x, (0, 0, 0)) == (0, 0, 0) # additive identity
    @test mulmod(Q, mulroot, x, (1, 0, 0)) == x # multiplicative identity
    @test mulmod(Q, mulroot, x, (3, 4, 5)) == (3, 4, 6)  # basic arithmetic and modulus
    @test mulmod(Q, mulroot, x, (-3, -4, -5)) == (4, 3, 1)  # signed arithmetic
    @test mulmod(Q, mulroot, x, 2) ==  addmod(Q, x, x)  # scalar arithmetic
    @test mulmod(Q, mulroot, 2, x) ==  addmod(Q, x, x)  # scalar arithmetic
end

@testset "sqmod: FQ1" begin
    x = 4
    @test sqmod(Q, mulroot, 0) == 0 # additive identity
    @test sqmod(Q, mulroot, 1) == 1 # multiplicative identity
    @test sqmod(Q, mulroot, x) == mulmod(Q, mulroot, x, x) # basic arithmetic and modulus
    @test sqmod(Q, mulroot, -x) == mulmod(Q, mulroot, -x, -x) # signed arithmetic
end

@testset "sqmod: FQ2" begin
    x = (2, 3)
    @test sqmod(Q, mulroot, (0, 0)) == (0, 0) # additive identity
    @test sqmod(Q, mulroot, (1, 0)) == (1, 0) # multiplicative identity
    @test sqmod(Q, mulroot, x) == mulmod(Q, mulroot, x, x) # basic arithmetic and modulus
    xneg = mulmod(Q, mulroot, -1, x)
    @test sqmod(Q, mulroot, xneg) == mulmod(Q, mulroot, xneg, xneg) # signed arithmetic
end

@testset "sqmod: FQ3" begin
    x = (5, 2, 3)
    @test sqmod(Q, mulroot, (0, 0, 0)) == (0, 0, 0) # additive identity
    @test sqmod(Q, mulroot, (1, 0, 0)) == (1, 0, 0) # multiplicative identity
    @test sqmod(Q, mulroot, x) == mulmod(Q, mulroot, x, x) # basic arithmetic and modulus
    xneg = mulmod(Q, mulroot, -1, x)
    @test sqmod(Q, mulroot, xneg) == mulmod(Q, mulroot, xneg, xneg) # signed arithmetic
end

@testset "invmod: FQ1" begin
    x = 3
    @test invmod(Q, mulroot, 1) == 1 # multiplicative identity
    y = invmod(Q, mulroot, x)
    @test mulmod(Q, mulroot, x, y) == 1
end

@testset "invmod: FQ2" begin
    x = (2, 3)
    @test invmod(Q, mulroot, (1, 0)) == (1, 0) # multiplicative identity
    y = invmod(Q, mulroot, x)
    @test mulmod(Q, mulroot, x, y) == (1, 0)
end

@testset "invmod: FQ3" begin
    x = (2, 3, 4)
    @test invmod(Q, mulroot, (1, 0, 0)) == (1, 0, 0) # multiplicative identity
    y = invmod(Q, mulroot, x)
    @test mulmod(Q, mulroot, x, y) == (1, 0, 0)
end

@testset "powmod: FQ1" begin
    x, e = 3, 3
    @test powmod(Q, mulroot, 2, 0) == 1  # special exponent 0
    @test powmod(Q, mulroot, 2, 1) == 2  # special exponent 1
    @test powmod(Q, mulroot, x, 2) == sqmod(Q, mulroot, x)  # basic arithmetic and modulus
    @test powmod(Q, mulroot, x, Q - 1) == 1  # fermat's theorem
    y = mulmod(Q, mulroot, x, sqmod(Q, mulroot, x))
    @test powmod(Q, mulroot, x, e) == y  # basic arithmetic and modulus
    @test powmod(Q, mulroot, x, -e) == invmod(Q, mulroot, y)  # negative exponent
end

@testset "powmod: FQ2" begin
    x, e = (2, 3), 3
    @test powmod(Q, mulroot, x, 0) == (1, 0)  # special exponent 0
    @test powmod(Q, mulroot, x, 1) == x  # special exponent 1
    @test powmod(Q, mulroot, x, 2) == sqmod(Q, mulroot, x)  # basic arithmetic and modulus
    y = mulmod(Q, mulroot, x, sqmod(Q, mulroot, x))
    @test powmod(Q, mulroot, x, e) == y  # basic arithmetic and modulus
    @test powmod(Q, mulroot, x, -e) == invmod(Q, mulroot, y)  # negative exponent
end

@testset "powmod: FQ3" begin
    x, e = (2, 3, 4), 3
    @test powmod(Q, mulroot, x, 0) == (1, 0, 0)  # special exponent 0
    @test powmod(Q, mulroot, x, 1) == x  # special exponent 1
    @test powmod(Q, mulroot, x, 2) == sqmod(Q, mulroot, x)  # basic arithmetic and modulus
    y = mulmod(Q, mulroot, x, sqmod(Q, mulroot, x))
    @test powmod(Q, mulroot, x, e) == y  # basic arithmetic and modulus
    @test powmod(Q, mulroot, x, -e) == invmod(Q, mulroot, y)  # negative exponent
end

end
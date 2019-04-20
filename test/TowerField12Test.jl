module TowerField12Test

using Test

using TowerFields.TowerField12: create_frobmap, mulroot
using TowerFields.BigIntField: powmod, frobmod, mulmod

const Q = 13
const frobmap = create_frobmap(Q)

@testset "frobmod: FQ" begin
    @test powmod(Q, mulroot, 7, Q) == frobmod(Q, frobmap, mulroot, 7)
end

@testset "frobmod: FQ2" begin
    @test powmod(Q, mulroot, (7, 11), Q) == frobmod(Q, frobmap, mulroot, (7, 11))
end

@testset "frobmod: FQ3" begin
    e = ((7, 11), (6, 10), (5, 9))
    @test powmod(Q, mulroot, e, Q) == frobmod(Q, frobmap, mulroot, e)
end

@testset "mulroot: FQ" begin
    @test mulroot(123) == -123
end

@testset "mulroot: FQ2" begin
    @test mulroot((3, 4)) == (-1, 7)
end

@testset "mulroot: FQ6" begin
    x = ((7, 11), (6, 10), (5, 9))
    @test mulroot(x) == ((-4, 14), (7, 11), (6, 10))
end

end

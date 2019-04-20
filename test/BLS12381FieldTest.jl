module BLS12381FieldTest

using Test

using TowerFields.BLS12381Field

const A2 = (BLS12381Field.Q - 1), (BLS12381Field.Q - 2)
const B2 = (BLS12381Field.Q - 2), (BLS12381Field.Q - 3)
const C2 = (BLS12381Field.Q - 3), (BLS12381Field.Q - 4)

const A6 = (A2, B2, C2)
const B6 = (B2, C2, A2)
const C6 = (C2, A2, B2)
const D6 = (C2, B2, A2)

const A12 = (A6, C6)
const B12 = (B6, D6)

@testset "add: FQ12" begin
    let + = BLS12381Field.:+
        @test A12 + B12 == (((4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559784, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559782), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559782, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559780), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559783, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559781)), ((4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559781, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559779), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559784, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559782), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559784, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559782)))
    end
end

@testset "sub: FQ12" begin
    let - = BLS12381Field.:-
        @test A12 - B12 == (((1, 1), (1, 1), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559785, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559785)), ((0, 0), (1, 1), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559786, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559786))) == (((1, 1), (1, 1), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559785, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559785)), ((0, 0), (1, 1), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559786, 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559786))) 
    end
end

@testset "mul: FQ12" begin
    let * = BLS12381Field.:*
        @test A12 * B12 == (((4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559692, 46), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559731, 59), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559750, 68)), ((4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559712, 53), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559740, 63), (4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559757, 72)))
    end
end

@testset "pow: FQ12" begin
    let ^ = BLS12381Field.:^,  * = BLS12381Field.:*
        @test A12 ^ 3 == (A12 * A12) * A12
    end
end

end
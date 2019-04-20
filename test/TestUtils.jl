module TestUtils

using TowerFields.BLS12381Field: Q

function randfq()
    # number of UInt128 elements needed
    uint128bitsize = sizeof(UInt128) * 8
    n = Int(cld(log2(Q), uint128bitsize))
    bigrand = zero(BigInt)
    for r in rand(UInt128, n)
        bigrand = (bigrand << uint128bitsize) | r
    end
    return mod(bigrand, Q)
end

randfq2() = (randfq(), randfq())
randfq3() = (randfq(), randfq(), randfq())
randfq6() = (randfq2(), randfq2(), randfq2())
randfq12() = (randfq6(), randfq6())

end

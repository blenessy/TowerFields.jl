module BLS12381FieldProfile

using Profile

using TowerFields.BLS12381Field: powx, Q
using ..TestUtils: randfq12

const PROFILE_TIME = 0.5
const MINCOUNT = parse(Int, get(ENV, "MINCOUNT", "10"))
const FORMAT = Symbol(get(ENV, "FORMAT", "tree"))

# dynamically load the tested functions
function runprofiler(func::Function, args...)
    func(args...) # compile
    local stoptime = time() + PROFILE_TIME
    Profile.clear()
    while time() < stoptime
        @profile func(args...)
    end
    Profile.print(format=FORMAT, sortedby=:count, mincount=MINCOUNT)
end

const A2 = (Q - 1, Q - 2)
const B2 = (Q - 2, Q - 3)
const C2 = (Q - 3, Q - 4)
const A6 = (A2, B2, C2)
const B6 = (C2, A2, B2)
const A = (A6, B6)

# Current bottleneck is in the Final Exponention (as expected).
# Search for "requires 5 exponentiations by z" in: 
# https://eprint.iacr.org/2012/232.pdf
runprofiler(powx, A)

end
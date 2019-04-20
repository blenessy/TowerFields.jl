const DEFAULT_SUITES = "BigIntFieldTest,TowerField12Test,BLS12381FieldTest"

include(joinpath(@__DIR__, "TestUtils.jl"))
for test in split(get(ENV, "TEST", DEFAULT_SUITES), ",")
    include(joinpath(@__DIR__, "$test.jl"))
end

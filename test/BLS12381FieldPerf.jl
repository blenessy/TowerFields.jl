module BLS12381FieldPerf

using BenchmarkTools

BenchmarkTools.DEFAULT_PARAMETERS.samples = 1000
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 10
BenchmarkTools.DEFAULT_PARAMETERS.evals = 1
BenchmarkTools.DEFAULT_PARAMETERS.gctrial = true
BenchmarkTools.DEFAULT_PARAMETERS.gcsample = false
@show BenchmarkTools.DEFAULT_PARAMETERS

using TowerFields.BLS12381Field: add, sub, mul, inv, pow, frob, powx, square
using ..TestUtils: randfq, randfq2, randfq6, randfq12

function format_trial(suite, group, res)
    a = allocs(res)
    gct = BenchmarkTools.prettytime(gctime(res))
    t = BenchmarkTools.prettytime(time(res))
    m = BenchmarkTools.prettymemory(memory(res))
    return "[$suite] $group: $t (alloc: $a, mem: $m, gc: $gct)"
end

# Add some child groups to our benchmark suite.
suite = BenchmarkGroup()

suite["FQ"] = BenchmarkGroup()
suite["FQ"]["add"] = @benchmarkable add($(randfq()), $(randfq()))
suite["FQ"]["sub"] = @benchmarkable sub($(randfq()), $(randfq()))
suite["FQ"]["mul"] = @benchmarkable mul($(randfq()), $(randfq()))
suite["FQ"]["square"] = @benchmarkable square($(randfq()))
suite["FQ"]["inv"] = @benchmarkable inv(($(randfq())))
suite["FQ"]["pow"] = @benchmarkable pow($(randfq()), $(randfq()))
suite["FQ"]["frob"] = @benchmarkable frob($(randfq()))

suite["FQ2"] = BenchmarkGroup()
suite["FQ2"]["add"] = @benchmarkable add($(randfq2()), $(randfq2()))
suite["FQ2"]["sub"] = @benchmarkable sub($(randfq2()), $(randfq2()))
suite["FQ2"]["mul"] = @benchmarkable mul($(randfq2()), $(randfq2()))
suite["FQ2"]["square"] = @benchmarkable square($(randfq2()))
suite["FQ2"]["inv"] = @benchmarkable inv(($(randfq2())))
suite["FQ2"]["pow"] = @benchmarkable pow($(randfq2()), $(randfq()))
suite["FQ2"]["powx"] = @benchmarkable powx($(randfq2()))
suite["FQ2"]["frob"] = @benchmarkable frob($(randfq2()))


suite["FQ6"] = BenchmarkGroup()
suite["FQ6"]["add"] = @benchmarkable add($(randfq6()), $(randfq6()))
suite["FQ6"]["sub"] = @benchmarkable sub($(randfq6()), $(randfq6()))
suite["FQ6"]["mul"] = @benchmarkable mul($(randfq6()), $(randfq6()))
suite["FQ6"]["square"] = @benchmarkable square($(randfq6()))
suite["FQ6"]["inv"] = @benchmarkable inv(($(randfq6())))
suite["FQ6"]["pow"] = @benchmarkable pow($(randfq6()), $(randfq()))
suite["FQ6"]["frob"] = @benchmarkable frob($(randfq6()))

suite["FQ12"] = BenchmarkGroup()
suite["FQ12"]["add"] = @benchmarkable add($(randfq12()), $(randfq12()))
suite["FQ12"]["sub"] = @benchmarkable sub($(randfq12()), $(randfq12()))
suite["FQ12"]["mul"] = @benchmarkable mul($(randfq12()), $(randfq12()))
suite["FQ12"]["square"] = @benchmarkable square($(randfq12()))
suite["FQ12"]["inv"] = @benchmarkable inv(($(randfq12())))
suite["FQ12"]["pow"] = @benchmarkable pow($(randfq12()), $(randfq()))
suite["FQ12"]["powx"] = @benchmarkable powx($(randfq12()))
suite["FQ12"]["frob"] = @benchmarkable frob($(randfq12()))

# If a cache of tuned parameters already exists, use it, otherwise, tune and cache
# the benchmark parameters. Reusing cached parameters is faster and more reliable
# than re-tuning `suite` every time the file is included.
paramspath = joinpath(@__DIR__, "params.json")
if isfile(paramspath)
    loadparams!(suite, BenchmarkTools.load(paramspath)[1], :evals);
else
    println("First run - tuning params (please be patient) ...")
    tune!(suite)
    BenchmarkTools.save(paramspath, params(suite));
end

# print the results
results = run(suite, verbose = true)
for suiteres in results
    for groupres in suiteres.second
        msg = format_trial(suiteres.first, groupres.first, groupres.second)
        println(msg)
    end
end

end
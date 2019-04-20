# TowerFields.jl

Finite Field and Finite Extension Field library for Julia.

This project provides generic building blocks for Finite Extension Fields.

The primary goal with this project was for me to learn Julia and Pairing Based Cryptography.
The performance is decent, although you can always find better e.g. [RELIC](https://github.com/relic-toolkit/relic).

# Disclamer

Use this in production at your own risk. **The code is currently NOT timing/side-channel attack resistant**.

# Usage Guide

Install package with:

```julia
Pkg.add("https://github.com/blenessy/TowerFields.jl")
```

## Field Element Type

A Finite Field (`FQ`) element (of degree 1) is an `Integer` (typically `BigInt`):

```
fq = 123
```

## Extension Field Element of Degree 2 Type

A Finite Extension Field element of degree 2 (`FQ2`) is defined as a `Tuple` containing two `Integer` values: 

```
fq2 = (123, 456)
```

## Extension Field Element of Degree 3 Type

A Finite Extension Field element of degree 3 (`FQ3`) is defined as a `Tuple` containing three `Integer` values: 

```
fq3 = (123, 456, 789)
```

## Extension Field Element of Degree >3

A Finite Extension Field element of degree >3 is composed as nested `Tuples`, where the leaf Tuple is `FQ2` or `FQ3`.
This enables flexible and optimal composition of higher degree Extension Fields. For example, `FQ6` can be defined in two ways
depending on preference:

```
# FQ -> FQ2 -> FQ6
fq6a = ((123, 456), (234, 567), (345, 678))
```

```
# FQ -> FQ3 -> FQ6
fq6b = ((123, 456, 789), (234, 567, 890))
```

## Using the BLS-12 381 Field

The BLS-12 381 is defined over Extension Field of Degree 12 (`FQ12`) as `FQ -> FQ2 -> FQ6 -> FQ12`.
An element in this Field looks like this:

```
fq12 = (
    ((1, 2), (3, 4), (5, 6)),
    ((7, 8), (9, 10), (11, 12))
)
```

This simple example just doubles an element in FQ12:

```julia

using TowerFields.BLS12381Field: add, mul

a = (
    ((1, 2), (3, 4), (5, 6)),
    ((7, 8), (9, 10), (11, 12))
)

@assert add(a, a) == mul(2, a)
```

Check [BLS12381Field in TowerFields.jl](./src/TowerFields.jl) for the complete set of supported functions.

## Syntactic Sugar

Complicated field arithmetic is easier to read and cross-check with whitepapers if proper arithmetic operators are used.
All Field functions are designed so that they can overload standard arithetic operators in both local and global (discouraged) scope.

In the following example the `+` and `*` operators are overloaded in a `let` block:

```
using TowerFields.BLS12381Field

let + = BLS12381Field.add, * = BLS12381Field.mul
    @assert BLS12381Field.Q > 0
    @assert BLS12381Field.Q + 0 == 0      # BLS12381Field.Q % BLS12381Field.Q == 0
    @assert 3 * BLS12381Field.Q + 1 == 1  # (3 * BLS12381Field.Q + 1) % BLS12381Field.Q == 1
end
```

## Creating Custom Fields

The [BLS12381Field in TowerFields.jl](./src/TowerFields.jl) module binds the API to concrete Field arithmetic functions.
You can create a different binding, which uses a different arithmetic lib or constants as long as the interface is maintained.

## What about the Curves?

It will be a different project if I have time. The basic idea is that you can pass a Field module into the curve functions.
For example, this is how the Affline Point doubling function could be implemented, which works in any Extension Field:

```
const AfflinePoint = NamedTuple{(:x, :y), Tuple{T,T}} where T

function affline_double(field::Module, p::AfflinePoint)
    λ = field.div(field.mul(3, field.square(p.x)), field.double(p.y))
    xr = field.sub(field.square(λ), field.double(p.x))
    yr = field.sub(field.mul(λ, field.sub(p.x, xr)), p.y)
    return (x=xr, y=yr)
end
```

# Building

If you aim to build this project - the **Makefile** is your friend. 

**Note**: At this time it I have only tested the Makefile to be working with Mac OS but with a bit of love it should be able to run on Linux too.

## Unit Tests

Run the tests with:

```shell
make test
```

Afterwards, you can check coverage with:

```shell
make coverage
```

## Benchmarks

```shell
make benchmark
```

## Profiling

Currently the `powx` function is being profiled.
Why? This functions the current bottleneck of thethe BLS-12 381 final exponention algo [3].

```shell
make profile
```
s
# Contributions

Contributions are welcome! If you are unsure where to chip in, please see the *Wish List* below.

* **Fixes and minor features**: just create a PR (as customary in GitHub). 
* **Major refactoringd and features**: please start by creating an issue and state your goal.

# Roadmap / Wish List

## Optimisations

* Numeric lib (BigInt/GMP) optimisations
* Algorithmic optimisations

## More Fields

* BN Fields
* KSS Fields

# Links

Much of the implementation is based on the following research and blogs:

[1] [Pairings for beginners](http://www.craigcostello.com.au/pairings/PairingsForBeginners.pdf)<br/>
[2] [Fast Formulas for Computing Cryptographic Pairings](https://eprints.qut.edu.au/61037/1/Craig_Costello_Thesis.pdf)<br/>
[3] [Implementing Pairings at the 192-bit Security Level](https://eprint.iacr.org/2012/232.pdf)<br/>
[4] [The Frobenius endomorphism with finite fields](https://alicebob.cryptoland.net/the-frobenius-endomorphism-with-finite-fields/)

include("../src/JuliaChemScripts.jl")
import JuliaChemScripts
using Test

println(ginp2xyz(2))

@testset "JuliaChemScripts.jl" begin
    # Write your tests here.
    myf(2)
end

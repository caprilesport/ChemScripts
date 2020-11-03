import ChemScripts
using Test

@testset "ChemScripts.jl" begin
    @test ginp2xyz("A") == "A"
    @test ginp2xyz("A") == "A"
end

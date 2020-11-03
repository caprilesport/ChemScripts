import ChemScripts
using Test

@testset "ChemScripts.jl" begin
    @test ChemScripts.ginp2xyz("A") == "A"
    @test ChemScripts.ginp2xyz("A") == "A"
end

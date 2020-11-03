import ChemScripts
using Test

@testset "ChemScripts.jl" begin
    @test ChemScripts.ginp2xyz("A")
    @test ChemScripts.ginp2xyz("A")
end


ChemScripts.ginp2xyz("A")

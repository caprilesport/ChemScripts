using Test
using ChemScripts

#Creating file to use in test
test_str = "3\n"
for i in 1:100
    test_str = test_str * "abc\ndef\nxyz\nabc"
end
test_file = open("test.xyz","w")
write("test.xyz", test_str)

#getxyz test
@testset "getxyz functions" begin
    @test ChemScripts.ginp2xyz("A") == "A"
    @test ChemScripts.gout2xyz("A") == "A"
end


#
@testset "Get xyz test" begin
    #@test ChemScripts.yourfunction("argument") == "result"
    @test ChemScripts.dividexyz("test.xyz",20) == 1
end


rm(test_file)

for i in 1:4
    filename = "test_block_$i.xyz"
    rm(filename)
end

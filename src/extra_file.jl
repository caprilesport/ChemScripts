using ChemScripts
using BenchmarkTools
const CS = ChemScripts

CS.ginp2xyz("A")

CS.dividexyz(2)

file = "C:\\Users\\vinip\\.julia\\dev\\JuliaChemScripts\\test\\react_conformers.xyz"

CS.dividexyz(file,20)


test_str = "3\n"
for i in 1:100
    test_str = test_str * "abc\ndef\nxyz\nabc"
end

test_file = open("test.xyz","w")
write("test.xyz", test_str)

a = CS.dividexyz("test.xyz",20)

close(test_file)
rm("test.xyz")

for i in 1:4
    filename = "test_block_$i.xyz"
    rm(filename)
end

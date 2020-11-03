using JuliaChemScripts
const JCS = JuliaChemScripts

JCS.ginp2xyz("A")

JCS.dividexyz(2)

file = open("C:\\Users\\vinip\\.julia\\dev\\JuliaChemScripts\\test\\react_conformers.xyz", "r")

pwd()

file = readlines(file)

print(file)

JCS.dividexyz(file, 20)

a = length(file)

a/20


file[1]

a % 20

(a-12)/20/20

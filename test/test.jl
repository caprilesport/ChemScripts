using ChemScripts
using BenchmarkTools
const CS = ChemScripts

CS.ginp2xyz("A")

CS.dividexyz(2)

file = "C:\\Users\\vinip\\.julia\\dev\\JuliaChemScripts\\test\\react_conformers.xyz"

CS.dividexyz(file,20)

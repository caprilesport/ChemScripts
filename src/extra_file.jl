using ChemScripts
using BenchmarkTools
const CS = ChemScripts


inpfile = "src/prod.xyz"

gen_g16inp(inpfile,"0 1", "#b3lyp def2SVP opt freq=noraman")

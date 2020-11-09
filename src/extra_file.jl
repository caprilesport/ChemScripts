using ChemScripts
using BenchmarkTools
const CS = ChemScripts

fermi = ["%mem=64GB",
        "%nprocshared=24",
        "%CPU=0-23",
        "%GPUCPU=0-1=0,13"]



inpfile = "C:\\Users\\vinip\\.julia\\dev\\ChemScripts\\test\\test_files\\react_conformers.xyz"

CS.dividexyz(inpfile, 20)

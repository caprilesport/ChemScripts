module ChemScripts

using DelimitedFiles

include("getxyz.jl")
include("dividexyz.jl")
include("geninp.jl")

export ginp2xyz, gout2xyz, dividexyz, gen_g16inp, getcoords

end # module

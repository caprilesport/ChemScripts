module ChemScripts

using DelimitedFiles

include("getxyz.jl")
include("dividexyz.jl")
include("geninp.jl")
include("join_conf_blocks.jl")

export ginp2xyz, gout2xyz, dividexyz, gen_g16inp, getcoords, join_conf_blocks

end # module

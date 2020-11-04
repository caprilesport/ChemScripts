using DelimitedFiles

fermi = ["%mem=64GB",
        "%nprocshared=24",
        "%CPU=0-23",
        "%GPUCPU=0-1=0,13"]

function getcoords(xyz)
        #get input data
        coords = []
        nr_atoms = parse(Int64,xyz[1])
        nr_inputs = (length(xyz) - 2) / nr_atoms

        #Loop to separate xyz blocks
        start = 3
        for i in 1:nr_inputs
                ending = start + nr_atoms - 1
                coord = xyz[start:ending]
                push!(coords, coord)
                start = ending + 3
        end

        return nr_atoms, nr_inputs, coords
end #function

function gen_g16inp(inpfile,multiplicity,keys,cluster="fermi",title="Default title",save="y" )
        if cluster == "fermi"
                cluster = ["%mem=64GB",
                        "%nprocshared=24",
                        "%CPU=0-23",
                        "%GPUCPU=0-1=0,13"]
        elseif cluster == "letoc"
                cluster = ["%mem=48GB",
                        "%nprocshared=40"]
        #=
        Transfroms a xyz file into a G16 input file
        =#
        #reading the xyz file
        file = open(inpfile,"r")
        file_lines = readlines(file)

        #Define if 1 or more inputs and get the coordinates
        nr_atoms, nr_inputs, coords = getcoords(file_lines)
        @show nr_inputs
        #creating the input
        if nr_inputs == 1
                inputs = []
                inputs = cluster

                push!(inputs,keys,"",title,"",multiplicity)
                inputs = vcat(inputs, coords[1])
                push!(inputs, "")

        else
                inputs = []

        end

        #save the file
        if save == "y"
                save_name = inpfile[1:end-3]*"com"
                save_file = open(save_name,"w")
                writedlm(save_file,inputs)
                close(save_file)
        end

        close(file)
        close(save_file)
        return inputs
end #function

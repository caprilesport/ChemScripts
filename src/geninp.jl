using DelimitedFiles

function getcoords(xyz)
        #get input data
        coords = []
        nr_atoms = parse(Int64,xyz[1])
        nr_inputs = Int(length(xyz) / (nr_atoms + 2))

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

function gen_g16inp(inpfile,multiplicity = "0 1",cluster = "fermi",keyss="# m062x def2SVP opt freq=noraman",title = "Default title",save = "y")
        #=
        Transfroms a xyz file into a G16 input file
        =#

        #Defining the cluster
        if cluster == "fermi"
                cluster = ["%mem=64GB",
                        "%nprocshared=24",
                        "%CPU=0-23",
                        "%GPUCPU=0-1=0,13"]
        elseif cluster == "letoc"
                cluster = ["%mem=48GB",
                        "%nprocshared=40"]
        end #if

        #reading the xyz file
        file = open(inpfile,"r")
        file_lines = readlines(file)

        #Define if there are 1 or more inputs and get the coordinates
        nr_atoms, nr_inputs, coords = getcoords(file_lines)

        #creating the input
        # we divide in 1 input or more in order to add the --Link1-- g16 requires
        filetitle = inpfile[1:end-4]
        inputs = []
        for i in 1:nr_inputs
                if i == 1
                        push!(inputs,cluster,[keyss],[""],[filetitle],[""],[multiplicity],coords[i],[""])
                else
                        push!(inputs,["--Link1--"],cluster,[keyss],[""],[title],[""],[multiplicity],coords[i],[""])
                end#if
        end#for

        #save the file
        if save == "y"
                save_name = inpfile[1:end-3]*"com"
                save_file = open(save_name,"w")
                for i in inputs
                        writedlm(save_file,i)
                end #for
                close(save_file)
        end #if

        close(file)
        close(save_file)

end #function

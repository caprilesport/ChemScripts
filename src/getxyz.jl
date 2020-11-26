using DelimitedFiles 

"""    
This function receives an gaussian output .log file and
returns a .xyz file of the final structure

==== examples ====
inputfile = "molecule.log"

julia> ChemScripts.gout2xyz(inputfile)

A molecule.xyz file will be created
=======
"""
function gout2xyz(gout)
    println("Input file = $gout \n")
    # Open the .log file
    outfile = open(gout, "r")
    outfile_line = readlines(outfile)

    # Open the save file 
    savename = gout[1:end-3]*"xyz"
    file = open(savename, "w")
    println(".xyz file create = $savename")

    # These strings mark the information block in the end of a gaussian .log file 
    startinfo = "Unable to Open any file for archive entry."
    endinfo = "The archive entry for this job was punched."
    
    # Obtain the lines of start and end of each block
    startblock = findall(x->occursin(startinfo,x), outfile_line)
    endblock = findall(x->occursin(endinfo,x), outfile_line)

    # Get the blocks of information into an array 
    infos = []
    
    for i in 1:length(startblock)        
        push!(infos, outfile_line[startblock[i]+1:endblock[i]-1])
    end # for 

    # Iterate through each block of information to transform it into the format we want
    geom_block = []

    for i in infos
        block_string = ""

        for j in i 
            #Join the strings and divide
            k = replace(j, " " => "")
            block_string = block_string * k
        end

        #split the joined string into an array
        block_array = split(block_string, "\\")

        # Find beginning and end of block (delimiter 3 starts the xyz block and end in 4)
        delimiters = findall(x->x=="", block_array)
        geom = block_array[delimiters[3]+1:delimiters[4]-1]
        
        #Formatting
        for i in 2:length(geom)
            geom[i] = replace(geom[i], ","=>" ")
        end
        geom[1] = replace(geom[1], "," => " ")
        nr_atoms = length(geom) - 1
        final_geom = [string(nr_atoms)]
        for i in geom
            push!(final_geom, i)
        end

        #save
        writedlm(file, final_geom)

    end # for

    # Close files
    close(outfile)
    close(file)
    
end # function

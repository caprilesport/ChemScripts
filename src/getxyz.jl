using DelimitedFiles 

### Functions that obtain a single or multiple xyz files
function ginp2xyz(ginp)
    """
    This function transforms an input file (already loaded as an object)
    and outputs an xyz type file
    """


    return(ginp)
end


function gout2xyz(gout)
    """
    This function transforms an output file into a xyz type file
    """
    
    # Open the .log file
    outfile = open(gout, "r")
    outfile_line = readlines(outfile)

    # These strings mark the information block in the end of a gaussian .log file 
    startinfo = "Unable to Open any file for archive entry."
    endinfo = "The archive entry for this job was punched."
    
    # Obtain the lines of start and end of each block
    startblock = []
    endblock = []

    for i in 1:length(outfile_line)

        if occursin(startinfo, oufile_line[i])
            push!(startblock, i)
        end # if

        if occursin(endinfo, oufile_line[i])
            push!(endblock, i)
        end # if

    end # for

    # Get the blocks of information into an array 
    infos = []
    
    for i in 1:length(startblock)        
        push!(infos, oufile_line[startblock[i]+1:endblock[i]-1])
    end # for 

    # Iterate through each block of information to transform it into the format we want

    for i in infos





    end # for

    # Close files
    close(outfile)



    return(gout)
end # function


gout2xyz(inpfile)
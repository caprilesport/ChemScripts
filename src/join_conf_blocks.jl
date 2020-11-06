using DelimitedFiles

function join_conf_blocks(save_file)
    #=
    This function joins n files, it is defined for a .log with conformers_block
    in the name, to join the log results of the conformer minimization
    =#

    #reading the files from the current directory
    dir = readdir()

    # array to store archives we are joining
    archives = []

    #checking what files we join
    for i in dir
        if occursin("conformers_block", i)
            if occursin("log", i)
                push!(archives, i)
            end
        end
    end

    println("Fused archives = ", archives)

    # joining
    join_file = open(save_file, "w")

    for i in archives
        @show i
        i_file = open(i, "r")
        i_lines = readlines(i_file)
        writedlm(join_file, i_lines)
        close(i_file)
    end

    #close the file
    close(join_file)

end # function

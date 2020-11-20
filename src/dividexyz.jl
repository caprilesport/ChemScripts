using DelimitedFiles


function dividexyz(inpfile,N=20)
    #=
    Divides n input xyz files toghether in N xyz file with n - (n % N )/N structures
    in each one
    =#
    #Reading the file to an array
    file = open(inpfile, "r")
    inpxyz = readlines(file)

    #Define parameters for to divide the input
    each_xyz = parse(Int64, inpxyz[1]) + 2 # Nr of lines in each xyz block
    last_lines = (length(inpxyz)/each_xyz) % N # Nr of extra xyz blocks that dont fir in a N block
    ef_lines = length(inpxyz) - last_lines #to obtain nr of blocks
    inputs = [] #store each block
    nr_inputs = (ef_lines / each_xyz) / N
    start = 1 # indice to start in loop
    extrainplen = last_lines

    #Looping through the array to obtain each archive with N inputs
    for i in 1:((length(inpxyz)/each_xyz/N))
        ending = (start + each_xyz * N) - 1
        input = inpxyz[start:ending]
        push!(inputs,input)
        start = ending + 1
    end

    # As we just go until the last multiple of N we need to add the extra
    # lines to an input and store it
    last_input = inpxyz[start:end]
    push!(inputs,last_input)

    #Lets save the files
    for i in 1:length(inputs)

        #Drop the last 4 digits
        name = inpfile
        for j in 1:4
            name = chop(name)
        end

        #Set the name
        name = name * "_block_" * string(i) * ".xyz"

        #Save
        save_file = open(name, "w")
        writedlm(save_file, inputs[i])
        close(save_file)

    end

    #closing inpfile
    close(file)
end #function

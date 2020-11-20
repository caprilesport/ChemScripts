using DelimitedFiles 

function getenergy(inpfile)

    """

    This function gets the energy and dipole of all the conformers in a log file,
    and compares the energy of all of them in order to find duplicates

    Then, an .CSV file is created with all the structures, the energies and the 
    dipole moments of the structures

    It would be a good ideia to already (from the .log file) obtain the inputs that are needed 
    for the next calculations, this has to be done yet

    """

    # Open the file, read the lines and define the base name
    base_name = inpfile[1:end-4]
    file = open(inpfile, "r")
    file_lines = readlines(file)

    #Create the gibbs energy and dipole arrays
    dipoles = []
    gibbs_energy = []

    # Loop through the lines to find the energy values and dipole moments
    for i in 1:length(file_lines)

        # Gibbs energy
        if occursin("Sum of electronic and thermal Free Energies", file_lines[i])
            energy_ha = parse(Float64,file_lines[i][end-10:end])
            energy_kcal = energy_ha * 627.5
            push!(gibbs_energy, energy_kcal)
        end #if

        # Dipole moments
        if occursin("Electric dipole moment (input orientation):", file_lines[i])
            dipole = replace(file_lines[i+3][33:44],"D" => "E")
            push!(dipoles, parse(Float64,dipole))
        end #if

    end #for

    #Creating the lines and adding to an array
    arq_final = ["Conformer,Gibbs energy, Dipole moment"]
    for i in 1:length(gibbs_energy)
        add_line = string(i) * "," * string(gibbs_energy[i]) * "," * string(dipoles[i])
        push!(arq_final, add_line)
    end #if

    #Saving into a csv table
    save_name = base_name * ".csv"
    save = open(save_name, "w")
    writedlm(save, arq_final)

    # Check whether we have duplicates 
    dup = []
    for i in 1:length(gibbs_energy)
        
        #check if its a duplicate conformer already
        if i in dup
            continue
        end #if 
        
        #Loop through the i:end conformers and check if its a duplicate
        for j in i+1:length(gibbs_energy)
            if abs(gibbs_energy[i] - gibbs_energy[j]) < 0.02 && abs(dipoles[i] - dipoles[j]) < 0.1
                push!(dup, j)
            end #if
        end# for-j
    end#for-i


    # Obtaining the energies and dipóles of the unique conformers
    uniq_energies = []
    uniq_dipoles = []
    conf_nr = []

    for i in 1:length(gibbs_energy)
        #check if the conformer is a duplicate
        if i in dup
            continue
        end
        
        # if the conformer is not a duplicate, add its nr energy and dipole to the respective arrays
        push!(uniq_energies, gibbs_energy[i])
        push!(uniq_dipoles, dipoles[i])
        push!(conf_nr, i)
    end

    ##Saving the uniques to an similar .csv file 
    
    #Creating the lines and adding to an array (arq_uniq)
    arq_uniq = ["Conformer,Gibbs energy, Dipole moment"]
    for i in 1:length(uniq_energies)
        uniq_line = string(conf_nr[i]) * "," * string(uniq_energies[i]) * "," * string(uniq_dipoles[i])
        push!(arq_uniq, uniq_line)
    end #if

    # Naming and saving
    uniq_name = base_name * "_uniq.csv"
    uniq = open(uniq_name, "w")
    writedlm(uniq, arq_uniq)

    #close the files 
    close(uniq)
    close(file)
    close(save)

    uniq_size = length(conf_nr)
    origin_size = length(gibbs_energy)

    println("A total of $uniq_size conformers from $origin_size structures were found to be unique")
    
    return arq_uniq

end # function

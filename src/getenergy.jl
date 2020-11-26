using DelimitedFiles 
using CSV
include("getxyz.jl")

"""
This function gets the energy and dipole of all the conformers in a log file
and compares the energy of all of them in order to find duplicates

Then, an .CSV file is created with all the nr of the structures, the energies and the 
dipole moments of each one

For all the unique conformers the boltzmann distribution is calculated and a file_boltzmann.csv is 
created with the distribution, energy and so forth and so on

It also generates a .xyz file with all the conformers the script found to be unique

==== examples ====

for the file molecule.log

julia> ChemScripts.getenergy("molecule.log")

A molecule.csv file will be created with all the conformers

A molecule_boltzmann.csv file will be created with the boltzmann distribution

A molecule.xyz file will be create with the structures of all the unique conformers

========
"""
function getenergy(inpfile)
    println("Input file : $inpfile \n")
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
    println("CSV file with all the structures, energies and dipoles : $save_name \n")
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
    println("Generated CSV file with all the unique conformers and the population distribution")

    uniq_size = length(conf_nr)
    origin_size = length(gibbs_energy)

    println("A total of $uniq_size conformers from $origin_size structures were found to be unique")

    ## Obtaining the .xyz file with all the geometries of the unique conformers

    # Keyword to delimit beginning of each calculation 
    startinfo = "Initial command"
    endinfo = "Normal termination"
    log_index = findall(x->occursin(startinfo,x), file_lines)
    log_e = findall(x->occursin(endinfo,x), file_lines)
 

    # Create a list with all the unique conformers .log part , the list of all the unique conformers is conf_nr
    uniqs = []
    for i in conf_nr 
        log_temp = file_lines[log_index[i]:log_index[i+1]]
        push!(uniqs, log_temp)
    end

    #temp file to make the xyz file 
    temp_name = base_name * ".txt"
    temp_file = open(temp_name, "w")
    for i in uniqs
        writedlm(temp_file, i)
    end
    close(temp_file)
    gout2xyz(temp_name)
    rm(temp_name)

    #close the files 
    close(uniq)
    close(file)
    close(save)

end # function



using CSV
using DataFrames

"""    
This function receives an input .csv file with the number of each
conformer and its energy and obtains the Gibbs population for the molecule
The function returns the dataframe and saves it in a inpfile_boltzmann.csv
file

==== examples ====
inputfile = "molecule.csv"

julia> ChemScripts.Boltzmann(inputfile)

A molecule_boltzmann.csv file will be created
=======
"""
function boltzmann(inpfile)
    # Store the name to save
    name = inpfile[1:end-4]
    name_out = name * "_boltzmann.csv"
    println("Input file = $inpfile \n")

    #Read the file
    df = CSV.read(inpfile, DataFrame)

    #Calculating the relative energy and the populations following the boltzmann formulae
    df."Relative energy" = df."Gibbs energy" .- minimum(df."Gibbs energy")
    df."Ni/Nt" =  exp.((-df."Relative energy" ./ (0.0019872041*298.15))) 
    df."Gibbs Population" = df."Ni/Nt" ./ sum(df."Ni/Nt")

    #Save the dataframe to a CSV file
    println("CSV file create with the boltzmann distribution: $name_out")
    CSV.write(name_out,df)

end # function


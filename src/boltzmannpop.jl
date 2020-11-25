using CSV
using DataFrames

function boltzmann(inpfile)
    """    
    This function receives an input .csv file with the number of each
    conformer and its energy and obtains the Gibbs population for the molecule
    The function returns the dataframe and saves it in a inpfile_boltzmann.csv
    file

    ==== examples ====
    inputfile = "molecule.csv"
    
    julia> a = ChemScripts.Boltzmann(inputfile)
    
    The dataframe will be returned to the variable "a",
    
    A molecule_boltzmann.csv file will be created

    """
    
    # Store the name to save
    name = inpfile[1:end-4]
    name_out = name * "_boltzmann.csv"

    #Read the file
    df = CSV.read(inpfile, DataFrame)

    #Calculating the relative energy and the populations following the boltzmann formulae
    df."Relative energy" = df."Gibbs energy" .- minimum(df."Gibbs energy")
    df."Ni/Nt" =  exp.((-df."Relative energy" ./ (0.0019872041*298.15))) 
    df."Gibbs Population" = df."Ni/Nt" ./ sum(df."Ni/Nt")

    #Save the dataframe to a CSV file
    CSV.write(name_out,df)

end # function


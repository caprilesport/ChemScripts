teste = open("./test/test_files/infoblock.txt")


test_line = readlines(teste)

fulstr = ""

for i in test_line
    fulstr = fulstr * i
end


fulstr = replace(fulstr,"\"" => "")
fulstr = replace(fulstr,"\\" => "__")


b = split(fulstr, "__")

for i in b 
    @show i 
end


println("-----")
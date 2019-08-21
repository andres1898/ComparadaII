
##########################
#### For trees and matrix 
#### with brlength = 1

for (h in 1:3) {
  
  trees <- list.files(pattern = paste("tree_", "rep", h, "_", sep = "")) #make a list with tree file's names
  
  matrices <- list.files(pattern = paste("matriz__", "rep", h, "_", sep = "")) #make a list with matrix file's names

  rbScript <- readLines("../../functions/bayesAnc.Rev") #read the RevBAyes script made it 

for (i in 1:length(trees)){
  
  for (j in 1:length(matrices)){
    

        script <- gsub(pattern = "input_tree", replacement = paste("\"", trees[i],"\"", sep = ""), x = rbScript) # set the tree for the replic
        script <- gsub(pattern = "input_matrix", replacement = paste("\"", matrices[j],"\"", sep = ""), x = script) # set 
        script <- gsub(pattern = "output_AS", replacement = paste("\"../resultBAYES/AS_", trees[i], matrices[j], "\"",  sep = ""), x = script)
        script <- gsub(pattern = "output_Tree", replacement = paste("\"../resultBAYES/TREE_", trees[i], matrices[j], "\"" , sep = ""), x = script)
    
        writeLines(text = script, "scriptRB")
    
        system(paste("rb", "scriptRB"))
    
    }
  }
}



##########################
#### For trees and matrix 
#### with brlength = expo(10)

for (h in 1:3) {
  
trees <- list.files(pattern = paste("tree_expo_rep", h , "_", sep="")) #make a list with tree file's names
matrices <- list.files(pattern = paste("matriz_expo_rep", h, "_", sep = "")) #make a list with matrix file's names
rbScript <- readLines("../../functions/bayesAnc.Rev") #read the RevBAyes script made it 

for (i in 1:length(trees)){
  
  for (j in 1:length(matrices)){
    
    script <- gsub(pattern = "input_tree", replacement = paste("\"", trees[i],"\"", sep = ""), x = rbScript) # set the tree for the replic
    script <- gsub(pattern = "input_matrix", replacement = paste("\"", matrices[j],"\"", sep = ""), x = script) # set 
    script <- gsub(pattern = "output_AS", replacement = paste("\"../resultBAYES/AS_", trees[i], matrices[j], "\"",  sep = ""), x = script)
    script <- gsub(pattern = "output_Tree", replacement = paste("\"../resultBAYES/TREE_", trees[i], matrices[j], "\"" , sep = ""), x = script)
    
    writeLines(text = script, "scriptRB")
    
    system(paste("rb", "scriptRB"))
    
    }
  }
}


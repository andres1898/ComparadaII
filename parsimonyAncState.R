#setwd("~/Desktop/MEGA/9sem/comparadaII/Proyecto/metodología/results/ntaxa160/")

require(phangorn) #mandatory library
require(phytools) #mandatory library
require(TreeSearch) #mandatory library

dir.create("../resultsPARSI")

##########################
#### For trees and matrix 
#### with brlength = 1

for (h in 1:3) {
  
  trees <- list.files(pattern = paste("tree_", "rep", h, "_", sep = "")) #make a list with tree file's names
  
  matrices <- list.files(pattern = paste("matriz__", "rep", h, "_", sep = "")) #make a list with matrix file's names

  topologies <- lapply(trees, read.nexus) #read the topologies
  matricesPhy <- lapply(matrices, ReadAsPhyDat) #read matrices as phy 

  for (i in 1:length(trees)){

    for( j in 1:length(matrices)){
    
      tmp2 <- ancestral.pars(topologies[i][[1]], matricesPhy[j][[1]]) #ancestral states estimation
      tmp3 <- tmp2[2:length(topologies[i][[1]]$tip.label)+Nnode(topologies[i][[1]])] #extract the states of internal nodes
      parsi.state <- matrix(unlist(tmp3[1:length(tmp3)]), ncol = length(levels(tmp2[1])), byrow = T) #extract the propabilities of each state and make a matrix
      write.csv(x=parsi.state, file = paste("../resultsPARSI/", "AS_", trees[i], matrices[j], sep = ""), row.names=FALSE)

    }
  }
}

##########################
#### For trees and matrix 
#### with brlength = expo(10)

for (h in 1:3) {
  
  trees <- list.files(pattern = paste("tree_expo_rep", h , "_", sep="")) #make a list with tree file's names
  matrices <- list.files(pattern = paste("matriz_expo_rep", h, "_", sep = "")) #make a list with matrix file's names

  topologies <- lapply(trees, read.nexus)
  matricesPhy <- lapply(matrices, ReadAsPhyDat)

  for (i in 1:length(trees)){
  
    for( j in 1:length(matrices)){
    
      tmp2 <- ancestral.pars(topologies[i][[1]], matricesPhy[j][[1]]) #acestral states estimation
      tmp3 <- tmp2[2:length(topologies[i][[1]]$tip.label)+Nnode(topologies[i][[1]])] #extract the states of internal nodes
      parsi.state <- matrix(unlist(tmp3[1:length(tmp3)]), ncol = length(levels(tmp2[1])), byrow = T) #extract the propabilities of each state and make a matrix
      write.csv(x=parsi.state, file = paste("../resultsPARSI/", "AS_", trees[i], matrices[j], sep = ""), row.names=FALSE)
    
   }
  }
}

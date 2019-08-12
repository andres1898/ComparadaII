#setwd("~/Desktop/MEGA/9sem/comparadaII/Proyecto/metodología/results/resultBAYES/ntaxa160/")
require(phangorn) #mandatory library
require(phytools) #mandatory library
require(RevGadgets) #mandatory library

#dir.create("../BAYEState/")

data_AS <- list.files(pattern = "AS_tree_") #create list with file's names

print(data_AS) #check point in console

tree_matrices <- lapply(data_AS, plot_ancestral_states) #read each file as phylo object

for (i in 1:length(data_AS)){

  print("reading the trees") #check point in console

  print("the trees were reading") #check point in console
   
  print(i) #check point in console

  #str(tree_matrices[1]) #the object is a large list ready to plot

  solo <- tree_matrices[i][[1]] #extract the first matrix, that is just the probability to state 1

  print(solo) #check point in console

  tmp.nodes <- which(solo$data$label!="NA") #the object don't have labels number, so I created a machete to select the internal nodes

  matrixStates <- as.matrix(solo$data$anc_state_1_pp[length(tmp.nodes)+tmp.nodes-1]) #extract and convert into a matrix, the nodes states. the result is the probabilitie to be the first state

  probStates <- matrixStates[-1] #eliminate the external node

  probStates <- round(as.numeric(probStates)) #round the probabilities, all in 1 or 0

  write.csv(x=probStates, file = paste("../BAYEState/", "StatesNodes_", data_AS[i], sep = ""), row.names=FALSE)

}





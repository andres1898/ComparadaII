#setwd("~/Desktop/MEGA/9sem/comparadaII/Proyecto/metodología/")

###################################################
###script to test the difference between categories
###################################################
tabla.data <- read.csv("Comparation_Result.csv")

levels(tabla.data$br.lenght) <- c("Exponential", "Equal")

#for categories
krus.term <- kruskal.test(tabla.data$percent~tabla.data$terminals)
krus.model <- kruskal.test(tabla.data$percent~tabla.data$model)
krus.brLength <- kruskal.test(tabla.data$percent~tabla.data$br.lenght)

#extract the p-values
p.term <- krus.term$p.value
p.BrLength <- krus.brLength$p.value
p.model <- krus.model$p.value

pairwise.wilcox.test(x = tabla.data$percent, g = tabla.data$terminals, p.adjust.method = "holm" )

pairwise.wilcox.test(x = tabla.data$percent, g = tabla.data$br.lenght, p.adjust.method = "holm" )

#write csv
Categories <- c("Number of terminals", "Generation of character states model", "Branch length")

p.Value <- c(p.term, p.BrLength, p.model)

tabla.kruskal <- cbind(Categories, p.Value)

write.csv(tabla.kruskal, file = "./tabla_kruskal.csv")
#setwd("~/Desktop/MEGA/9sem/comparadaII/Proyecto/metodología/GitHub/results/tablesComparition/")

require(ggplot2) #mandatory library

bayes.files <- list.files("BAYEState/") #make a list with file's names from Bayes recons
bayes.files <- paste("BAYEState/", bayes.files, sep = "") #add the directory in name
  
pars.files <- list.files("resultsPARSI/") #make a list with file's names from Parsi recons
pars.files <- paste("resultsPARSI/", pars.files, sep = "") #add the directory in name

bayes.tables <- lapply(bayes.files, read.csv) #read tables from Bayes reconstruction
parsi.tables <- lapply(pars.files, read.csv) #read tables from Parsimony reconstruction

empty <- vector("numeric", length = 1) #empty temporal table with congruent reconstruction
percent <- vector("numeric", length = 1) #empty table for percent of ancestral states' congruetion 
#################################################################################

for (j in 1:length(bayes.files)){
  
  tmp.bayes <- bayes.tables[j][[1]] #temporal object for hold the replic matrix
  tmp.parsi <- parsi.tables[j][[1]] #temporal object for hold the replic matrix

  empty <- vector("numeric", length = 1)

  for (i in 1:nrow(tmp.bayes)) {
  
    if (tmp.bayes[i,1]==tmp.parsi[i,1]){ #evaluate each node state probabilitie
      empty[i] <- 1 #fill 1 if there are the same probabilitie
    } else {empty[i] <- 0} #fill 0 if there are not the same state
  
  }
  
  percent[j] <- sum(empty)/length(empty) #calculate the percent of nodes with ancestral state congruented

}
##################################################
##################################################
# create a table

bayes.names <- list.files("BAYEState/") #make a list with file's names from Bayes recons

terminals <- vector(mode = "character", length = length(bayes.names)) # an empty vector to fill with the number of terminals by replic

model <- vector(mode = "character", length = length(bayes.names)) # an empty vector to fill with the generation model for character by replic

br.lenght <- vector(mode = "character", length = length(bayes.names)) # an empty vector to fill with the generation model of the length of branches by replic

tabla.Similarity <- cbind(bayes.names, percent, terminals, model, br.lenght) #concatenate by columns

#define position with differents size of terminals
ntax10 <- grep("ntaxa10", tabla.Similarity[,1])
ntax40 <- grep("ntaxa40", tabla.Similarity[,1])
ntax160 <- grep("ntaxa160", tabla.Similarity[,1])

#define position with differents model of characters' generation
mk2 <- grep("mk2", tabla.Similarity[,1])
homo <- grep("homoplasy", tabla.Similarity[,1])

#define position with differents model of characters' generation
br.1 <- grep("__rep", tabla.Similarity[,1])
br.expo <- grep("expo_rep", tabla.Similarity[,1])

##assign the category to each topology gived by number of taxa, character generation and br.length
colnames(tabla.Similarity) #column names

#for number of terminals
tabla.Similarity[ntax10, 3] <- "10term"
tabla.Similarity[ntax40, 3] <- "40term"
tabla.Similarity[ntax160, 3] <- "160term"

#for Character generation
tabla.Similarity[mk2, 4] <- "Mk2"
tabla.Similarity[homo, 4] <- "Uniform"

#for Branch length
tabla.Similarity[br.1, 5] <- "Equal"
tabla.Similarity[br.expo, 5] <- "Exponential"

head(tabla.Similarity)
#write a table for confirm my results

write.csv(row.names = F, x = tabla.Similarity, file = "Comparation_Result.csv")

##################################################
##################################################
##################################################

tabla.Similarity <- read.csv("./Comparation_Result.csv")
#levels(tabla.Similarity$br.lenght) <- c("Exponential", "Equal")

# Now time to plot by replics

dir.create("../figures") #create a directory for save images

#replics <- c(1:length(percent)) #enumarete the replics
data_plot <- as.data.frame(tabla.Similarity[,-1]) #bind and convert into dataframe the percent and the replic number
head(data_plot)

data_plot$terminals <- ordered(data_plot$terminals, levels = c("10term", "40term", "160term")) #sort the number of terminals, just for make more kind the plots

#plot a histogram
hist_percent <- ggplot(data_plot, aes(x=as.numeric(data_plot$percent))) + geom_histogram(bg="grey50") +
  labs(x="Percent of similarity", y = "Number of cases") + #title="Percent of similarity beetween MP vs. Bayes reconstruction"
  theme_classic()

#save the histagram
png(file = "../figures/histogram.png")
plot(hist_percent)
dev.off()

#################

#boxplot for just number of terminals variable
box.ntaxa <- ggplot(data_plot, aes(x=data_plot$terminals, y=as.numeric(data_plot$percent))) + 
  geom_boxplot(outlier.colour="red", bg=c("#deebf7ff", "#9ecae1ff", "#3182bdff")) + 
  stat_summary(fun.y=mean, colour="red", geom="point") + 
  ylab("Similarity (percentage)") + 
  xlab("Number of terminals") + 
  theme_bw()
  #+geom_jitter(position=position_jitter(width=.1, height=0))
#save point plot
png(file = "../figures/box_ntaxa.png")
plot(box.ntaxa)
dev.off()

#################
#boxplot for number of terminals and for model of character generation
box.char <- qplot(x = data_plot$terminals, y = as.numeric(data_plot$percent), data = data_plot, fill=data_plot$terminals)+ 
  geom_boxplot(outlier.colour="gray95") +
    #bg=c("gray95", "cornsilk", "azure", "gray95", "cornsilk", "azure"), outlier.colour="yellow") + 
  facet_grid(data_plot$model) + 
  scale_fill_brewer() + 
  stat_summary(fun.y=mean, colour="red", geom="point") + 
  #ggtitle(label = "Percent of similarity beetween MP vs. Bayes reconstruction", subtitle = "Test character generation model") + 
  labs(x="Number of terminals", y = "Similarity (%)") + 
  theme_bw() + 
  theme(legend.position = "none")
  # + geom_jitter(position=position_jitter(width=.1, height=0))

#save figure
png(file = "../figures/box_charactModel.png")
plot(box.char)
dev.off()

#################
#boxplot for number of terminals and for model of branch length
box.brLenght <- qplot(x = data_plot$terminals, y = as.numeric(data_plot$percent), data = data_plot, fill=data_plot$terminals)+ 
  geom_boxplot()+
    #bg=c("gray95", "cornsilk", "azure", "gray95", "cornsilk", "azure"), outlier.colour="yellow") + 
  facet_grid(data_plot$br.lenght) + 
  scale_fill_brewer() + 
  stat_summary(fun.y=mean, colour="red", geom="point") + 
  #ggtitle(label = "Percent of similarity beetween MP vs. Bayes reconstruction", subtitle = "Test branch length model") + 
  labs(x="Number of terminals", y = "Similarity (%)") + 
  theme_bw() + 
  theme(legend.position = "none" )
  #geom_jitter(position=position_jitter(width=.1, height=0))

#save figure
png(file = "../figures/box_brLenght.png")
plot(box.brLenght)
dev.off()

#########################################
### Violin plots

violin.brLenght <- qplot(x = data_plot$terminals, y = as.numeric(data_plot$percent), data = data_plot, fill=data_plot$terminals) + 
geom_violin(trim = T) +
  facet_grid(data_plot$br.lenght) + 
  scale_fill_brewer() +
  stat_summary(fun.y=mean, colour="red", geom="point") +
  #stat_summary(fun.y=median, colour="yellow", geom="point") + 
  #ggtitle(label = "Percent of similarity beetween MP vs. Bayes reconstruction", subtitle = "Test branch length model") + 
  labs(x="Number of terminals", y = "Similarity (%)") + 
  theme_bw() + 
  theme(legend.position = "none" )

png(file = "../figures/violin_brLenght.png")
plot(violin.brLenght)
dev.off()
###########

violin.char <- qplot(x = data_plot$terminals, y = as.numeric(data_plot$percent), data = data_plot, fill=data_plot$terminals) +
  geom_violin() +
  scale_fill_brewer() + 
  facet_grid(data_plot$model) + 
  stat_summary(fun.y=mean, colour="red", geom="point") +
  #stat_summary(fun.y=median, colour="pink", geom="point") + 
  #ggtitle(label = "Percent of similarity beetween MP vs. Bayes reconstruction", subtitle = "Test branch length model") + 
  labs(x="Number of terminals", y = "Similarity (%)") + 
  theme_bw() + 
  theme(legend.position = "none" )

png(file = "../figures/violin_charactModel.png")
plot(violin.char)
dev.off()

###########

violin.term <- qplot(x = data_plot$terminals, y = as.numeric(data_plot$percent), data = data_plot, fill=data_plot$terminals) + 
  geom_violin() +
  scale_fill_brewer() + 
  stat_summary(fun.y=mean, colour="red", geom="point") +
  #stat_summary(fun.y=median, colour="yellow", geom="point") + 
  #ggtitle(label = "Percent of similarity beetween MP vs. Bayes reconstruction", subtitle = "Test branch length model") + 
  labs(x="Number of terminals", y = "Similarity (%)") + 
  theme_bw() + 
  theme(legend.position = "none" )

png(file = "../figures/violin_terminals.png")
plot(violin.term)
dev.off()


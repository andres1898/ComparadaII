####### Preliminar metodology
####### Andres Ordoñez-Casadiego
####### Comparada II 2019-2

#### create a directory for results
mkdir ./results

#### execute R script the funcition to generate topologies and matrices, by default just one replic
Rscript ./functions/GenerateData.R

#### sort the results by number of taxa
mkdir ./results/ntaxa10

mkdir ./results/ntaxa40

mkdir ./results/ntaxa160

for i in ./results/*_ntaxa10*
do
mv $i ./results/ntaxa10/
done

for i in ./results/*_ntaxa40*
do
mv $i ./results/ntaxa40/
done

for i in ./results/*_ntaxa160*
do
mv $i ./results/ntaxa160/
done
####


#### Get into the different directories and run Bayes
cd ./results/ntaxa10
Rscript ../../functions/forRevBayes.R 

cd ../ntaxa40
Rscript ../../functions/forRevBayes.R 

cd ../ntaxa160
Rscript ../../functions/forRevBayes.R 
####

### sort the Bayes' results
#### sort the result by number of taxa
cd ../resultBAYES

mkdir ./ntaxa10

mkdir ./ntaxa40

mkdir ./ntaxa160

for i in ./*_ntaxa10*
do
mv $i ./ntaxa10/
done

for i in ./*_ntaxa40*
do
mv $i ./ntaxa40/
done

for i in ./*_ntaxa160*
do
mv $i ./ntaxa160/
done
####

#### Write table of ancestral States in Bayes reconstruction

mkdir ./BAYEState

cd ./ntaxa10
Rscript ../../../functions/extrac_BayeStates.R

cd ../ntaxa40
Rscript ../../../functions/extrac_BayeStates.R

cd ../ntaxa160
Rscript ../../../functions/extrac_BayeStates.R


#####Ancestral States by Parsimony and write the table
cd ../../ntaxa10
Rscript ../../functions/parsimonyAncState.R

cd ../ntaxa40
Rscript ../../functions/parsimonyAncState.R

cd ../ntaxa160
Rscript ../../functions/parsimonyAncState.R


#####Comparation of reconstruction methos

cd ..
mkdir tablesComparition

mv ./resultBAYES/BAYEState ./tablesComparition

mv ./resultsPARSI ./tablesComparition

cd ./tablesComparition

Rscript ../../functions/Comparation_Plot.R

###### open pdf

###### make a table with the result of Kruskall-Wallis

Rscript ../../functions/kruskallWallis.R

exit



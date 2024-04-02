# Counting reads for the liver and spleen RNASeq data mapped to de novo assembled 
# trinity transcriptome from E. labiatus and bat Hepatocystis using features count 
# after mapping with STAR


# first installing and loading the package Rsubread which has featuresCount as a built in package
# BiocManager::install("Rsubread")
library("Rsubread")


# Setting the path to the directory containing the BAM files from STAR mapping
bamdirectory <- "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_bat/E.labiatus_and_Hepatocystis_trinity_denovo_transcriptome_STARmapped/"
bamdirectory

# Creating a list of BAM file names in the directory
bamFiles <- dir(bamdirectory, pattern = "*.bam$", 
                       full.names = TRUE, recursive = TRUE)
bamFiles

# Performing feature counts to generate feature counts for each BAM file, specifying self-made Hepatocystis gtf

# Creating an empty data frame to store the feature counts
RNASeqfeatureCounts <- data.frame()

# List of files
bamFiles

# Loop over the files
for (file in bamFiles) {
  # Extract file name without path
  file_name <- tools::file_path_sans_ext(basename(file))
        
  #the basename function is used to extract the file name without the entire path. 
  #This file name is then used as the column name when adding the counts to the feature_counts data frame.
  

  # Running featureCounts for each file
  # Running featureCounts for each file
  RNASeqcounts <- featureCounts(files = file, 
                                annot.ext = "/home/brenda/RNASeq_liver_and_spleen/intermediateData/Hepatocystis_genomic.gtf",
                                isGTFAnnotationFile = TRUE, 
                                GTF.featureType = "transcript", 
                                GTF.attrType = "transcript_id",  
                                isPairedEnd = TRUE, 
                                minOverlap = 1,
                                nthreads = 20)
  
  
  # Printing out the intermediate results for inspection
  #print(RNASeqcounts)
 
   
# Extracting the gene IDs and counts from the result
  RNASeqgene_ids <- RNASeqcounts$annotation$GeneID
  RNASeqfile_counts <- RNASeqcounts$counts

#Creating a new data frame with the gene IDs and counts
  RNASeqfile_data <- data.frame(GeneID = RNASeqgene_ids, RNASeqfile_counts)
  

#Merging the new data frame with the feature_counts data frame
if (nrow(RNASeqfeatureCounts) == 0) {
  RNASeqfeatureCounts <- RNASeqfile_data
} else {
  RNASeqfeatureCounts <- merge(RNASeqfeatureCounts, RNASeqfile_data, by = "GeneID", all = TRUE)
}
}

# Printing out the final feature counts data frame
#print(RNASeqfeatureCounts)


#Setting the gene IDs column as the row names of the feature counts table
rownames(RNASeqfeatureCounts) <- RNASeqfeatureCounts[,"GeneID"]

#Removing the gene ID column from the feature counts table
RNASeqfeatureCounts$GeneID <- NULL


#renaming the column names (sample IDs) to shorten them

#removing all unwanted characters from the end
colnames(RNASeqfeatureCounts) = gsub(pattern = "_S.*", 
                                     replacement = "", 
                                     x = colnames(RNASeqfeatureCounts))

#removing all unwanted characters from the start
colnames(RNASeqfeatureCounts) = gsub(pattern = "^.*D", 
                                     replacement = "D", 
                                     x = colnames(RNASeqfeatureCounts))

#removing transcripts with 0 counts
RNASeqfeatureCounts <- RNASeqfeatureCounts[rowSums(RNASeqfeatureCounts)>0,]


# Saving the feature counts to a file 
saveRDS(RNASeqfeatureCounts, "/home/brenda/RNASeq_liver_and_spleen/intermediateData/RNASeqCountTable_trinity_de_novo_transcriptome.RDS")



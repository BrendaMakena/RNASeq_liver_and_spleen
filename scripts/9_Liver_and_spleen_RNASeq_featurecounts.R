# counting reads for the liver and spleen RNASeq data using features count after mapping with STAR

# https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/lessons/05_counting_reads.html 

# first install and load the package Rsubread which has featuresCount as a built in package
# BiocManager::install("Rsubread")
library("Rsubread")
library(tidyr)
library(dplyr)
library(stringr)
library(tibble)

# Setting the path to the directory containing the BAM files from STAR mapping
bamdirectory <- "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_samtools_sorted/BAMfiles"
bamdirectory

# Creating a list of BAM file names in the directory
bamFiles <- list.files(bamdirectory, pattern = ".bam$", full.names = TRUE)
bamFiles

# Perform feature counts to generate feature counts for each BAM file, specifying Hepatocystis GFF

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
  #RNASeqcounts <- featureCounts(files = file, nthreads = 20, 
  #                              annot.ext = "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/genomes/Hepatocystis_from_HPiliocolobus/GCA_902459845.2_HEP1_genomic.gtf", 
  #                              isGTFAnnotationFile = TRUE, GTF.featureType = "exon", GTF.attrType = "gene_id",
  #                              isPairedEnd = TRUE)
  
  RNASeqcounts <- featureCounts(files = file, nthreads = 20, 
                               annot.ext = "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/genomes/Hepatocystis_from_HPiliocolobus/GCA_902459845.2_HEP1_genomic.gtf", 
                isGTFAnnotationFile = TRUE, GTF.featureType = "gene", GTF.attrType = "gene_id",
                isPairedEnd = TRUE, minOverlap = 1)

# Extracting the gene IDs and counts from the result
RNASeqgene_ids <- RNASeqcounts$annotation$GeneID
RNASeqfile_counts <- RNASeqcounts$counts

#Creating a new data frame with gene IDs and counts
RNASeqfile_data <- data.frame(GeneID = RNASeqgene_ids, RNASeqfile_counts)

#Merging the new data frame with the feature_counts data frame
if (nrow(RNASeqfeatureCounts) == 0) {
  RNASeqfeatureCounts <- RNASeqfile_data
} else {
  RNASeqfeatureCounts <- merge(RNASeqfeatureCounts, RNASeqfile_data, by = "GeneID", all = TRUE)
}
}


#Setting the gene IDs column as the row names of the feature counts table
rownames(RNASeqfeatureCounts) <- RNASeqfeatureCounts[,"GeneID"]

#Removing the gene ID column from the feature counts table
RNASeqfeatureCounts$GeneID <- NULL


#renaming the column names (sample IDs) to shorten them

#removing all unwanted characters from the end
names(RNASeqfeatureCounts) = gsub(pattern = "_S.*", 
                                     replacement = "", 
                                     x = names(RNASeqfeatureCounts))

#removing all unwanted characters from the start
names(RNASeqfeatureCounts) = gsub(pattern = "^.*D", 
                                     replacement = "D", 
                                     x = names(RNASeqfeatureCounts))

#removing transcripts with 0 counts
RNASeqfeatureCounts <- RNASeqfeatureCounts[rowSums(RNASeqfeatureCounts)>0,]


# Saving the feature counts to a file 
saveRDS(RNASeqfeatureCounts, "/home/brenda/RNASeq_liver_and_spleen/intermediateData/RNASeqCountTable_less_stringent.RDS")



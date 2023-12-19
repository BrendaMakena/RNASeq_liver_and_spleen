### getting the summary (rowSums) for Hepatocystis transcripts across all samples in 
### the 3'Tag RNASeq features counts and the RNASeq features counts files

## Loading the 9 RNASeq samples features counts file 

# rerun script 1 for generating counts table or read from intermediate data
readcount <- FALSE

# loading the dataframe (file containing the read counts) from the features count step from the 9 RNASeq samples
if(readcount){
  source("/home/brenda/RNASeq_liver_and_spleen/scripts/9_Liver_and_spleen_RNASeq_featurecounts.R")
}else{
  RNASeqfeatureCounts <- readRDS("/home/brenda/RNASeq_liver_and_spleen/intermediateData/RNASeqCountTable_less_stringent.RDS")
}


## loading the 3'Tag RNASeq features counts file from the 166 samples file

# rerun script 1 for generating counts table or read from intermediate data
readcount <- FALSE

# loading the dataframe (file containing the read counts) from the features count step from the 166 3'Tag RNASeq samples
if(readcount){
  source("/home/brenda/BatHepatoTransc/scripts/3_featurecounts.R")
}else{
  tagRNASeqCounts <- readRDS("/home/brenda/BatHepatoTransc/intermediateData/countTable.RDS")
}


# Our RNASeq features counts file for our 9 samples only contains Hepatocytis transcripts as 
# the mapped reads were mapped to only Hepatocystis annotation file

# filtering out only Hepatocystis transcripts rows from the 3'Tag RNASeq features counts file
tagRNASeqCounts_Hep <- tagRNASeqCounts[grepl("HEP_",rownames(tagRNASeqCounts)),]


# Calculating row sums for tagseq and RNAseq feature counts separately
tagseq_rowsums <- rowSums(tagRNASeqCounts_Hep)  
rnaseq_rowsums <- rowSums(RNASeqfeatureCounts)  


# Creating separate dataframes with Transcript_ID as rownames and respective row sums
tagseq_summary <- data.frame(Transcript_ID = rownames(tagRNASeqCounts_Hep), Tagseq_Rowsums = tagseq_rowsums)
rnaseq_summary <- data.frame(Transcript_ID = rownames(RNASeqfeatureCounts), RNAseq_Rowsums = rnaseq_rowsums)

# Merging the summaries based on Transcript_ID
merged_Hep_summary <- merge(tagseq_summary, rnaseq_summary, by = "Transcript_ID", all = TRUE)

# replacing the NA values with zeros for plotting
merged_Hep_summary[is.na(merged_Hep_summary)] <- 0

# Displaying the first few rows of the merged summary
head(merged_Hep_summary)

print(merged_Hep_summary)


saveRDS(merged_Hep_summary,file = "/home/brenda/RNASeq_liver_and_spleen/intermediateData/mergedHepatocystisCounts.RDS")



# visualising how the Tagseq versus RNAseq Hepatocystis transcripts compare
ggplot(merged_Hep_summary, aes(x=Tagseq_Rowsums, y=RNAseq_Rowsums)) +
  geom_point() 

 
# loading the Hepatocystis proteins table 
hepatocystis_proteins <- read.csv("/home/brenda/BatHepatoTransc/inputdata/hepatocystis_proteins.csv")
hepatocystis_proteins  


# what the highest expressed Hepatocystis transcript in the tagseq dataset but not in the RNASeq dataset is
hepatocystis_proteins[hepatocystis_proteins$Locus.tag %in% "HEP_00048100", ]
        # it is not in the annotated proteins file

# checking another transcript in the RNASeq dataset but not expressed in Tagseq dataset
hepatocystis_proteins[hepatocystis_proteins$Locus.tag %in% "HEP_00480400", ]


hepatocystis_proteins[hepatocystis_proteins$Locus.tag %in% "HEP_00203900", ]


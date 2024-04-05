## separating Host from parasites transcripts to determine the counts for each after the features counts step

# used infoseq on the de novo assembled trinity transcriptome of the E. labiatus infected with Hepatocystis 
# to get the %GC content of the transcripts

# next will use dplyr filter to filter out Hepatocystis transcripts with <=24.0 being the cutout


# Installing and loading packages#
install.packages("tidyverse")
library(tidyverse)
library(dplyr)


# loading the infoseq file
trinity_infoseq <- read.csv("/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/trinity/trinity_infoseq.txt",
                            header = TRUE, sep = "", dec = ".")


head(trinity_infoseq)
str(trinity_infoseq)


# Filtering reads with %GC less than 24
Hepatocystis_trinity <- trinity_infoseq %>%
          filter(X.GC <= 24.0)
Hepatocystis_trinity$id <- Hepatocystis_trinity$Name


write_csv(Hepatocystis_trinity, file = "/home/brenda/RNASeq_liver_and_spleen/intermediateData/Hepatocystis_trinity_transcripts.txt",
          col_names = TRUE)

# getting the Hepatocystis counts from the feature counts file for the 3'Tags and RNASeqs
Tagseqs_trinity_counts <- readRDS("/home/brenda/RNASeq_liver_and_spleen/intermediateData/3'TagSeq_CountTable_trinity_de_novo_transcriptome.RDS")

# Renaming duplicate columns in Tagseqs_trinity_counts
colnames(Tagseqs_trinity_counts) <- make.unique(colnames(Tagseqs_trinity_counts))

Tagseqs_Hepatocystis_trinity_counts <- Tagseqs_trinity_counts %>%
    dplyr::filter(rownames(Tagseqs_trinity_counts) %in% Hepatocystis_trinity$id)

head(Tagseqs_Hepatocystis_trinity_counts)
str(Tagseqs_Hepatocystis_trinity_counts)


## for the RNASeqs counts file

RNAseqs_trinity_counts <- readRDS("/home/brenda/RNASeq_liver_and_spleen/intermediateData/RNASeqCountTable_trinity_de_novo_transcriptome.RDS")

RNAseqs_Hepatocystis_trinity_counts <- RNAseqs_trinity_counts %>%
  dplyr::filter(rownames(RNAseqs_trinity_counts) %in% Hepatocystis_trinity$id)

head(RNAseqs_Hepatocystis_trinity_counts)
str(RNAseqs_Hepatocystis_trinity_counts)



# Calculating row sums for tagseq and RNAseq feature counts separately
tagseq_trinity_rowsums <- rowSums(Tagseqs_Hepatocystis_trinity_counts)  
rnaseq_trinity_rowsums <- rowSums(RNAseqs_Hepatocystis_trinity_counts)  


# Creating separate dataframes with Transcript_ID as rownames and respective row sums
tagseq_trinity_summary <- data.frame(Transcript_ID = rownames(Tagseqs_Hepatocystis_trinity_counts), Tagseq_trinity_Rowsums = tagseq_trinity_rowsums)
rnaseq_trinity_summary <- data.frame(Transcript_ID = rownames(RNAseqs_Hepatocystis_trinity_counts), RNAseq_trinity_Rowsums = rnaseq_trinity_rowsums)

# Merging the summaries based on Transcript_ID
merged_trinity_Hep_summary <- merge(tagseq_trinity_summary, rnaseq_trinity_summary, by = "Transcript_ID", all = TRUE)

# replacing the NA values with zeros for plotting
merged_trinity_Hep_summary[is.na(merged_trinity_Hep_summary)] <- 0

# Displaying the first few rows of the merged summary
head(merged_trinity_Hep_summary)
str(merged_trinity_Hep_summary)

print(merged_trinity_Hep_summary)


saveRDS(merged_trinity_Hep_summary,file = "/home/brenda/RNASeq_liver_and_spleen/intermediateData/mergedTrinityHepatocystisCounts.RDS")


# visualising how the Tagseqs versus RNAseqs Hepatocystis transcripts compare
ggplot(merged_trinity_Hep_summary, aes(x=Tagseq_trinity_Rowsums, y=RNAseq_trinity_Rowsums)) +
  geom_point() 


# Creating gtf file for feature counts of Hepatocystis after the trinity de novo transcriptome assembly and mapping

# Loading necessary libraries
install.packages("GenomicAlignments")
library(GenomicAlignments)
library(dplyr)
library(readr)


# Specifying the path to the BAM file
bam_file <- "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_bat/E.labiatus_and_Hepatocystis_trinity_denovo_transcriptome_STARmapped/fastp_DMR855_PG_spleen_S3.STAR/fastp_DMR855_PG_spleen_S3.STAR_Aligned.sortedByCoord.out.bam"


# Extracting transcript IDs and positions from the BAM file
transcripts <- readGAlignments(bam_file)

head(transcripts)

# Extract transcript IDs, start positions, and end positions
transcript_ids <- seqnames(transcripts)
start_positions <- start(transcripts)
end_positions <- end(transcripts)

# Create a GRanges object with the extracted information
transcript_granges <- GRanges(seqnames = transcript_ids,
                              ranges = IRanges(start = start_positions, end = end_positions))

# Convert GRanges to a data frame
transcript_df <- data.frame(seqnames = seqnames(transcript_granges),
                            source = "Brenda",
                            feature = "transcript",
                            start = start(transcript_granges),
                            end = end(transcript_granges),
                            score = ".",
                            strand = strand(transcript_granges),
                            frame = ".",
                            attributes = paste("transcript_id", transcript_ids, sep = " "))

# Add gbkey information to the attributes column
transcript_df$attributes <- paste(transcript_df$attributes, "gbkey transcript", sep = "; ")


# Displaying the first few transcript df
head(transcript_df)

str(transcript_df)


#### to remove the duplicate transcript ids #### 

# Convert seqnames column to characters
transcript_df$seqnames <- as.character(transcript_df$seqnames)

# Identify duplicate rows based on seqnames
duplicate_rows <- duplicated(transcript_df$seqnames)

# Filter only unique rows
unique_transcript_df <- transcript_df[!duplicate_rows, ]

# For duplicate seqnames, keep the one with the longest transcript
unique_transcript_df <- unique_transcript_df %>%
  group_by(seqnames) %>%
  slice(which.max(end - start))

# Displaying the first few unique transcript df
head(unique_transcript_df)

str(unique_transcript_df)


# Saving the GTF file
write.table(unique_transcript_df, 
            file = "/home/brenda/RNASeq_liver_and_spleen/intermediateData/Hepatocystis_genomic.gtf",
            sep = "\t", 
            col.names = TRUE, 
            quote = FALSE, 
            row.names = FALSE)




# Reading in the GTF file 
Hepatocystis_genomic_gtf <- read_tsv("/home/brenda/RNASeq_liver_and_spleen/intermediateData/Hepatocystis_genomic.gtf")

# Viewing the structure of the data frame
str(Hepatocystis_genomic_gtf)

# Viewing the first few rows of the data frame
head(Hepatocystis_genomic_gtf)

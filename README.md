# RNASeq_liver_and_spleen
Analysis of RNA sequences from liver and spleen tissues of Hepatocystis infected Epomophorus labiatus. 
There are 9 paired ended reads sequences from 8 bats of which 8 samples are from spleen tissue and 1 sample is from a liver tissue; with one bat having both spleen and liver tissues samples. 
FastP was used for QC and prepocessing the raw reads which included trimming. 
The paired end reads were mapped using STAR mapper without annotation files.
Samtools sort was used for sorting and indexing the BAM files from STAR mapping.
Features counts was done using Rsubread package in R.
This generated the RNASeqCountTable.RDS files in the intermediateData directory.

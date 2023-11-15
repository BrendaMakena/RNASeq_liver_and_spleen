#!/bin/bash

echo "generating STAR index with merged E. labiatus de novo assembled transcriptome and Hepatocystis genome from Aunin 2020"

/tools/STAR-2.5.4b/bin/Linux_x86_64/STAR --runThreadN 40 \
--runMode genomeGenerate \
--genomeDir /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_index \
--genomeFastaFiles /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/genomes/E.labiatus_from_ProfKen_denovo_assembled_transcriptome/meta_transcripts_fpkm_1.fa /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/genomes/Hepatocystis_from_HPiliocolobus/GCA_902459845.2_HEP1_genomic.fna \




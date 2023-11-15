#!/bin/bash
# For every name in the file
find /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/fastp_qc/ -name "*R1.fq.gz" | while read FORWARD; do

# Getting the base file name without the extension
FILEBASE=$(basename "${FORWARD%_R1.fq.gz}")
echo "Running STAR on" $FILEBASE

# Getting the corresponding reverse read
REVERSE="/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/fastp_qc/${FILEBASE}_R2.fq.gz"

# Printing values for debugging
echo "FORWARD: $FORWARD"
echo "REVERSE. $REVERSE"

# Making new directory for every sample
mkdir -p "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_starMapped/$FILEBASE.STAR"

# Entering the new directory
cd "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_starMapped/$FILEBASE.STAR" || exit 1 

# Aligning with STAR
/tools/STAR-2.5.4b/bin/Linux_x86_64/STAR \
	--runThreadN 40 \
	--genomeDir "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_index" \
	--readFilesIn "$FORWARD" "$REVERSE" \
	--readFilesCommand "gunzip -c" \
	--outFileNamePrefix "/SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_starMapped/$FILEBASE.STAR/$FILEBASE.STAR_" \
	--outSAMtype BAM SortedByCoordinate \
	--outSAMunmapped Within \
	--outSAMattributes Standard

done

echo "done!"

#!/bin/bash
for i in /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/raw_reads/*_R1.good.fq.gz; do	
	
	second="${i/_R1.good.fq.gz/_R2.good.fq.gz}"

	echo "Running fastp on $i and $second"

	# Extracting the filename without the path and extension for cleaner output names
	    base_name=$(basename "$i" _R1.good.fq.gz)
	
	    /home/brenda/softwares/fastp -i $i -I $second -o /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/fastp_qc/fastp_${base_name}_R1.fq.gz -O /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/fastp_qc/fastp_${base_name}_R2.fq.gz --failed_out /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/fastp_qc/fastp_failed_${base_name}.fq.gz
done
echo "Done!" 

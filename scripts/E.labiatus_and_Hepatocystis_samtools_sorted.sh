#!/bin/bash

echo "sorting the bam files from STAR mapping using samtools index"

#making a list of BAM files and saving in a list
ls /SAN/RNASeqHepatoCy/HepatoTranscriptome/RNASeq_liver_and_spleen/STAR/E.labiatus_and_Hepatocystis_starMapped/*.STAR/*.bam > BAM.list ;
paste BAM.list | while read BAM ;

do
        samtools index "${BAM}" > "${BAM}".bai

 done
 echo "done!"

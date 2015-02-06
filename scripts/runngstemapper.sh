#!/bin/bash

if (( $# > 0 ))
then

	# Establish variables
	consensus_te_seqs=$1
	reference_genome=$2
	sample=$3
	fasta1_file=$4
	fasta2_file=$5
	outputfolder=$6
	test_dir=`pwd`
	
	mkdir -p $outputfolder/ngs_te_mapper

	# Run ngs_te_mapper
	$test_dir/sourceCode/ngs_te_mapper.R sample=$fasta1_file\;$fasta2_file genome=$reference_genome teFile=$consensus_te_seqs tsd=20 output=$outputfolder/ngs_te_mapper sourceCodeFolder=$test_dir/sourceCode

	# Extract only the relevant data from the output file and sort the results
	# Name and description for use with the UCSC genome browser are added to output here.
	awk -F'[\t;]' -v sample=$sample '{if($9=="old") print $1"\t"$2"\t"$3"\t"$6"_reference_"sample"_ngs_te_mapper_sr_"NR"\t0\t"$5; else print $1"\t"$2"\t"$3"\t"$6"_non-reference_"sample"_ngs_te_mapper_sr_"NR"\t0\t"$5;}' $outputfolder/ngs_te_mapper/bed_tsd/$sample"_1_"$sample"_2insertions.bed" > $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper_presort.bed"
	echo -e "track name=\"$sample"_ngs_te_mapper"\" description=\"$sample"_ngs_te_mapper"\"" > $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper_nonredundant.bed"
	bedtools sort -i $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper_presort.bed" >> $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper.bed.tmp"
	sed 's/NA/./g' $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper.bed.tmp" >> $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper_nonredundant.bed"
	rm $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper_presort.bed" $outputfolder/ngs_te_mapper/$sample"_ngs_te_mapper.bed.tmp"
	
else
	echo "Supply TE database as option 1"
	echo "Supply Reference genome as option 2"
	echo "Supply sample name as option 3"
	echo "Supply sequence fastas as options 4 and 5"
	echo "Supply output folder as option 6"
	echo "Result will be saved under SAMPLENAME_ngs_te_mapper.bed in the output directory"
fi


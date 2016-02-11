#!/bin/bash
####################################################################
## Description
## The wrapper script to assemble transcripts
## Author: Kisun Pokharel (kisun.pokharel@helsinki.fi)
##
####################################################################

mkdir -p results/fastqc-pretrim #Just to make sure, the quality of the data is fine and not adapters are present
mkdir -p results/trimmomatic #If data needs to be trimmed
mkdir -p results/fastqc-posttrim 
mkdir -p results/tophat
mkdir -p results/cufflinks

#Download the fastq files from http://www.ebi.ac.uk/seqdb/confluence/display/FAANG/Benchmarking+transcript+reconstruction+pipelines+on+real+human+RNA-seq+data
Data=$(sbatch getData.sh| cut -f 4 -d' ')
echo $Data

#Download the reference genome
Genome=$(sbatch getgenome.sh| cut -f 4 -d' ')
echo $Genome

#Download the annotation file
GTF=$(sbatch getgenome.sh| cut -f 4 -d' ')
echo $Genome

#Build reference genome index using bowtie2build
Bowtie2Build=$sbatch( bowtie2build.sh -d afterok:$Genome:$GTF| cut -f 4 -d' ')
echo $Bowtie2Build

#Run Fastqc on raw fastq files
##change the --array value based on number of samples, this can be included directly in .sh file
Fastqc1=$(sbatch fastqc_pretrim.sh -d afterok:$Data --array=1-30| cut -f 4 -d' ') 
echo $Fastqc1

#Run Trimmomatic
Trimmomatic=$(sbatch -d afterok:$Fastqc1 trimmomatic.sh --array=1-30| cut -f 4 -d' ')
echo $Trimmomatic

#Run Fastqc on trimmed data
Fastqc2=$(sbatch -d afterok:$Trimmomatic fastqc_posttrim.sh --array=1-30| cut -f 4 -d' ')
echo $Fastqc2

#Run Tophat2
Tophat2=$(sbatch -d afterok:$Fastqc2:$Bowtie2Build tophat2.sh --array=1-30| cut -f 4 -d' ')
echo $Tophat2

#Run Cufflinks
Cufflinks=$(sbatch -d afterok:$Tophat2 cufflinks.sh --array=1-30| cut -f 4 -d' ')
echo $Cufflinks

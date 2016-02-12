#!/bin/bash -l
#SBATCH -J TopHat
#SBATCH -o output_%j.txt
#SBATCH -e errors_%j.txt
#SBATCH -t 12:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=2000

module load biokit
cd /wrk/kipokh/Data/faang/TranscriptReconstruct/rawdata

#set up file names for a subjob
i=$(ls ENCFF001RED.fastq.gz )
b=$(ls ENCFF001RDZ.fastq.gz/')
basename="$i{%%001*}" #get the common name

#Run tophat
tophat -p 8 -o /wrk/kipokh/Data/faang/TranscriptReconstruct/tophat \
-G /wrk/kipokh/Data/faang/TranscriptReconstruct/annotation/gencode.v19.annotation.1trpergene_complete.gff \

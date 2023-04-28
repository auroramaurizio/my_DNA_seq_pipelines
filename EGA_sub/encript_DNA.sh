#!/bin/bash

#SBATCH --job-name=EGA_encryption
#SBATCH --account=maurizio.aurora
#SBATCH --mem=24GB  # amout of RAM in MB required (and max ram available).
#SBATCH --time=INFINITE  ## OR #SBATCH --time=10:00 means 10 minutes OR --time=01:00:00 means 1 hour
#SBATCH --ntasks=4  # nubmer of required cores
#SBATCH --nodes=1  # not really useful for not mpi jobs
#SBATCH --mail-type=END ## BEGIN, END, FAIL or ALL
#SBATCH --mail-user=maurizio.aurora@hsr.it
#SBATCH --error="/home/maurizio.aurora/jobs/myjob.err"
#SBATCH --output="/home/maurizio.aurora/jobs/myjob.out"




### Starting

echo "my job start now" > myjob.log;
cd /beegfs/scratch/ric.cosr/ric.cosr/DellabonaP/EGA_SUBMISSION;

### EGA encryption

java -jar /beegfs/scratch/ric.cosr/ric.cosr/DellabonaP/EGA_SUBMISSION/EGA-Cryptor-2.0.0/ega-cryptor-2.0.0.jar -t 4 -i ./DNA;

### Ending

echo "all done!!" > myjob.log

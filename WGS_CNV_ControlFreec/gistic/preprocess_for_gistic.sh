run.sh
#Readapted code by https://github.com/kunstner/freec2gistic. Thanks kunstner!
#wget -c ftp://ftp.broadinstitute.org/pub/GISTIC2.0/GISTIC_2_0_23.tar.gz

INPUT_FREEC=gistic.segments.numProbes.txt
#INPUT_FREEC=PTCL_0001_DNA_gistic.segments.numProbes.txt
REF_IDX=ref_hg38.genome
WORK_DIR=gistic_input

mkdir -p $WORK_DIR

for sample in $(cut -f1 $INPUT_FREEC | uniq); do
    echo $sample
    grep "$sample" $INPUT_FREEC |cut -f2-6|sed 's/^/chr/' > $WORK_DIR/$sample.bed
    bedtools sort -i $WORK_DIR/$sample.bed -faidx $REF_IDX > $WORK_DIR/$sample.sorted.bed
    bedtools complement -i $WORK_DIR/$sample.sorted.bed -g $REF_IDX > $WORK_DIR/$sample.complement.bed
    awk '{print $0, "\tNA\t0"}' $WORK_DIR/$sample.complement.bed > $WORK_DIR/$sample.CN2.bed
    cat $WORK_DIR/$sample.sorted.bed $WORK_DIR/$sample.CN2.bed > $WORK_DIR/$sample.whole.bed
    bedtools sort -i $WORK_DIR/$sample.whole.bed -faidx $REF_IDX > $WORK_DIR/$sample.whole.sorted.bed
    awk -v sample=$sample '{print sample"\t" $0}' $WORK_DIR/$sample.whole.sorted.bed > $WORK_DIR/$sample.whole.sorted.seg
done

cd $WORK_DIR
find . -name "*.whole.sorted.seg" -exec cat {} \; > ../samples.seg
cd ..

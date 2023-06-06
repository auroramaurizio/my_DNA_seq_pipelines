#egaencryptor automatically creates md5sum files

#alternatively ...

for i in $(ls *gz); do md5sum $i > ${i%%.gz}.md5; done

#or

md5sum *.fastq.gz > md5sum_fastq.txt

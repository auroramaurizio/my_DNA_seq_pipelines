lftp -d -u ega-box-XXXX,PASSWORD ftp.ega.ebi.ac.uk
set net:max-retries 1
set [ftp:ssl-allow]ftp:ssl-allow off
mirror --just-print ---log=transfer.log -R

##### Running process_radtags

Here is how single-end data received from an Illumina sequencer might look:

```bash
ls ./raw
lane3_NoIndex_L003_R1_001.fastq.gz  lane3_NoIndex_L003_R1_006.fastq.gz  lane3_NoIndex_L003_R1_011.fastq.gz
lane3_NoIndex_L003_R1_002.fastq.gz  lane3_NoIndex_L003_R1_007.fastq.gz  lane3_NoIndex_L003_R1_012.fastq.gz
lane3_NoIndex_L003_R1_003.fastq.gz  lane3_NoIndex_L003_R1_008.fastq.gz  lane3_NoIndex_L003_R1_013.fastq.gz
lane3_NoIndex_L003_R1_004.fastq.gz  lane3_NoIndex_L003_R1_009.fastq.gz
lane3_NoIndex_L003_R1_005.fastq.gz  lane3_NoIndex_L003_R1_010.fastq.gz
```

Then you can run **process_radtags** in the following way:

```bash
process_radtags -p ./raw/ -o ./samples/ -b ./barcodes/barcodes_lane3 \
                 -e sbfI -r -c -q
```

I specify the directory containing the input files, `./raw`, the directory I want **process_radtags** to enter the output files, `./samples`, and a file containing my barcodes, `./barcodes/barcodes_lane3`, along with the restriction enzyme I used and instructions to clean the data and correct barcodes and restriction enzyme cutsites (`-r`, `-c`, `-q`).

Here is a more complex example, using paired-end double-digested data (two restriction enzymes) with combinatorial barcodes, and gzipped input files. Here is what the raw Illumina files may look like:

```bash
ls ./raw
GfddRAD1_005_ATCACG_L007_R1_001.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_001.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_002.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_002.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_003.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_003.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_004.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_004.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_005.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_005.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_006.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_006.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_007.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_007.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_008.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_008.fastq.gz
GfddRAD1_005_ATCACG_L007_R1_009.fastq.gz  GfddRAD1_005_ATCACG_L007_R2_009.fastq.gz
```

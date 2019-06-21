set -u

THREADS=2

# Input
export DATA_BASE="/data/hts_2019_data"
export RAW_FASTQS="$DATA_BASE/hts2019_lab_rawdata"

# Output
export CUROUT=$HOME/work/scratch/pe_analysis
export TRIMMED=$CUROUT/trimmed_fastqs
export MYINFO=$CUROUT/myinfo
export GENOME_DIR=$CUROUT/genome
export STAR_OUT=$CUROUT/star_out
export FASTA=${GENOME_DIR}/Cryptococcus_neoformans_var_grubii_h99.CNA3.dna.toplevel.fa
export GTF=${GENOME_DIR}/Cryptococcus_neoformans_var_grubii_h99.CNA3.39.gtf
export COUNT_OUT=$CUROUT/count_out
export QC=$CUROUT/qc_output
export IGV_DIR="$CUROUT/igv"
export ADAPTERS=$MYINFO/neb_e7600_adapters.fasta
set -u

# Input
export DATA_BASE="/data/hts_2019_data"
export RAW_FASTQS="$DATA_BASE/hts2019_pilot_rawdata"

# Output
export CUROUT=$HOME/work/scratch/bioinf_intro
export TRIMMED=$CUROUT/trimmed_fastqs
export MYINFO=$CUROUT/myinfo
export GENOME_DIR=$CUROUT/genome
export STAR_OUT=$CUROUT/star_out
export COUNT_OUT=$CUROUT/count_out
export QC_RAW=$CUROUT/qc_output_raw
export QC_TRIM=$CUROUT/qc_output_trim
export IGV_DIR="$CUROUT/igv"
export ADAPTERS=$MYINFO/neb_e7600_adapters.fasta
export THREADS=2

# Genome
export FA_URL="ftp://ftp.ensemblgenomes.org/pub/release-39/fungi/fasta/fungi_basidiomycota1_collection/cryptococcus_neoformans_var_grubii_h99/dna/Cryptococcus_neoformans_var_grubii_h99.CNA3.dna.toplevel.fa.gz"
export GTF_URL="ftp://ftp.ensemblgenomes.org/pub/release-39/fungi/gtf/fungi_basidiomycota1_collection/cryptococcus_neoformans_var_grubii_h99/Cryptococcus_neoformans_var_grubii_h99.CNA3.39.gtf.gz"
export GTF=$(basename ${GTF_URL%.gz})
export FA=$(basename ${FA_URL%.gz})
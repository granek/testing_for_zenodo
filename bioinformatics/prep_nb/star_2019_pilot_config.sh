set -u

# Run Configs
export THREADS=1
export MAX_JOBS=6

# Input
export DATA_BASE="/data/hts_2019_data"
export RAW_FASTQS="$DATA_BASE/hts2019_pilot_rawdata"

# Output
export CUROUT=$HOME/work/scratch/bioinf_intro
export MYINFO=$CUROUT/myinfo

# export ADAPTERS="$INFO/neb_E7600_adapters_withrc.fasta"
export ADAPTERS="$MYINFO/neb_e7600_adapters.fasta"

# Output
export CUROUT=$HOME/work/scratch/bioinf_intro

# Output
export CUROUT=$HOME/work/scratch/hts2018_course
export TRIMMED=$CUROUT/trimmed_fastqs
export GENOME_DIR=$CUROUT/genome
export STAR_OUT=$CUROUT/star_out
export FINAL_COUNTS=$DATA_BASE/star_counts
export FINAL_BAMS=$DATA_BASE/star_bams
export FINAL_LOG=$DATA_BASE/star_logs

# Genome
export FA_URL="ftp://ftp.ensemblgenomes.org/pub/release-39/fungi/fasta/fungi_basidiomycota1_collection/cryptococcus_neoformans_var_grubii_h99/dna/Cryptococcus_neoformans_var_grubii_h99.CNA3.dna.toplevel.fa.gz"
export GTF_URL="ftp://ftp.ensemblgenomes.org/pub/release-39/fungi/gtf/fungi_basidiomycota1_collection/cryptococcus_neoformans_var_grubii_h99/Cryptococcus_neoformans_var_grubii_h99.CNA3.39.gtf.gz"
export GFF_URL="ftp://ftp.ensemblgenomes.org/pub/release-39/fungi/gff3/fungi_basidiomycota1_collection/cryptococcus_neoformans_var_grubii_h99/Cryptococcus_neoformans_var_grubii_h99.CNA3.39.gff3.gz"
export GFF=$(basename ${GFF_URL%.gz})
export GTF=$(basename ${GTF_URL%.gz})
export FA=$(basename ${FA_URL%.gz})

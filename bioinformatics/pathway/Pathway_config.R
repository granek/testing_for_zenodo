library(tidyverse)
library(stringr)

library(DESeq2)
library(pheatmap)

library(gage)

#library(pathview)
#library(IRdisplay)

CURDIR <- path.expand("~/work/scratch/analysis_output")
OUTDIR <- file.path(CURDIR, "out")
IMGDIR <- file.path(CURDIR, "img")
INFODIR <- "info"
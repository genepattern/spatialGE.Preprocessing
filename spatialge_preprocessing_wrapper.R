#!/usr/bin/env Rscript

# Load the getopt library
library(getopt)
library('ggplot2')
library('dplyr')
library( 'stringr')
library('spatialGE')
# Define the specification for each command line argument
spec <- matrix(c(
  "input.data.archive", "f", 2, "character",
  "verbose", "v", 2, "logical",
  "transform.data", "m", 2, "logical",
  "output_filename", "o", 2, "character",
  "pseudobulk", "p", 2, "logical",
  "pseudobulk.max.var.genes", "pmg", 1, "integer",
  "pseudobulk.plot.meta", "ppm", 1, "character",
  "pseudobulk.heatmap.num.displayed.genes", "phg", 1, "integer",
  "distribution.plot.meta", "dpm", 1, "character",
  "spot.min.reads", "smr", 1, "integer",
  "spot.min.genes", "smg", 1, "integer",
  "spot.max.reads", "sMr", 1, "integer",
  "spot.max.genes", "sMg", 1, "integer",
  "transform.scale.f", "tsf", 1, "integer",
  "transform.num.regression.genes", "tnrg", 1, "integer",
  "transform.min.spots.or.cells", "tmsc", 1, "integer",
  "spot.min.percent", "smp", 1, "integer",
  "spot.max.percent", "sMp", 1, "integer",
  "gene.min.reads", "gmr", 1, "integer",
  "gene.max.reads", "gMr", 1, "integer",
  "gene.min.spots", "gms", 1, "integer",
  "gene.max.spots", "gMs", 1, "integer",
  "gene.min.percent", "gmp", 1, "integer",
  "gene.max.percent", "gMp", 1, "integer",
  "filter.samples", "fs", 1, "character",
  "rm.tissue", "rt", 1, "character",
  "rm.spots", "rs", 1, "character",
  "rm.genes", "rg", 1, "character",
  "rm.genes.regex", "rgr", 1, "character",
  "spot.percentage.genes.regex", "spgr", 1, "character"
), byrow = TRUE, ncol = 4)

# Parse the command line arguments
opt <- getopt(spec)

# Assign the command line arguments to variables
input.data.archive <- ifelse(is.null(opt[["input.data.archive"]]), NA, opt[["input.data.archive"]])
verbose <- ifelse(is.null(opt[["verbose"]]), NA, as.logical(opt[["verbose"]]))
transform.data <- ifelse(is.null(opt[["transform.data"]]), NA, opt[["transform.data"]])
output_filename <- ifelse(is.null(opt[["output_filename"]]), NA, opt[["output_filename"]])
pseudobulk <- ifelse(is.null(opt[["pseudobulk"]]), NA, as.logical(opt[["pseudobulk"]]))
pseudobulk.max.var.genes <- ifelse(is.null(opt[["pseudobulk.max.var.genes"]]), NA, as.integer(opt[["pseudobulk.max.var.genes"]]))
pseudobulk.plot.meta <- ifelse(is.null(opt[["pseudobulk.plot.meta"]]), NA, opt[["pseudobulk.plot.meta"]])
pseudobulk.heatmap.num.displayed.genes <- ifelse(is.null(opt[["pseudobulk.heatmap.num.displayed.genes"]]), NA, as.integer(opt[["pseudobulk.heatmap.num.displayed.genes"]]))
distribution.plot.meta <- ifelse(is.null(opt[["distribution.plot.meta"]]), NA, opt[["distribution.plot.meta"]])
spot.min.reads <- ifelse(is.null(opt[["spot.min.reads"]]), NA, as.integer(opt[["spot.min.reads"]]))
spot.min.genes <- ifelse(is.null(opt[["spot.min.genes"]]), NA, as.integer(opt[["spot.min.genes"]]))
spot.max.reads <- ifelse(is.null(opt[["spot.max.reads"]]), NA, as.integer(opt[["spot.max.reads"]]))
spot.max.genes <- ifelse(is.null(opt[["spot.max.genes"]]), NA, as.integer(opt[["spot.max.genes"]]))
transform.scale.f <- ifelse(is.null(opt[["transform.scale.f"]]), NA, as.integer(opt[["transform.scale.f"]]))
transform.num.regression.genes <- ifelse(is.null(opt[["transform.num.regression.genes"]]), NA, as.integer(opt[["transform.num.regression.genes"]]))
transform.min.spots.or.cells <- ifelse(is.null(opt[["transform.min.spots.or.cells"]]), NA, as.integer(opt[["transform.min.spots.or.cells"]]))
spot.min.percent <- ifelse(is.null(opt[["spot.min.percent"]]), NA, as.integer(opt[["spot.min.percent"]]))
spot.max.percent <- ifelse(is.null(opt[["spot.max.percent"]]), NA, as.integer(opt[["spot.max.percent"]]))
gene.min.reads <- ifelse(is.null(opt[["gene.min.reads"]]), NA, as.integer(opt[["gene.min.reads"]]))
gene.max.reads <- ifelse(is.null(opt[["gene.max.reads"]]), NA, as.integer(opt[["gene.max.reads"]]))
gene.min.spots <- ifelse(is.null(opt[["gene.min.spots"]]), NA, as.integer(opt[["gene.min.spots"]]))
gene.max.spots <- ifelse(is.null(opt[["gene.max.spots"]]), NA, as.integer(opt[["gene.max.spots"]]))
gene.min.percent <- ifelse(is.null(opt[["gene.min.percent"]]), NA, as.integer(opt[["gene.min.percent"]]))
gene.max.percent <- ifelse(is.null(opt[["gene.max.percent"]]), NA, as.integer(opt[["gene.max.percent"]]))
filter.samples <- ifelse(is.null(opt[["filter.samples"]]), NA, opt[["filter.samples"]])
rm.tissue <- ifelse(is.null(opt[["rm.tissue"]]), NA, opt[["rm.tissue"]])
rm.spots <- ifelse(is.null(opt[["rm.spots"]]), NA, opt[["rm.spots"]])
rm.genes <- ifelse(is.null(opt[["rm.genes"]]), NA, opt[["rm.genes"]])
rm.genes.regex <- ifelse(is.null(opt[["rm.genes.regex"]]), NA, opt[["rm.genes.regex"]])
spot.percentage.genes.regex <- ifelse(is.null(opt[["spot.percentage.genes.regex"]]), NA, opt[["spot.percentage.genes.regex"]])

# start by making the data into an STList object
# for that we need to gunzip input.data.archive
# and then read the data into an STList object

# Create a temporary directory
temp_dir <- tempdir()

# Create the path to the new file location in the temporary directory
new_file_location <- file.path(temp_dir, basename(input.data.archive))

# Copy the file to the new location
file.copy(input.data.archive, new_file_location)

# Use the system() function to execute the gunzip command with the new file location
system(paste("gunzip ", new_file_location))

# first pass, assume visium data.  Later need to generalize this bit
visium_folders <- list.dirs(temp_dir, full.names=T, recursive=F)
clin_file <- list.files(data_files, full.names=T, recursive=F, pattern='clinical')
print(visium_folders)
if(length(clin_file) <= 0){
    stop('No clinical file found in the data archive')
}

tnbc <- STlist(rnacounts=visium_folders, samples=clin_file)

summarize_STlist(tnbc)


# At the end of the script, delete the temporary directory and its contents
unlink(temp_dir, recursive = TRUE)
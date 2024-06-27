#!/usr/bin/env Rscript

# Load the getopt library
library(getopt)

# Define the specification for each command line argument
spec <- matrix(c(
  "input.data.archive", "f", 2, "character",
  "verbose", "v", 2, "logical",
  "transform.data", "m", 2, "character",
  "output_filename", "o", 2, "character",
  "pseudobulk", "p", 2, "logical",
  "pseudobulk.max.var.genes", "pmg", 2, "integer",
  "pseudobulk.plot.meta", "ppm", 2, "character",
  "pseudobulk.heatmap.num.displayed.genes", "phg", 2, "integer",
  "distribution.plot.meta", "dpm", 2, "character",
  "spot.min.reads", "smr", 2, "integer",
  "spot.min.genes", "smg", 2, "integer",
  "spot.max.reads", "smr", 2, "integer",
  "spot.max.genes", "smg", 2, "integer"
), byrow = TRUE, ncol = 4)

# Parse the command line arguments
opt <- getopt(spec)

# Assign the command line arguments to variables
input.data.archive <- opt[["input.data.archive"]]
verbose <- as.logical(opt[["verbose"]])
transform.data <- opt[["transform.data"]]
output_filename <- opt[["output_filename"]]
pseudobulk <- as.logical(opt[["pseudobulk"]])
pseudobulk.max.var.genes <- as.integer(opt[["pseudobulk.max.var.genes"]])
pseudobulk.plot.meta <- opt[["pseudobulk.plot.meta"]]
pseudobulk.heatmap.num.displayed.genes <- as.integer(opt[["pseudobulk.heatmap.num.displayed.genes"]])
distribution.plot.meta <- opt[["distribution.plot.meta"]]
spot.min.reads <- as.integer(opt[["spot.min.reads"]])
spot.min.genes <- as.integer(opt[["spot.min.genes"]])
spot.max.reads <- as.integer(opt[["spot.max.reads"]])
spot.max.genes <- as.integer(opt[["spot.max.genes"]])
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
  "transform.data", "m", 2, "character",
  "output_filename", "o", 2, "character",
  "pseudobulk", "p", 2, "logical",
  "pseudobulk.max.var.genes", "pmg", 1, "integer",
  "pseudobulk.plot.meta", "ppm", 1, "character",
  "pseudobulk.heatmap.num.displayed.genes", "phg", 1, "integer",
  "distribution.plot.meta", "dpm", 1, "character",
  "spot.min.reads", "smr", 1, "integer",
  "spot.min.genes", "smg", 1, "integer",
  "spot.max.reads", "smr", 1, "integer",
  "spot.max.genes", "smg", 1, "integer",
  "transform.scale.f", "", 1, "integer",
  "transform.num.regression.genes", "", 1, "integer",
  "transform.min.spots.or.cells", "", 1, "integer",
  "spot.min.percent", "", 1, "integer",
  "spot.max.percent", "", 1, "integer",
  "gene.min.reads", "", 1, "integer",
  "gene.max.reads", "", 1, "integer",
  "gene.min.spots", "", 1, "integer",
  "gene.max.spots", "", 1, "integer",
  "gene.min.percent", "", 1, "integer",
  "gene.max.percent", "", 1, "integer",
  "filter.samples", "", 1, "character",
  "rm.tissue", "", 1, "character",
  "rm.spots", "", 1, "character",
  "rm.genes", "", 1, "character",
  "rm.genes.regex", "", 1, "character",
  "spot.percentage.genes.regex", "", 1, "character"
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
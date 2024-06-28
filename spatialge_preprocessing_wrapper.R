#!/usr/bin/env Rscript

# Load the getopt library
library(optparse)
library('ggplot2')
library('dplyr')
library( 'stringr')
library('spatialGE')


# Define the specification for each command line argument
option_list = list(
  make_option(c("-a", "--input_data_archive"), type="character", default=NA, help="input data archive"),
  make_option(c("-b", "--input_clinical_data"), type="character", default=NA, help="input clinical data"),
  make_option(c("-c", "--verbose"), type="logical", default=NA, help="verbose"),
  make_option(c("-d", "--transform_data"), type="logical", default=NA, help="transform data"),
  make_option(c("-e", "--output_filename"), type="character", default=NA, help="output filename"),
  make_option(c("-f", "--pseudobulk"), type="logical", default=NA, help="pseudobulk"),
  make_option(c("-g", "--pseudobulk_max_var_genes"), type="integer", default=NA, help="pseudobulk max var genes"),
  make_option(c("-F", "--pseudobulk_plot_meta"), type="character", default=NA, help="pseudobulk plot meta"),
  make_option(c("-i", "--pseudobulk_heatmap_num_displayed_genes"), type="integer", default=NA, help="pseudobulk heatmap num displayed genes"),
  make_option(c("-j", "--distribution_plot_meta"), type="character", default=NA, help="distribution plot meta"),
  make_option(c("-k", "--spot_min_reads"), type="integer", default=NA, help="spot min reads"),
  make_option(c("-l", "--spot_min_genes"), type="integer", default=NA, help="spot min genes"),
  make_option(c("-m", "--spot_max_reads"), type="integer", default=NA, help="spot max reads"),
  make_option(c("-n", "--spot_max_genes"), type="integer", default=NA, help="spot max genes"),
  make_option(c("-o", "--transform_scale_f"), type="integer", default=NA, help="transform scale f"),
  make_option(c("-p", "--transform_num_regression_genes"), type="integer", default=NA, help="transform num regression genes"),
  make_option(c("-q", "--transform_min_spots_or_cells"), type="integer", default=NA, help="transform min spots or cells"),
  make_option(c("-r", "--spot_min_percent"), type="integer", default=NA, help="spot min percent"),
  make_option(c("-s", "--spot_max_percent"), type="integer", default=NA, help="spot max percent"),
  make_option(c("-t", "--gene_min_reads"), type="integer", default=NA, help="gene min reads"),
  make_option(c("-u", "--gene_max_reads"), type="integer", default=NA, help="gene max reads"),
  make_option(c("-v", "--gene_min_spots"), type="integer", default=NA, help="gene min spots"),
  make_option(c("-w", "--gene_max_spots"), type="integer", default=NA, help="gene max spots"),
  make_option(c("-x", "--gene_min_percent"), type="integer", default=NA, help="gene min percent"),
  make_option(c("-y", "--gene_max_percent"), type="integer", default=NA, help="gene max percent"),
  make_option(c("-z", "--filter_samples"), type="character", default=NA, help="filter samples"),
  make_option(c("-A", "--rm_tissue"), type="character", default=NA, help="rm tissue"),
  make_option(c("-B", "--rm_spots"), type="character", default=NA, help="rm spots"),
  make_option(c("-C", "--rm_genes"), type="character", default=NA, help="rm genes"),
  make_option(c("-D", "--rm_genes_regex"), type="character", default=NA, help="rm genes regex"),
  make_option(c("-E", "--spot_percentage_genes_regex"), type="character", default=NA, help="spot percentage genes regex")
  make_option(c("-G", "--filter_data"), type="logical", default=TRUE, help="filter data"),
)
# Parse the command line arguments
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# Assign the command line arguments to variables
# Replace all the periods in the variable names with underscores
input_data_archive <- ifelse(is.null(opt[["input_data_archive"]]), NA, opt[["input_data_archive"]])
input_clinical_data <- ifelse(is.null(opt[["input_clinical_data"]]), NA, opt[["input_clinical_data"]])
verbose <- ifelse(is.null(opt[["verbose"]]), NA, as.logical(opt[["verbose"]]))
transform_data <- ifelse(is.null(opt[["transform_data"]]), NA, opt[["transform_data"]])
filter_data <- ifelse(is.null(opt[["filter_data"]]), NA, opt[["filter_data"]])
output_filename <- ifelse(is.null(opt[["output_filename"]]), NA, opt[["output_filename"]])
pseudobulk <- ifelse(is.null(opt[["pseudobulk"]]), NA, as.logical(opt[["pseudobulk"]]))
pseudobulk_max_var_genes <- ifelse(is.null(opt[["pseudobulk_max_var_genes"]]), NA, as.integer(opt[["pseudobulk_max_var_genes"]]))
pseudobulk_plot_meta <- ifelse(is.null(opt[["pseudobulk_plot_meta"]]), NA, opt[["pseudobulk_plot_meta"]])
pseudobulk_heatmap_num_displayed_genes <- ifelse(is.null(opt[["pseudobulk_heatmap_num_displayed_genes"]]), NA, as.integer(opt[["pseudobulk_heatmap_num_displayed_genes"]]))
distribution_plot_meta <- ifelse(is.null(opt[["distribution_plot_meta"]]), NA, opt[["distribution_plot_meta"]])
spot_min_reads <- ifelse(is.null(opt[["spot_min_reads"]]), NA, as.integer(opt[["spot_min_reads"]]))
spot_min_genes <- ifelse(is.null(opt[["spot_min_genes"]]), NA, as.integer(opt[["spot_min_genes"]]))
spot_max_reads <- ifelse(is.null(opt[["spot_max_reads"]]), NA, as.integer(opt[["spot_max_reads"]]))
spot_max_genes <- ifelse(is.null(opt[["spot_max_genes"]]), NA, as.integer(opt[["spot_max_genes"]]))
transform_scale_f <- ifelse(is.null(opt[["transform_scale_f"]]), NA, as.integer(opt[["transform_scale_f"]]))
transform_num_regression_genes <- ifelse(is.null(opt[["transform_num_regression_genes"]]), NA, as.integer(opt[["transform_num_regression_genes"]]))
transform_min_spots_or_cells <- ifelse(is.null(opt[["transform_min_spots_or_cells"]]), NA, as.integer(opt[["transform_min_spots_or_cells"]]))
spot_min_percent <- ifelse(is.null(opt[["spot_min_percent"]]), NA, as.integer(opt[["spot_min_percent"]]))
spot_max_percent <- ifelse(is.null(opt[["spot_max_percent"]]), NA, as.integer(opt[["spot_max_percent"]]))
gene_min_reads <- ifelse(is.null(opt[["gene_min_reads"]]), NA, as.integer(opt[["gene_min_reads"]]))
gene_max_reads <- ifelse(is.null(opt[["gene_max_reads"]]), NA, as.integer(opt[["gene_max_reads"]]))
gene_min_spots <- ifelse(is.null(opt[["gene_min_spots"]]), NA, as.integer(opt[["gene_min_spots"]]))
gene_max_spots <- ifelse(is.null(opt[["gene_max_spots"]]), NA, as.integer(opt[["gene_max_spots"]]))
gene_min_percent <- ifelse(is.null(opt[["gene_min_percent"]]), NA, as.integer(opt[["gene_min_percent"]]))
gene_max_percent <- ifelse(is.null(opt[["gene_max_percent"]]), NA, as.integer(opt[["gene_max_percent"]]))
filter_samples <- ifelse(is.null(opt[["filter_samples"]]), NA, opt[["filter_samples"]])
rm_tissue <- ifelse(is.null(opt[["rm_tissue"]]), NA, opt[["rm_tissue"]])
rm_spots <- ifelse(is.null(opt[["rm_spots"]]), NA, opt[["rm_spots"]])
rm_genes <- ifelse(is.null(opt[["rm_genes"]]), NA, opt[["rm_genes"]])
rm_genes_regex <- ifelse(is.null(opt[["rm_genes_regex"]]), NA, opt[["rm_genes_regex"]])
spot_percentage_genes_regex <- ifelse(is.null(opt[["spot_percentage_genes_regex"]]), NA, opt[["spot_percentage_genes_regex"]])
# start by making the data into an STList object
# for that we need to gunzip input.data.archive
# and then read the data into an STList object

# Create a temporary directory
temp_dir <- tempdir()
print(temp_dir)
# Create the path to the new file location in the temporary directory
new_file_location <- file.path(temp_dir, basename(input_data_archive))

# Copy the file to the new location
file.copy(input_data_archive, new_file_location)

# Use the system() function to execute the gunzip command with the new file location
system(paste("tar xvf ", new_file_location,  "-C", temp_dir))

# first pass, assume visium data.  Later need to generalize this bit
visium_folders <- list.dirs(temp_dir, full.names=T, recursive=F)

# if there is a single folder, its probably the top of an archive so
# we need to go down one level
if (length(visium_folders) <= 1){
    visium_folders <- list.dirs(visium_folders, full.names=T, recursive=F)
}

if(length(input_clinical_data) <= 0){
    stop('No clinical file found in the data archive')
}

tnbc <- STlist(rnacounts=visium_folders, samples=input.clinical.data)

summarize_STlist(tnbc)

png("distribution_plot_prefiltering.png")
cp <- distribution_plots(tnbc, plot_type='violin', plot_meta=distribution_plot_meta)
dev.off()

cp[['total_counts']]

if (filter_data){
    tnbc <- filter_data(tnbc, spot_min_reads=spot_min_reads, spot_min_genes=spot_min_genes, spot_max_reads=spot_max_reads, spot_max_genes=spot_max_genes, gene_min_reads=gene_min_reads, gene_max_reads=gene_max_reads, gene_min_spots=gene_min_spots, gene_max_spots=gene_max_spots, gene_min_percent=gene_min_percent, gene_max_percent=gene_max_percent, spot_min_percent=spot_min_percent, spot_max_percent=spot_max_percent, filter_samples=filter_samples, rm_tissue=rm_tissue, rm_spots=rm_spots, rm_genes=rm_genes, rm_genes_regex=rm_genes_regex, spot_percentage_genes_regex=spot_percentage_genes_regex)
    png("distribution_plot_postfiltering.png")
    cp <- distribution_plots(tnbc, plot_type='violin', plot_meta=distribution_plot_meta)
    dev.off()
}

if (pseudobulk) {
    tnbc <- pseudobulk_samples(tnbc, max_var_genes=pseudobulk_max_var_genes)
    png("pseudobulk_pca.png")
    pseudobulk_pca_plot(tnbc, plot_meta=pseudobulk_plot_meta)
    dev.off()
    png("pseudobulk_heatmap.png")
    pseudobulk_heatmap(tnbc, plot_meta=pseudobulk_plot_meta, num_displayed_genes=pseudobulk_heatmap_num_displayed_genes)
    dev.off()
}

if (transform_data) {
    tnbc <- transform_data(tnbc, scale_f=transform_scale_f, num_regression_genes=transform_num_regression_genes, min_spots_or_cells=transform_min_spots_or_cells)
}


saveRDS(tnbc, output_filename)



# At the end of the script, delete the temporary directory and its contents
unlink(temp_dir, recursive = TRUE)

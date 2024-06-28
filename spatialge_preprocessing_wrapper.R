#!/usr/bin/env Rscript

# Load the getopt library
library(optparse)
library('ggplot2')
library('dplyr')
library( 'stringr')
library('spatialGE')
library('magrittr')

make_option_safe <- function(...) {
  res <- tryCatch(
    make_option(...),
    error = function(e) {
      print(paste("Failed to create option:", deparse(substitute(...))))
      print(e)
      NULL
    }
  )
  if (is.null(res)) {
    stop("Failed to create an option")
  }
  res
}

# Define the specification for each command line argument
# Define the specification for each command line argument
option_list = list(
  make_option_safe(c("-a", "--input_data_archive"), type="character",  help="input data archive"),
  make_option_safe(c("-b", "--input_clinical_data"), type="character",  help="input clinical data"),
  make_option_safe(c("-c", "--verbose"), type="logical", default=FALSE, help="verbose"),
  make_option_safe(c("-d", "--transform_data"), type="logical", default=TRUE, help="transform data"),
  make_option_safe(c("-e", "--output_filename"), type="character",  help="output filename"),
  make_option_safe(c("-f", "--pseudobulk"), type="logical", default=TRUE, help="pseudobulk"),
  make_option_safe(c("-g", "--pseudobulk_max_var_genes"), type="integer", default=5000, help="pseudobulk max var genes"),
  make_option_safe(c("-F", "--pseudobulk_plot_meta"), type="character", default='patient_id', help="pseudobulk plot meta"),
  make_option_safe(c("-i", "--pseudobulk_heatmap_num_displayed_genes"), type="integer", default=30, help="pseudobulk heatmap num displayed genes"),
  make_option_safe(c("-j", "--distribution_plot_meta"), type="character", default='total_counts', help="distribution plot meta"),
  make_option_safe(c("-k", "--spot_min_reads"), type="integer", default=0, help="spot min reads"),
  make_option_safe(c("-l", "--spot_min_genes"), type="integer", default=0, help="spot min genes"),
  make_option_safe(c("-m", "--spot_max_reads"), type="integer", default=NULL, help="spot max reads"),
  make_option_safe(c("-n", "--spot_max_genes"), type="integer", default=NULL, help="spot max genes"),
  make_option_safe(c("-o", "--transform_scale_f"), type="integer", default=NA, help="transform scale f"),
  make_option_safe(c("-p", "--transform_num_regression_genes"), type="integer", default=NA, help="transform num regression genes"),
  make_option_safe(c("-q", "--transform_min_spots_or_cells"), type="integer", default=NA, help="transform min spots or cells"),
  make_option_safe(c("-r", "--spot_min_percent"), type="integer", default=0, help="spot min percent"),
  make_option_safe(c("-s", "--spot_max_percent"), type="integer", default=NULL, help="spot max percent"),
  make_option_safe(c("-t", "--gene_min_reads"), type="integer", default=0, help="gene min reads"),
  make_option_safe(c("-u", "--gene_max_reads"), type="integer", default=NULL, help="gene max reads"),
  make_option_safe(c("-v", "--gene_min_spots"), type="integer", default=0, help="gene min spots"),
  make_option_safe(c("-w", "--gene_max_spots"), type="integer", default=NULL, help="gene max spots"),
  make_option_safe(c("-x", "--gene_min_percent"), type="integer", default=0, help="gene min percent"),
  make_option_safe(c("-y", "--gene_max_percent"), type="integer", default=NULL, help="gene max percent"),
  make_option_safe(c("-z", "--filter_samples"), type="character", default=NULL, help="filter samples"),
  make_option_safe(c("-A", "--rm_tissue"), type="character", default=NULL, help="rm tissue"),
  make_option_safe(c("-B", "--rm_spots"), type="character", default=NULL, help="rm spots"),
  make_option_safe(c("-C", "--rm_genes"), type="character", default=NULL, help="rm genes"),
  make_option_safe(c("-D", "--rm_genes_regex"), type="character", default=NULL, help="rm genes regex"),
  make_option_safe(c("-E", "--spot_percentage_regex"), type="character", default="^MT-", help="spot percentage regex"),
  make_option_safe(c("-G", "--filter_data"), type="logical", default=TRUE, help="filter data")
)

# Parse the command line arguments
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# Assign the command line arguments to variables
# Replace all the periods in the variable names with underscores
input_data_archive <- if(is.null(opt[["input_data_archive"]])) NA else opt[["input_data_archive"]]
input_clinical_data <- if(is.null(opt[["input_clinical_data"]])) NA else opt[["input_clinical_data"]]
verbose <- if(is.null(opt[["verbose"]])) NA else as.logical(opt[["verbose"]])
transform_data <- if(is.null(opt[["transform_data"]])) TRUE else opt[["transform_data"]]
filter_data <- if(is.null(opt[["filter_data"]])) TRUE else opt[["filter_data"]]
output_filename <- if(is.null(opt[["output_filename"]])) NA else opt[["output_filename"]]
pseudobulk <- if(is.null(opt[["pseudobulk"]])) TRUE else as.logical(opt[["pseudobulk"]])
pseudobulk_max_var_genes <- if(is.null(opt[["pseudobulk_max_var_genes"]])) 5000 else as.integer(opt[["pseudobulk_max_var_genes"]])
pseudobulk_plot_meta <- if(is.null(opt[["pseudobulk_plot_meta"]])) 'patient_id' else opt[["pseudobulk_plot_meta"]]
pseudobulk_heatmap_num_displayed_genes <- if(is.null(opt[["pseudobulk_heatmap_num_displayed_genes"]])) 30 else as.integer(opt[["pseudobulk_heatmap_num_displayed_genes"]])
distribution_plot_meta <- if(is.null(opt[["distribution_plot_meta"]])) 'total_counts' else opt[["distribution_plot_meta"]]
spot_min_reads <- if(is.null(opt[["spot_min_reads"]])) 0 else as.integer(opt[["spot_min_reads"]])
spot_min_genes <- if(is.null(opt[["spot_min_genes"]])) 0 else as.integer(opt[["spot_min_genes"]])
spot_max_reads <- if(is.null(opt[["spot_max_reads"]])) NULL else as.integer(opt[["spot_max_reads"]])
spot_max_genes <- if(is.null(opt[["spot_max_genes"]])) NULL else as.integer(opt[["spot_max_genes"]])
transform_scale_f <- if(is.null(opt[["transform_scale_f"]])) 10000 else as.integer(opt[["transform_scale_f"]])
transform_num_regression_genes <- if(is.null(opt[["transform_num_regression_genes"]])) 3000 else as.integer(opt[["transform_num_regression_genes"]])
transform_min_spots_or_cells <- if(is.null(opt[["transform_min_spots_or_cells"]])) 5 else as.integer(opt[["transform_min_spots_or_cells"]])
spot_min_percent <- if(is.null(opt[["spot_min_percent"]])) 0 else as.integer(opt[["spot_min_percent"]])
spot_max_percent <- if(is.null(opt[["spot_max_percent"]])) NULL else as.integer(opt[["spot_max_percent"]])
gene_min_reads <- if(is.null(opt[["gene_min_reads"]])) 0 else as.integer(opt[["gene_min_reads"]])
gene_max_reads <- if(is.null(opt[["gene_max_reads"]])) NULL else as.integer(opt[["gene_max_reads"]])
gene_min_spots <- if(is.null(opt[["gene_min_spots"]])) 0 else as.integer(opt[["gene_min_spots"]])
gene_max_spots <- if(is.null(opt[["gene_max_spots"]])) NULL else as.integer(opt[["gene_max_spots"]])
gene_min_percent <- if(is.null(opt[["gene_min_percent"]])) 0 else as.integer(opt[["gene_min_percent"]])
gene_max_percent <- if(is.null(opt[["gene_max_percent"]])) NULL else as.integer(opt[["gene_max_percent"]])
filter_samples <- if(is.null(opt[["filter_samples"]])) NULL else opt[["filter_samples"]]
rm_tissue <- if(is.null(opt[["rm_tissue"]])) NULL else opt[["rm_tissue"]]
rm_spots <- if(is.null(opt[["rm_spots"]])) NULL else opt[["rm_spots"]]
rm_genes <- if(is.null(opt[["rm_genes"]])) NULL else opt[["rm_genes"]]
rm_genes_regex <- if(is.null(opt[["rm_genes_regex"]])) NULL else opt[["rm_genes_regex"]]
spot_percentage_regex <- if(is.null(opt[["spot_percentage_regex"]])) "^MT-" else opt[["spot_percentage_regex"]]



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

tnbc <- STlist(rnacounts=visium_folders, samples=input_clinical_data)

summarize_STlist(tnbc)

png("1distribution_plot_unfiltered.png")
tryCatch({
  cp <- distribution_plots(tnbc, plot_type='violin', plot_meta=distribution_plot_meta)
}, error = function(e) {
  print(paste("Error in distribution_plots:", e$message))
})
cp[['total_counts']]
dev.off()

if (filter_data){
    tryCatch({


        # Create a list of the values passed to the function
        passed_values <- list(spot_minreads=spot_min_reads, spot_mingenes=spot_min_genes, spot_maxreads=spot_max_reads, spot_maxgenes=spot_max_genes, gene_minreads=gene_min_reads, gene_maxreads=gene_max_reads, gene_minspots=gene_min_spots, gene_maxspots=gene_max_spots, gene_minpct=gene_min_percent, gene_maxpct=gene_max_percent, spot_minpct=spot_min_percent, spot_maxpct=spot_max_percent, samples=filter_samples, rm_tissue=rm_tissue, rm_spots=rm_spots, rm_genes=rm_genes, rm_genes_expr=rm_genes_regex, spot_pct_expr=spot_percentage_regex)

        # Iterate over the names of the default_values and passed_values lists
        for(name in names(default_values)) {
            # Print the name, default value, and passed value
            print(paste(name, ": def:",  "   passed:", passed_values[[name]]))
        }



         tnbc <- filter_data(tnbc, spot_minreads=spot_min_reads, spot_mingenes=spot_min_genes, spot_maxreads=spot_max_reads, spot_maxgenes=spot_max_genes, gene_minreads=gene_min_reads, gene_maxreads=gene_max_reads, gene_minspots=gene_min_spots, gene_maxspots=gene_max_spots, gene_minpct=gene_min_percent, gene_maxpct=gene_max_percent, spot_minpct=spot_min_percent, spot_maxpct=spot_max_percent, samples=filter_samples, rm_tissue=rm_tissue, rm_spots=rm_spots, rm_genes=rm_genes, rm_genes_expr=rm_genes_regex, spot_pct_expr=spot_percentage_regex)

         summarize_STlist(tnbc)
    }, error = function(e) {
      print(paste("Error in filter_data:", e$message))
    })
    print("post filter summary")
    summarize_STlist(tnbc)
    print("Create post filter png file now")
    png("2distribution_plot_postfiltering.png")
    tryCatch({
          cp <- distribution_plots(tnbc, plot_type='violin', plot_meta=distribution_plot_meta)
          cp[['total_counts']]
    }, error = function(e) {
          print(paste("Error in post filter distribution_plots:", e$message))
    })
    print("done second plot")
    dev.off()
}

if (pseudobulk) {
    tnbc <- pseudobulk_samples(tnbc, max_var_genes=pseudobulk_max_var_genes)
    png("3pseudobulk_pca.png")
    pseudobulk_pca_plot(tnbc, plot_meta=pseudobulk_plot_meta)
    dev.off()
    png("4pseudobulk_heatmap.png")
    pseudobulk_heatmap(tnbc, plot_meta=pseudobulk_plot_meta, hm_display_genes=pseudobulk_heatmap_num_displayed_genes)
    dev.off()
}

if (transform_data) {
    tnbc <- transform_data(tnbc, scale_f=transform_scale_f, sct_n_regr_genes=transform_num_regression_genes, sct_min_cells=transform_min_spots_or_cells)
}

print(paste("Saving the data to", output_filename))
saveRDS(tnbc, output_filename)



# At the end of the script, delete the temporary directory and its contents
unlink(temp_dir, recursive = TRUE)

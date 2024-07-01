#!/bin/bash

# Define the required arguments
input_data_archive="data/archive_name.tar.gz"
input_clinical_data="data/sample_clinical.tsv"
output_filename="output_"
verbose="TRUE" # or "FALSE"
transform_data="TRUE"
pseudobulk="TRUE" # or "FALSE"
pseudobulk_plot_meta="patient_id"
filter_data="TRUE"
distribution_plot_meta="total_counts"
#spot_minreads=5000, spot_mingenes=1000,  spot_maxreads=150000
spot_min_reads=5000
spot_min_genes=1000
spot_max_reads=150000
#spot_max_genes="value"
#transform_scale_f="value"
#transform_num_regression_genes="value"
#transform_min_spots_or_cells="value"
#spot_min_percent="value"
#spot_max_percent="value"
#gene_min_reads="value"
#gene_max_reads="value"
#gene_min_spots="value"
#gene_max_spots="value"
#gene_min_percent="value"
#gene_max_percent="value"
#filter_samples="/path/to/filter/samples"
#rm_tissue="/path/to/rm/tissue"
#rm_spots="/path/to/rm/spots"
#rm_genes="/path/to/rm/genes"
#rm_genes_regex="/path/to/rm/genes/regex"
#spot_percentage_genes_regex="/path/to/spot/percentage/genes/regex"


# Run the R script with the required arguments
#Rscript spatialge_preprocessing_wrapper.R --input_clinical_data $input_clinical_data  --input_data_archive $input_data_archive --output_filename $output_filename -v $verbose -m $transform_data --pseudobulk $pseudobulk  --distribution.plot.meta $distribution_plot_meta

# Run the R script with the required arguments
Rscript ./spatialge_preprocessing_wrapper.R -b $input_clinical_data -a $input_data_archive -e $output_filename -c $verbose -d $transform_data -f $pseudobulk -j $distribution_plot_meta -G $filter_data -k $spot_min_reads -l $spot_min_genes -m $spot_max_reads -F $pseudobulk_plot_meta

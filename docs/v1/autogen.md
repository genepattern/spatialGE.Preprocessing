# spatialGE.Preprocess Wrapper Script

## Summary
This repository contains a wrapper script for the `spatialGE.Preprocess` module, designed to preprocess spatial transcriptomics data. The script leverages the `spatialGE` package in R to transform, filter, and perform pseudobulk analysis on the input data. Additionally, it provides an option to plot intermediate results for better visualization and understanding of the preprocessing steps.

## Authors
- **Your Name** - *Initial work* - [Your GitHub Profile](https://github.com/yourprofile)

## Programming Language
- **R**

## Usage
To run the wrapper script, use the following command:
```sh
Rscript spatialGE_Preprocess.R --input path/to/input.tar.gz --output path/to/output --method log --scale_f 10000 --sct_n_regr_genes 3000 --sct_min_cells 5 --cores 4 --spot_minreads 5000 --spot_maxreads 150000 --spot_mingenes 1000 --spot_maxgenes 2000 --spot_minpct 0.1 --spot_maxpct 0.5 --gene_minreads 10 --gene_maxreads 10000 --gene_minspots 5 --gene_maxspots 100 --gene_minpct 0.1 --gene_maxpct 0.5 --max_var_genes 5000 --plot_intermediate
```

## Parameters
Below is a list of parameters that can be passed to the script, along with their descriptions and default values:

| Parameter             | Description                                                                 | Default Value       |
|-----------------------|-----------------------------------------------------------------------------|---------------------|
| `-i, --input`         | Path to the input tar.gz file containing spatial transcriptomics data       | `NULL`              |
| `-o, --output`        | Directory to save the processed data and plots                              | `output`            |
| `--method`            | Transformation method: 'log' for log-normalization or 'sct' for SCTransform | `log`               |
| `--scale_f`           | Scaling factor for log transformation                                       | `10000`             |
| `--sct_n_regr_genes`  | Number of genes to use in the regression model during SCTransform           | `3000`              |
| `--sct_min_cells`     | Minimum number of spots/cells to use in the regression model fit by SCTransform | `5`             |
| `--cores`             | Number of cores to use during parallelization                               | `NULL` (half of available cores) |
| `--spot_minreads`     | Minimum number of total reads for a spot to be retained                     | `0`                 |
| `--spot_maxreads`     | Maximum number of total reads for a spot to be retained                     | `NULL`              |
| `--spot_mingenes`     | Minimum number of non-zero counts for a spot to be retained                 | `0`                 |
| `--spot_maxgenes`     | Maximum number of non-zero counts for a spot to be retained                 | `NULL`              |
| `--spot_minpct`       | Minimum percentage of counts for features defined by 'spot_pct_expr' for a spot to be retained | `0` |
| `--spot_maxpct`       | Maximum percentage of counts for features defined by 'spot_pct_expr' for a spot to be retained | `NULL` |
| `--gene_minreads`     | Minimum number of total reads for a gene to be retained                     | `0`                 |
| `--gene_maxreads`     | Maximum number of total reads for a gene to be retained                     | `NULL`              |
| `--gene_minspots`     | Minimum number of spots with non-zero counts for a gene to be retained      | `0`                 |
| `--gene_maxspots`     | Maximum number of spots with non-zero counts for a gene to be retained      | `NULL`              |
| `--gene_minpct`       | Minimum percentage of spots with non-zero counts for a gene to be retained  | `0`                 |
| `--gene_maxpct`       | Maximum percentage of spots with non-zero counts for a gene to be retained  | `NULL`              |
| `--max_var_genes`     | Number of most variable genes to use in pseudobulk analysis                 | `5000`              |
| `--plot_intermediate` | Plot intermediate results                                                   | `FALSE`             |

## Example
To run the script with specific parameters, use the following command:




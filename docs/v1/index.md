# GenePattern Module: spatialGE.Preprocessing

## Description
The `spatialGE.Preprocessing` module is part of the spatialGE package, designed for preprocessing and initial data preparation of spatially-resolved transcriptomic data. It performs data ingestion, filtering, transformation, and pseudobulk operations to prepare data for downstream analysis in platforms such as GeoMx, Visium, and CosMx-SMI. Covers the steps up to transform_data in the [spatialGE Basic functions vignette](https://fridleylab.github.io/spatialGE/articles/basic_functions_vignette.html).

## Module Details

- **Authors:** Edwin Huang, Ted Liefeld, Thorin Tabor, Michael Reich; UCSD - Mesirov Lab
- **Categories:** spatial transcriptomics
- **Source repository:** [spatialGE.Preprocessing on GitHub](https://github.com/genepattern/spatialGE.Preprocessing)
- **Contact**: [GenePattern Help Forum](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!forum/genepattern-help)

## Input Files

- **Input Data Archive:**
  - Input data archive in gz format. Should match the directory structure as defined by spatialGE. 

- **Input Clinical Data:**
  - Metadata associated with each sample in a csv file. The sample names must match the names of the folders containing the data.

## Output Files

- **Output Files:**
  - RDS file containing the filtered/transformed STList object for further processing. Also outputs various images including distribution plots before and after filtering, and pseudobulk PCA plot and heatmap.  

## Parameters

### Inputs and Outputs

| Name                  | Description                                                                 | Default Value                    | Type      |
|-----------------------|-----------------------------------------------------------------------------|----------------------------------|-----------|
| `input data archive`  | Input data archive in gz format. Should match the directory structure as defined by spatialGE. |                                  | File      |
| `input clinical data` | Metadata associated with each sample in a csv file. The sample names must match the names of the folders containing the data. |                                  | File      |
| `output filename`     | The basename to use for the output file.                                     | <input data archive_basename>.Rdata | String    |

### Filtering Parameters

| Name            | Description                                                                 | Default Value | Type      |
|-----------------|-----------------------------------------------------------------------------|---------------|-----------|
| `filter data`   | Perform data filtering.                                                     |  True         | String    |

#### Spot Filtering

| Name                    | Description                                                                 | Default Value | Type      |
|-------------------------|-----------------------------------------------------------------------------|---------------|-----------|
| `spot min reads`        | The minimum number of total reads for a spot to be retained.                  | 5000          | Integer   |
| `spot max reads`        | The maximum number of total reads for a spot to be retained.                  | 15000         | Integer   |
| `spot min genes`        | The minimum number of non-zero counts for a spot to be retained.              | 1000          | Integer   |
| `spot max genes`        | The maximum number of non-zero counts for a spot to be retained.              | 1000          | Integer   |
| `spot min percent`      | The minimum percentage of counts for features defined by spot_pct_expr for a spot to be retained. | 0             | Integer   |
| `spot max percent`      | The maximum percentage of counts for features defined by spot_pct_expr for a spot to be retained. |               | Integer   |

#### Gene Filtering

| Name                    | Description                                                                 | Default Value | Type      |
|-------------------------|-----------------------------------------------------------------------------|---------------|-----------|
| `gene min reads`        | The minimum number of total reads for a gene to be retained.                  | 0             | Integer   |
| `gene max reads`        | The maximum number of total reads for a gene to be retained.                  |               | Integer   |
| `gene min spots`        | The minimum number of spots with non-zero counts for a gene to be retained.   | 0             | Integer   |
| `gene max spots`        | The maximum number of spots with non-zero counts for a gene to be retained.   |               | Integer   |
| `gene min percent`      | The minimum percentage of spots with non-zero counts for a gene to be retained. | 0             | Integer   |
| `gene max percent`      | The maximum percentage of spots with non-zero counts for a gene to be retained. |               | Integer   |

#### Other Filtering

| Name                       | Description                                                                 | Default Value | Type      |
|----------------------------|-----------------------------------------------------------------------------|---------------|-----------|
| `filter samples`           | Samples (as in names(x@counts)) to perform filtering.                        |               | String    |
| `rm tissue`                | Sample (as in names(x@counts)) to remove from STlist.                         |               | String    |
| `rm spots`                 | Vector of spot/cell IDs to remove.                                           |               | String    |
| `rm genes`                 | Vector of gene names to remove from STlist.                                   |               | String    |
| `rm genes regex`           | A regular expression that matches genes to remove.                            |               | String    |
| `spot percentage genes regex` | An expression to use with spot_minpct and spot_maxpct. By default '^MT-'.     |               | Integer   |

### Pseudobulk Parameters

| Name                              | Description                                                                 | Default Value | Type      |
|-----------------------------------|-----------------------------------------------------------------------------|---------------|-----------|
| `pseudobulk`                      | Perform pseudobulk analysis (combining counts from each sample) and perform PCA. | False         | String    |
| `pseudobulk max var genes`        | The number of most variable genes (standard deviation) to use in pseudobulk analysis. | 5000          | Integer   |
| `pseudobulk plot meta`            | Name of the variable in the sample metadata to color points in the PCA plot. | patient_id        | String    |
| `pseudobulk heatmap num displayed genes` | The number of genes to display in the pseudobulk heatmap.                    | 30            | Integer   |

### Transform Parameters

| Name                              | Description                                                                 | Default Value | Type      |
|-----------------------------------|-----------------------------------------------------------------------------|---------------|-----------|
| `transform data`                  | Type of data transformation to apply (`None`, `Log`, `SCT`).                 | Log          | String    |
| `transform scale f`               | The scale factor used in logarithmic transformation.                         | 10000         | Integer   |
| `transform num regression genes`  | The number of genes to be used in the regression model during SCTransform.    | 5000          | Integer   |
| `transform min spots or cells`    | The minimum number of spots or cells to be used in the regression model fit by SCTransform. | 5             | Integer   |

### Other Parameters

| Name                              | Description                                                                 | Default Value | Type      |
|-----------------------------------|-----------------------------------------------------------------------------|---------------|-----------|
| `verbose`          | Output additional files including summarized STList, distribution_plots before and after filtering, and pseudobulk PCA plot and heatmap.                | -             | Integer   |
| `distribution plot meta`          | Vector of variables in sample metadata to plot distributions.                 | -             | Integer   |



## Example Data

[Example data on GitHub](https://github.com/genepattern/spatialGE.Preprocessing/tree/main/data)

## License
spatialGE.Preprocessing is distributed under a modified BSD license available at [[https://github.com/genepattern/ExampleModule/blob/v2/LICENSE](https://github.com/genepattern/spatialGE.Preprocessing/blob/main/LICENSE)](https://github.com/genepattern/spatialGE.Preprocessing/blob/main/LICENSE).

| Version | Release Date | Description                                 |
----------|--------------|---------------------------------------------|
| 1.1 | August 6, 2024 | Formatting updates. |
| 1 | July 2, 2024 | Initial version for team use. |

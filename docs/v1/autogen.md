# GenePattern Module: spatialGE.Preprocessing

## Overview
The `spatialGE.Preprocessing` module is part of the spatialGE package, designed for preprocessing and initial data preparation of spatially-resolved transcriptomic data. It performs data ingestion, filtering, transformation, and pseudobulk operations to prepare data for downstream analysis in platforms such as GeoMx, Visium, and CosMx-SMI.

## Module Details

- **Module Name:** spatialGE.Preprocessing
- **Version:** 0.4
- **Authors:** Edwin Huang, Ted Liefeld, Thorin Tabor, Michael Reich; UCSD - Mesirov Lab
- **Categories:** spatial transcriptomics
- **Documentation:** [spatialGE.Preprocessing Documentation](https://genepattern.github.io/spatialGE.Preprocessing/v0.4/)

## Description
The `spatialGE.Preprocessing` module prepares spatial transcriptomic data by ingesting, filtering, transforming, and performing pseudobulk operations. It supports various preprocessing tasks required for spatially-resolved transcriptomic experiments.

## Input Parameters

1. **Input Data Archive:**
   - Type: `File`
   - Description: Input data archive in gz format. Should match the directory structure as defined by spatialGE.
   - Parameter Name: `input.data.archive`

2. **Input Clinical Data:**
   - Type: `File`
   - Description: Metadata associated with each sample in a csv file. The sample names must match the names of the folders containing the data.
   - Parameter Name: `input.clinical.data`

3. **Verbose Output:**
   - Type: `String`
   - Description: Output additional files including summarized STList, distribution plots before and after filtering, and pseudobulk PCA plot and heatmap.
   - Parameter Name: `verbose`

4. **Transform Data:**
   - Type: `String`
   - Description: Type of data transformation to apply (`None`, `Log`, `SCT`).
   - Parameter Name: `transform.data`

5. **Output Filename:**
   - Type: `String`
   - Description: The basename to use for the output file.
   - Parameter Name: `output.filename`

6. **Perform Pseudobulk:**
   - Type: `String`
   - Description: Perform pseudobulk analysis (combining counts from each sample) and perform PCA.
   - Parameter Name: `pseudobulk`

7. **Max Variable Genes in Pseudobulk:**
   - Type: `Integer`
   - Description: The number of most variable genes (standard deviation) to use in pseudobulk analysis.
   - Parameter Name: `pseudobulk.max.var.genes`

8. **Pseudobulk Plot Metadata:**
   - Type: `String`
   - Description: Name of the variable in the sample metadata to color points in the PCA plot.
   - Parameter Name: `pseudobulk.plot.meta`

9. **Number of Genes in Pseudobulk Heatmap:**
   - Type: `Integer`
   - Description: The number of genes to display in the pseudobulk heatmap.
   - Parameter Name: `pseudobulk.heatmap.num.displayed.genes`

10. **Distribution Plot Metadata:**
    - Type: `Integer`
    - Description: Vector of variables in sample metadata to plot distributions.
    - Parameter Name: `distribution.plot.meta`

11. **Minimum Reads per Spot (Filtering):**
    - Type: `Integer`
    - Description: The minimum number of total reads for a spot to be retained.
    - Parameter Name: `spot.min.reads`

12. **Minimum Genes per Spot (Filtering):**
    - Type: `Integer`
    - Description: The minimum number of non-zero counts for a spot to be retained.
    - Parameter Name: `spot.min.genes`

13. **Maximum Reads per Spot (Filtering):**
    - Type: `Integer`
    - Description: The maximum number of total reads for a spot to be retained.
    - Parameter Name: `spot.max.reads`

14. **Maximum Genes per Spot (Filtering):**
    - Type: `Integer`
    - Description: The maximum number of non-zero counts for a spot to be retained.
    - Parameter Name: `spot.max.genes`

15. **Logarithmic Transformation Scale Factor:**
    - Type: `Integer`
    - Description: The scale factor used in logarithmic transformation.
    - Parameter Name: `transform.scale.f`

16. **Number of Regression Genes for SCTransform:**
    - Type: `Integer`
    - Description: The number of genes to be used in the regression model during SCTransform.
    - Parameter Name: `transform.num.regression.genes`

17. **Minimum Spots or Cells for SCTransform:**
    - Type: `Integer`
    - Description: The minimum number of spots or cells to be used in the regression model fit by SCTransform.
    - Parameter Name: `transform.min.spots.or.cells`

18. **Minimum Percentage of Counts per Spot (Filtering):**
    - Type: `Integer`
    - Description: The minimum percentage of counts for features defined by spot_pct_expr for a spot to be retained.
    - Parameter Name: `spot.min.percent`

19. **Maximum Percentage of Counts per Spot (Filtering):**
    - Type: `Integer`
    - Description: The maximum percentage of counts for features defined by spot_pct_expr for a spot to be retained.
    - Parameter Name: `spot.max.percent`

20. **Minimum Reads per Gene (Filtering):**
    - Type: `Integer`
    - Description: The minimum number of total reads for a gene to be retained.
    - Parameter Name: `gene.min.reads`

21. **Maximum Reads per Gene (Filtering):**
    - Type: `Integer`
    - Description: The maximum number of total reads for a gene to be retained.
    - Parameter Name: `gene.max.reads`

22. **Minimum Spots per Gene (Filtering):**
    - Type: `Integer`
    - Description: The minimum number of spots with non-zero counts for a gene to be retained.
    - Parameter Name: `gene.min.spots`

23. **Maximum Spots per Gene (Filtering):**
    - Type: `Integer`
    - Description: The maximum number of spots with non-zero counts for a gene to be retained.
    - Parameter Name: `gene.max.spots`

24. **Minimum Percentage of Spots per Gene (Filtering):**
    - Type: `Integer`
    - Description: The minimum percentage of spots with non-zero counts for a gene to be retained.
    - Parameter Name: `gene.min.percent`

25. **Maximum Percentage of Spots per Gene (Filtering):**
    - Type: `Integer`
    - Description: The maximum percentage of spots with non-zero counts for a gene to be retained.
    - Parameter Name: `gene.max.percent`

26. **Samples for Filtering:**
    - Type: `String`
    - Description: Samples (as in names(x@counts)) to perform filtering.
    - Parameter Name: `filter.samples`

27. **Remove Tissue:**
    - Type: `String`
    - Description: Sample (as in names(x@counts)) to remove from STlist.
    - Parameter Name: `rm.tissue`

28. **Remove Spots or Cells:**
    - Type: `String`
    - Description: Vector of spot/cell IDs to remove.
    - Parameter Name: `rm.spots`

29. **Remove Genes:**
    - Type: `String`
    - Description: Vector of gene names to remove from STlist.
    - Parameter Name: `rm.genes`

30. **Remove Genes by Regex:**
    - Type: `String`
    - Description: A regular expression that matches genes to remove.
    - Parameter Name: `rm.genes.regex`

31. **Spot Percentage Genes Regex:**
    - Type: `Integer`
    - Description: An expression to use with spot_minpct and spot_maxpct. By default '^MT-'.
    - Parameter Name: `spot.percentage.genes.regex`

## Usage

1. **Upload Input Data:** Upload your spatial transcriptomic data archive (`gz` format) and clinical metadata.
   
2. **Set Parameters:** Configure the module parameters according to your preprocessing requirements, including data transformation options and filtering criteria.

3. **Run the Module:** Click "Run" to execute the preprocessing pipeline.

4. **Review Output:** Examine the output files and results generated by the module for further analysis.

## Notes

- This module is suitable for preprocessing spatially-resolved transcriptomic data from platforms such as GeoMx, Visium, and CosMx-SMI.
- Ensure that input data archives follow the directory structure defined by spatialGE for proper ingestion.

For detailed examples and additional documentation, visit the [spatialGE.Preprocessing Documentation](https://genepattern.github.io/spatialGE.Preprocessing/v0.4/).

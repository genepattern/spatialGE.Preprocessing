FROM r-base:4.3.2


#Install Moffitt's CA certificates
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get clean all && \
    apt-get install -y --no-install-recommends \
        ca-certificates locales wget libcurl4-openssl-dev libxml2-dev libssl-dev && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* 

#    wget --no-check-certificate -O /usr/local/share/ca-certificates/moffitt-ca.crt \
#      "https://gitlab.moffitt.usf.edu:8000/singularity/mcc-certificates/-/raw/main/certs/moffitt-ca.cer" && \
#    wget --no-check-certificate -O /usr/local/share/ca-certificates/moffitt-ca-int.crt \
#      "https://gitlab.moffitt.usf.edu:8000/singularity/mcc-certificates/-/raw/main/certs/moffitt-ca-int.cer" && \
#    wget --no-check-certificate -O /usr/local/share/ca-certificates/moffitt-chain \
#      "https://gitlab.moffitt.usf.edu:8000/singularity/mcc-certificates/-/raw/main/certs/moffitt-chain" && \
#    chmod 644 /usr/local/share/ca-certificates/*moffitt* && \
#    update-ca-certificates --verbose && \
#        echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen en_US.utf8 && update-locale LANG=en_US.UTF-8



#Install required system libraries
RUN apt-get -y update && apt-get -y install libhdf5-dev libudunits2-dev libv8-dev libgdal-dev cmake libfftw3-dev libfontconfig1-dev libcurl4-openssl-dev libglpk-dev libgsl-dev libmagick++-dev

RUN mkdir /spatialGE
WORKDIR /spatialGE

#Install libraries required by spatialGE
RUN Rscript -e "install.packages('systemfonts', dependencies = TRUE)"
RUN Rscript -e "install.packages('ggforce')"
RUN Rscript -e "install.packages('ggpubr')"
RUN Rscript -e "install.packages('BiocManager')"
RUN Rscript -e "BiocManager::install('EBImage', update = TRUE, ask = FALSE)"
RUN Rscript -e "BiocManager::install('ComplexHeatmap', update = TRUE, ask = FALSE)"
RUN Rscript -e "install.packages('rgeos')"
RUN Rscript -e "install.packages('hdf5r')"
RUN Rscript -e "install.packages('remotes')"

#Install support libraries ro work with Excel files and images
RUN Rscript -e "install.packages('openxlsx')"
RUN Rscript -e "install.packages('svglite')"
RUN Rscript -e "install.packages('rdist')"
RUN Rscript -e "install.packages('magick')"

RUN Rscript -e "remotes::install_github('JEFworks-Lab/STdeconvolve')"

RUN Rscript -e "install.packages('ggtext')"

#Required for Phenotyping-CosMx
RUN Rscript -e "BiocManager::install('SpatialDecon', update = TRUE, ask = FALSE)"
#Required for InSituType
RUN Rscript -e "BiocManager::install('sparseMatrixStats', update = TRUE, ask = FALSE)"
RUN Rscript -e "BiocManager::install('SummarizedExperiment', update = TRUE, ask = FALSE)"
RUN Rscript -e "BiocManager::install('SingleCellExperiment', update = TRUE, ask = FALSE)"
RUN Rscript -e "install.packages('lsa')"
#Required for Phenotyping-CosMx
RUN Rscript -e "remotes::install_github('Nanostring-Biostats/InSituType')"

RUN Rscript -e "install.packages('uwot')"

#Install spatialGE library
RUN Rscript -e "remotes::install_github('FridleyLab/spatialGE')  "






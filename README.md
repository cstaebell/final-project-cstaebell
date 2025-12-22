# Nighttime Lights and the Dark Sky Movement in the US

With growing awareness of light pollution and the need to conserve dark night skies for scientific, ecological, and aesthetic reasons, an increasing number of communities are adopting measures to decrease their emissions of artificial light at night. This project aims to explore trends in nighttime light levels first from a national contiguous US perspective, and also through more detailed case studies of individual cities. 

This repository hosts all data and files needed to produce this spatial data science project as a Quarto website.

## Data

Data was sourced from the US Census Bureau and NASA's Black Marble via API. MODIS data was downloaded via AppEEARS. All raw data is available from the GitHub release associated with this repository. The "data" folder contains a processed raster file for use in creating a Leaflet map.

## Files

### index.qmd

This is the main page of the website containing all analysis and discussion.

### black_marble_data_download.R

This script downloads Black Marble rasters and statistics. It uploads this data, along with MODIS data sourced from AppEEARS, to GitHub as release assets.

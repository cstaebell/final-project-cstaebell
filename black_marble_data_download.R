###------------------------------------------------------

# This script downloads and saves NASA black marble data
# at US national and state levels.

# Note: it seems unnecessary to write separate files for single
#  CONUS mean values. However, connection issues and problems accessing data
#  through black marbler API calls made writing files more reliable.
###------------------------------------------------------

library(tidyverse)
library(blackmarbler)
library(sf)
library(tigris)
library(terra)
library(piggyback)

# Define region of interest
nonconus <- c("Guam", "Hawaii", "Alaska",
              "Commonwealth of the Northern Mariana Islands",
              "United States Virgin Islands", "American Samoa", "Puerto Rico")

states_sf <- states() |>
  filter(!NAME %in% nonconus) |>
  select(NAME, geometry) |>
  st_transform(crs = "epsg:4326") # EPSG:4326 for compatibility with black marble

# Dissolve state boundaries to get national means
conus <- st_union(states_sf)|>
  st_as_sf()

# Download and save values for contiguous US (more accurate than calculating from states)
bm_extract(roi_sf = conus,
           product_id = "VNP46A4",
           date = 2014:2024,
           bearer = nasa_bearer_token,
           output_location_type = "file",
           file_dir = paste(getwd(), "/data-local", sep = ""),
           file_prefix = "CONUS_",
           file_return_null = TRUE)

# Download and save state values
bm_extract(roi_sf = states_sf,
           product_id = "VNP46A4",
           date = 2014:2024,
           bearer = nasa_bearer_token,
           output_location_type = "file",
           file_dir = paste(getwd(), "/data-local", sep = ""),
           file_prefix = "US_",
           file_return_null = TRUE)

years = 2014:2024

# Get rasters for states
for (year in years){
  bm_raster(roi_sf = states_sf,
            product_id = "VNP46A4",
            date = year,
            bearer = nasa_bearer_token,
            output_location_type = "file",
            file_dir = paste(getwd(), "/data-local", sep = ""),
            file_prefix = "US_",
            file_return_null = TRUE)
}

# Upload data to GitHub Releases
for (year in years){
  piggyback::pb_upload(paste("data-local/CONUS_VNP46A4_NearNadir_Composite_Snow_Free_qflag_mean_t",
                             year, ".Rds", sep = ""),
                       repo = "cstaebell/final-project-cstaebell",
                       tag = "v0")

  piggyback::pb_upload(paste("data-local/US_VNP46A4_NearNadir_Composite_Snow_Free_qflag_mean_t",
                             year, ".Rds", sep = ""),
                       repo = "cstaebell/final-project-cstaebell",
                       tag = "v0")

  piggyback::pb_upload(paste("data-local/US_VNP46A4_NearNadir_Composite_Snow_Free_qflag_t",
                             year, ".tif", sep = ""),
                       repo = "cstaebell/final-project-cstaebell",
                       tag = "v0")
}

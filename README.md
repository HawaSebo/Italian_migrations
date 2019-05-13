# Italian internal migrations visualisation


This repo hosts the simple gganimate plot of Italian internal migration I patched together from ISTAT data.

Data source: http://seriestoriche.istat.it/fileadmin/documenti/Tavola_2.12.xls

Shapefile data source: ISTAT

The original data have been modified in order to be easily imported. The modified version is in the `saldi_migratori.csv` file. 


The code depends on `tidyverse`, `haven`, `gganimate` and `scales`.


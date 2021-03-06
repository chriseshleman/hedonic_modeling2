### Using shapefiles and geodatabase tables. 

rm(list = ls()) # clear global environment 
cat("\014") # clear the console 
dev.off() 

library(maptools)
library(rgdal) 
library(rgeos)
library(sf) 


### Set working drive 
setwd("/Users/chriseshleman/Dropbox/Work and research/Airport noise pollution/data and models/hedonic") 
list.files("./hedonic_modeling/HR&A Advisors") 

### These are geodatabase files. 
ogrListLayers("./hedonic_modeling/HR&A_Advisors.gdb") 

### FIRST ATTEMPT 
# From Lauren O'Brien via http://r-sig-geo.2731867.n2.nabble.com/Reading-tables-without-geometry-from-gdb-td7591820.html

# somewhere to dump outputs 
dir.create(file.path(getwd(), './hedonic_modeling/HR&A_tables')) 

# whats in the gdb? 
gdb_contents = st_layers(dsn = file.path(getwd(), './hedonic_modeling/HR&A_Advisors.gdb'), 
                         do_count = TRUE) 
gdb_contents 
# I'm guessing the 'Parcel_Areis' and 'Parcel_Poly' are the two layers (tables?) I'll want. 
# But I'm guessing. 

# this is easier to read than the list above: 
gdb_neat_deets = data.frame('Name' = gdb_contents[['name']], 
                            'Geomtype' = unlist(gdb_contents[['geomtype']]), 
                            'features' = gdb_contents[['features']], 
                            'fields' = gdb_contents[['fields']]) 

# so the non-spatial tables have geometry == NA, lets get their names 
properties_nonspatial = 
  as.list(gdb_neat_deets[is.na(gdb_neat_deets$Geomtype), 'Name']) 

# names attrib is useful here 
names(properties_nonspatial) = 
  gdb_neat_deets[is.na(gdb_neat_deets$Geomtype), 'Name'] 
getwd() # 

### Switching to this. https://gis.stackexchange.com/questions/184013/read-a-table-from-an-esri-file-geodatabase-gdb-using-r/184028
gdb_contents 
getwd() 
parcel = sf::st_read(dsn = "./hedonic_modeling/HR&A_Advisors.gdb", layer = "Parcel_Areis")
head(parcel, 10) 
table(parcel$TOWN) 
write.csv(parcel, "./hedonic_modeling/ce_tables/parcel_areis.csv")
ppoly = sf::st_read(dsn = "./hedonic_modeling/HR&A_Advisors.gdb", layer = "Parcel_Poly")
write.csv(ppoly, "./hedonic_modeling/ce_tables/parcel_poly.csv")
street = sf::st_read(dsn = "./hedonic_modeling/HR&A_Advisors.gdb", layer = "Street") 
write.csv(street, "./hedonic_modeling/ce_tables/street.csv") 
condo = sf::st_read(dsn = "./hedonic_modeling/HR&A_Advisors.gdb", layer = "Condo_Areis") 
write.csv(condo, "./hedonic_modeling/ce_tables/condo_areis.csv")
condop = sf::st_read(dsn = "./hedonic_modeling/HR&A_Advisors.gdb", layer = "Condo_Poly") 
write.csv(condop, "./hedonic_modeling/ce_tables/condo_poly.csv") 
head(condop) 


### 
# From https://github.com/USEPA/intro_gis_with_r/blob/master/lessons/02_read_in_gis_data.md
ogrListLayers("./hedonic_modeling/HR&A_Advisors.gdb")
examp_fgdb = readOGR(dsn = "./hedonic_modeling/HR&A_Advisors.gdb", layer = "Parcel_Areis")
summary(examp_fgdb)
plot(examp_fgdb) 

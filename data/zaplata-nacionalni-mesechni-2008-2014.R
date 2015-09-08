rm(list=ls())

library(readxl)

excel_sheets("Labour_1.1.2.1.xls")

files2008 <- list()

# Load file

for (i in 9:15) {
  files2008[[i-8]] <- read_excel("Labour_1.1.2.1.xls", sheet = i)
}

# Give column names to each data frame

files2008 <- lapply(files2008, function(x) setNames(x, c("sektori", 1:12)))

lapply(files2008, nrow)

# Trim white space from first column in each data frame

library(stringi)

files2008 <- lapply(files2008, function(x) transform(x, sektori = stri_trim_both(x[["sektori"]])))

# Get sector names

sectornames2008bg <- files2008[[1]][["sektori"]][5:24]
sectornames2008bg

# For 2014 there is some difference in the names, so we do

files2008[[7]][["sektori"]][6:25] <- sectornames2008bg

files2008 <- lapply(files2008, function(x) subset(x, x[["sektori"]] %in% sectornames2008bg))

lapply(files2008, nrow)

# Remove quarterly data

files2008 <- lapply(files2008, function(x) x[!is.na(files2008[[1]][[10]]), ])

# Give names in latin to the sectors

sectornames2008en <- c("obshto", "selsko", "dobiwna", "prerabotwashta",
                       "energiq", "woda", "stroitelstwo", "tyrgowiq",
                       "transport", "hoteli", "informaciq", "finansi", 
                       "imoti", "nauka", "administratiwni", 
                       "dyrvawnouprawlenie", "obrazowanie", "zdraweopazwane",
                       "kultura", "drugi")

names2008 <- vector("list", 20) # Create a list of 20 items
names2008 <- as.list(sectornames2008en) # Fill it in with items
names(names2008) <- sectornames2008bg # Give names to the items
names2008      

# Give latin names to the sectors

files2008 <- lapply(files2008, transform, sektori = sectornames2008en)

View(files2008)

# Convert from wide to long format

library(tidyr)

files2008long <- lapply(files2008, gather, month, zaplata, 2:13)

lapply(files2008long, nrow)

all2008 <- do.call("rbind", files2008long)

head(all2008)

# Now we need to add the "year" variable.
# For this we need to put names to the list of data frames

names(files2003long)
files2008long <- setNames(files2008long, c(2008:2014))

# Now use the following function to fill in "year" from the names
# of "files2003long"

all2008$year <- rep(names(files2008long), sapply(files2008long, nrow))

head(all2008)
str(all2008)

all2008$month <- gsub("X", "", all2008$month)
all2008$month <- as.numeric(all2008$month)
all2008$year <- as.numeric(all2008$year)
all2008$zaplata <- as.numeric(all2008$zaplata)

all2008 <- all2008[ ,c(1,3,4,2)]

write.table(all2008, "zaplata-nacionalni-mesechni-2008-2014.csv", 
            sep = ",", row.names = FALSE, quote = FALSE)
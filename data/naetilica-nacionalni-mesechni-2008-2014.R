rm(list=ls())

library(readxl)

# Create an empty list

files2008 <- list()

# Fill the list with objects (as data frames) from the excel
# file sheets 9:14, which correspond to years 2008-2014

# Get a list of the sheets in the excel file

excel_sheets("Labour_1.1.1.1.xls")

for (i in 9:15) {
files2008[[i-8]] <- read_excel("Labour_1.1.1.1.xls", sheet = i)
assign("files2008", files2008)
}

# Give names to the objects in the list

names(files2008) <- paste0(rep("year", 7), 2008:2014)
names(files2008)
View(files2008[[1]])

# Give names to the columns in each data frames of the list

for (i in 1:length(files2008)) {
  colnames(files2008[[i]]) <- c("sektori", 1:12)
  assign("files2008", files2008)
}

# Create a vector with the names of the sectors in Bulgarian

sectornames2008bg <- files2008$year2008$sektori[5:24]

# We can use it to subset all the data frames in the list
# just with the data for the employed

files2008subset <- list()
for (i in 1:length(files2008)) {
  files2008subset[[i]] <- subset(files2008[[i]], sektori %in% sectornames2008bg)
  assign("files2008subset", files2008subset)
}
names(files2008subset) <- names(files2008)
names(files2008subset)

# Alternatively we can use lapply and square brackets, as "["
# is a function

# files2008sub <- lapply(files2008, "[", 5:24, )

# But in this case it selects based on row numbers and row
# numbers are off by one row. So we will use subsetting with
# the named vector.

# Give sectors short names in the latin alphabet

sectornames2008bg
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
length(names2008)

# Alternatively we can do:
# names2008 <- as.list(setNames(sectornames2008en, sectornames2008bg))

# replace the names in the dataframes

for (i in 1:length(files2008subset)) {
  files2008subset[[i]][["sektori"]] <- sectornames2008en
}

# We get an error. There is a data frame with more rows.

lapply(files2008subset, function(x) print(nrow(x)))

# It is the last one. Let's see what is the problem

View(files2008subset[[7]])

# "Общо" is present on both the first and the second row.

files2008subset[[7]] <- files2008subset[[7]][-1, ]
nrow(files2008subset[[7]])

# Now try again with the name replacement

for (i in 1:length(files2008subset)) {
  files2008subset[[i]][["sektori"]] <- sectornames2008en
}

# Convert from wide to long format

library(tidyr)

files2008long <- lapply(files2008subset, gather, month, naeti, 2:13)

View(files2008long[[7]])

# Add new variable "year", using the names of the list

for (i in 1:length(files2008long)) {
  files2008long[[i]][["year"]] <- rep(names(files2008long)[i], nrow(files2008long[[i]]))
  assign("files2008long", files2008long, envir = .GlobalEnv)
}

# Alternatively we can do so after rbind
# all2008$yearnew <- rep(names(files2008long), sapply(files2008long, nrow))

files2008long[[1]]

# If we want to remove the variable
# lapply(files2008long, function(x) x[ ,-4])

all2008 <- do.call("rbind", files2008long)
str(all2008)
all2008$naeti <- as.numeric(all2008$naeti)
all2008$year <- gsub("year", "", all2008$year)
all2008 <- all2008[ ,c(1,3,4,2)]
write.table(all2008, "naetilica-nacionalni-mesechni-2008-2014.csv", 
            quote = FALSE, sep = ",", row.names = FALSE)

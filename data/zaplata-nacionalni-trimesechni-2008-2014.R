rm(list=ls())

library(readxl)

excel_sheets("Labour_1.1.2.1.xls")

files2008 <- list()
for (i in 9:15) {
  files2008[[i-8]] <- read_excel("Labour_1.1.2.1.xls", sheet = i, skip = 35)
}

names(files2008) <- 2008:2014

# Remove unnecessary columns

files2008 <- lapply(files2008, "[", ,1:5)

# Give latin names to the variables

files2008 <- lapply(files2008, setNames, c("sektori", 1:4))

# Find at which row is "Общо" in "sektori" of each data frame,
# add 19 (the number of sectors) and subset

files2008 <- lapply(files2008, function(x) {
  nachalo <- as.numeric(which(x[["sektori"]] == "Общо"))
  kraj <- as.numeric(which(x[["sektori"]] == "Общо")) + 19
  x[nachalo:kraj, ]
})


sectornames2008bg <- files2008[[1]][["sektori"]]
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

files2008 <- lapply(files2008, transform, sektori = sectornames2008en)


# Convert to long data format

library(tidyr)

files2008long <- lapply(files2008, gather, trimesechie, zaplata, 2:5)

View(files2008[[5]])

zaplati_all <- do.call("rbind", files2008long)

# Add year based on the names of the data frames in the list

head(zaplati_all)

zaplati_all$year <- as.numeric(rep(names(files2008long), sapply(files2008long, nrow)))
zaplati_all$trimesechie <- as.numeric(gsub("X", "", zaplati_all$trimesechie))
zaplati_all$zaplata <- as.numeric(zaplati_all$zaplata)

write.table(zaplati_all, "zaplata-nacionalni-trimesechni-2008-2014.csv",
            sep = ",", quote = FALSE, row.names = FALSE)
rm(list=ls())

library(readxl)

excel_sheets("Labour_1.1.2.1.xls")

files2003 <- list()
for (i in 1:8) {
  files2003[[i]] <- read_excel("Labour_1.1.2.1.xls", sheet = i, skip = 30)
}

# Get only the the columns we need

files2003 <- lapply(files2003, "[", ,1:5)

# Set column names

files2003 <- lapply(files2003, setNames, c("sektori", 1:4))

# Get sector names

sectornames2003bg <- c(files2003[[1]][2:16,1])
sectornames2003bg
sectornames2003en <- c("obshto", "selsko", "dobiwna", "prerabodwashta",
                       "energiq i woda", "stroitelstwo", "tyrgowiq", 
                       "hoteli", "transport", "finansi", "imoti", 
                       "dyrvawnouprawlenie", "obrazowanie", 
                       "zdraweopazwane", "drugi")

# We can subset using numbers, the rows look aligned

files2003 <- lapply(files2003, "[", 2:16, )

# Give names in latin to "sektori"

files2003 <- lapply(files2003, transform, sektori = sectornames2003en)

# Convert data to long format

library(tidyr)

files2003long <- lapply(files2003, gather, trimesechie, zaplata, 2:5)
head(files2003long)

# Add year to the long format data

names(files2003long) <- 2000:2007

zaplati_all <- do.call("rbind", files2003long)
zaplati_all$year <- rep(names(files2003long), sapply(files2003long, nrow))
head(zaplati_all)
zaplati_all$trimesechie <- as.numeric(gsub("X", "", zaplati_all$trimesechie))
zaplati_all$zaplata <- as.numeric(zaplati_all$zaplata)
zaplati_all$year <-as.numeric(zaplati_all$year)

zaplati_all <- zaplati_all[ ,c(1,3,4,2)]
head(zaplati_all)

write.table(zaplati_all, "zaplata-nacionalni-trimesechni-2000-2007.csv",
            sep = ",", row.names = FALSE, quote = FALSE)
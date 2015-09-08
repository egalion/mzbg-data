rm(list=ls())

library(readxl)

excel_sheets("Labour_1.1.2.1.xls")

files_zaplata <- list()

for (i in 1:15) {
  files_zaplata[[i]] <- read_excel("Labour_1.1.2.1.xls", sheet = i)
}

View(files_zaplata[[1]])

# Set column names

files_zaplata <- lapply(files_zaplata, setNames, c("sektori", 1:12))
lapply(files_zaplata, colnames)

# Get only the rows, containing "сектор"

files_zaplata <- lapply(files_zaplata, function(x) x[grepl("сектор", x[["sektori"]]), ])

lapply(files_zaplata, nrow)

files_zaplata[[1]]

# Give names in latin to "sektori"

files_zaplata <- lapply(files_zaplata, transform, 
                        sektori = c("obshtestwen", "chasten", "obshtestwen", "chasten"))

# Get rid of monthly data and unnecessary columns

files_zaplata <- lapply(files_zaplata, "[", 3:4, 1:5)

names(files_zaplata) <- 2000:2014

View(files_zaplata[[1]])

# Convert data to long format

library(tidyr)

files_zaplata_long <- lapply(files_zaplata, gather, trimesechie, zaplata, 2:5)

zaplata_all_o_c <- do.call("rbind", files_zaplata_long)

zaplata_all_o_c$year <- rep(names(files_zaplata_long), sapply(files_zaplata_long, nrow))

zaplata_all_o_c$zaplata <- as.numeric(zaplata_all_o_c$zaplata)
zaplata_all_o_c$year <- as.numeric(zaplata_all_o_c$year)
zaplata_all_o_c$trimesechie <- as.numeric(gsub("X", "", zaplata_all_o_c$trimesechie))

head(zaplata_all_o_c)

obshtestwen_only <- subset(zaplata_all_o_c, sektori == "obshtestwen")
chasten_only <- subset(zaplata_all_o_c, sektori == "chasten")

do2007 <- read.csv("zaplata-nacionalni-trimesechni-2000-2007.csv")
do2007 <- subset(do2007, sektori == "obshto")
ot2008 <- read.csv("zaplata-nacionalni-trimesechni-2008-2014.csv")
ot2008 <- subset(ot2008, sektori == "obshto")

zaplata_all <- rbind(do2007, ot2008, obshtestwen_only, chasten_only)

write.table(zaplata_all, "zaplata-nacionalni-trimesechni-2000-2014-chasten-obshtestwen.csv",
            sep = ",", quote = FALSE, row.names = FALSE)

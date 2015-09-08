rm(list=ls())

library(readxl)
files_ob_ch <- list()

excel_sheets("Labour_1.1.1.1.xls")

# Load from 2000 to 2014

for (i in (1:15)) {
  files_ob_ch[[i]] <- read_excel("Labour_1.1.1.1.xls", sheet = i)
  assign("files_ob_ch", files_ob_ch)
}

length(files_ob_ch)

# Give column names

files_ob_ch <- lapply(files_ob_ch, function(x) setNames(x, c("sektori", 1:12)))

View(files_ob_ch[[1]])

# Get only the values from "sektori", containint "сектор"

files_ob_ch <- lapply(files_ob_ch, function(x) x[grepl("сектор", x[["sektori"]]), ])

# Replace with names in latin

files_ob_ch <- lapply(files_ob_ch, transform, sektori = c("obshtestwen", "chasten"))

# Give names to the data frames in the list with the respective years

names(files_ob_ch) <- 2000:2014

files_ob_ch

# Convert from wide to long

library(tidyr)

files_ob_ch_long <- lapply(files_ob_ch, gather, month, naeti, 2:13)

# Concatenate the data frames in the long format

all_ob_ch <- do.call("rbind", files_ob_ch_long)
head(all_ob_ch)

# Add year from the names of the data frames in the list

all_ob_ch$year <- rep(names(files_ob_ch_long), sapply(files_ob_ch_long, nrow))

head(all_ob_ch)

# Make additional adjustments

library(stringi)

all_ob_ch$naeti <- stri_replace_all_charclass(all_ob_ch$naeti, "\\p{WHITE_SPACE}", "")
all_ob_ch$naeti <- as.numeric(all_ob_ch$naeti)
all_ob_ch$month <- gsub("X", "", all_ob_ch$month)
all_ob_ch$month <- as.numeric(all_ob_ch$month)
all_ob_ch$year <- as.numeric(all_ob_ch$year)

head(all_ob_ch)
all_ob_ch <- all_ob_ch[ ,c(1,3,4,2)]
head(all_ob_ch)

all_obshtestwen <- all_ob_ch[grepl("obshtestwen", all_ob_ch$sektori), ]
all_chasten <- all_ob_ch[grepl("chasten", all_ob_ch$sektori), ]

do2007 <- read.csv("naetilica-nacionalni-mesechni-2000-2007.csv")
ot2008 <- read.csv("naetilica-nacionalni-mesechni-2008-2014.csv")

do2007obshto <- do2007[grepl("obshto", do2007$sektori), ]
ot2008obshto <- ot2008[grepl("obshto", ot2008$sektori), ]

head(do2007obshto)

all_po_sobstwenost <- rbind(do2007obshto, ot2008obshto, all_obshtestwen, all_chasten)

head(all_po_sobstwenost)

write.table(all_po_sobstwenost, "naetilica-nacionalni-mesechni-2000-2014-chasten-obshtestwen.csv",
            sep = ",", quote = FALSE, row.names = FALSE)

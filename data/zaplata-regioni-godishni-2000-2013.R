rm(list = ls())

library(stringi)
library(tidyr)
library(readxl)

zaplata <- read_excel("Labour_2.2.2.xls", sheet = 1)

zaplata <- zaplata[6:nrow(zaplata), ]

colnames(zaplata) <- c("region", 2000:2013)
head(zaplata)

zaplata$region <- gsub("-", "", zaplata$region)
zaplata$region <- stri_trim_both(zaplata$region)
zaplata$region <- stri_replace_all_fixed(zaplata$region, "София(столица)", "София (столица)")

zaplata <- zaplata[complete.cases(zaplata[[1]]), ]

for (i in c(2:15)) {
  zaplata[[i]] <- as.numeric(zaplata[[i]])
}

zaplata_long <- gather(zaplata, godina, godishna_zaplata, 2:15)
head(zaplata_long)

write.csv(zaplata_long, "zaplata-regioni-godishni-2000-2013.csv", row.names = FALSE)

rm(list = ls())

library(readxl)

excel_sheets("Labour_1.2.1.xls")

files <- list()
for (i in 1:15){
  files[[i]] <- read_excel("Labour_1.2.1.xls", sheet = i)
}

lapply(files, nrow)

filessub <- lapply(files, function(x) x[6:(nrow(x)-2), ])

filessub <- lapply(filessub, function(x) x[complete.cases(x[3]), ])

lapply(filessub, nrow)

filessub <- lapply(filessub, function(x) setNames(x, c("sektori", "kod", "Q1", "Q2", "Q3", "Q4")))

library(tidyr)

files_long <- lapply(filessub, gather, quarter, naeti, 3:6)

files_long <- setNames(files_long, 2000:2014)

files_all <- do.call(rbind, files_long)

files_all$year <- rep(names(files_long), sapply(files_long, nrow))

str(files_all)

for (i in names(files_all)[4:5]) {
  files_all[[i]] <- as.numeric(files_all[[i]])
}

library(stringi)

files_all$kod <- stri_trim_both(files_all$kod)
# files_all$sektori <- stri_trim_both(files_all$sektori)

files_all <- files_all[ ,c(1,2,4,5,3)]

write.csv(files_all, "naetilica-nacionalni-trimesechni-2000-2014.csv",
          row.names = FALSE)
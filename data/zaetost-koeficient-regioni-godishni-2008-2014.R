rm(list = ls())

library(stringi)
library(tidyr)
library(gdata)

# We need gdata to open the excel file. It is not
# well structured and takes a lot of time to read

files <- list()
for (i in 1:9) {
  files[[i]] <- read.xls("Labour_3.2.2.xls", sheet = i)
}

length(files)  

View(files[[3]])

files_sub <- files[c(2,3,4,6,7,8,9)]

length(files_sub)

files_sub <- setNames(files_sub, 2008:2014)

files_sub <- lapply(files_sub, function(x) x[(nrow(x)-38):nrow(x), ])

files_sub <- lapply(files_sub, function(x) x[which(x[[1]] == "Общо"):which(x[[1]] == "Хасково"), ])

files_sub <- lapply(files_sub, function(x) x[ ,c(1,5,6,7)])

files_sub <- lapply(files_sub, function(x) setNames(x, c("region", "obshto", "myzhe", "zheni")))

# Convert to numeric columns 2:4 in each data frame of the list.
# It is important to convert first to character, as it is factor
# at the time of the conversion and it will replace the factor 
# name with its level.

for (i in 1:length(files_sub)) {
  for (j in 2:ncol(files_sub[[1]])) {
    files_sub[[i]][[j]] <- as.numeric(as.character(files_sub[[i]][[j]]))
  }
}

# Remove NA values. We can do so safely as they 
# correspond to region classification we are not interested
# anyway.


files_sub <- lapply(files_sub, function(x) x[complete.cases(x[["obshto"]]), ])

files_long <- lapply(files_sub, gather, grupa, koef_zaetost, 2:4)

# add year

for (i in 1:length(files_long)) {
  files_long[[i]][["godina"]] <- rep(names(files_long[i]), nrow(files_long[[i]]))
}

View(files_long[[1]])

files_all <- do.call("rbind", files_long)

head(files_all)
tail(files_all)

write.csv(files_all, "zaetost-koeficient-regioni-godishni-2008-2014.csv", row.names = FALSE)

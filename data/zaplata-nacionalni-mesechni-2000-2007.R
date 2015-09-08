rm(list=ls())

library(readxl)

excel_sheets("Labour_1.1.2.1.xls")

files2003 <- list()

for (i in 1:8) {
  files2003[[i]] <- read_excel("Labour_1.1.2.1.xls", sheet = i)
}

files2003 <- lapply(files2003, function(x) setNames(x, c("sektori", 1:12)))

lapply(files2003, nrow)

View(files2003[[1]])

sectornames2003bg <- files2003[[1]][["sektori"]][5:19]
sectornames2003bg
sectornames2003en <- c("obshto", "selsko", "dobiwna", "prerabodwashta",
                       "energiq i woda", "stroitelstwo", "tyrgowiq", 
                       "hoteli", "transport", "finansi", "imoti", 
                       "dyrvawnouprawlenie", "obrazowanie", 
                       "zdraweopazwane", "drugi")

names2003 <- as.list(sectornames2003en)
names(names2003) <- sectornames2003bg
names2003

View(lapply(files2003, "[", 5:19,1))

# It looks OK. We will subset using numbers.

files2003 <- lapply(files2003, "[", 5:19, )

# Give latin names to the sectors

files2003 <- lapply(files2003, transform, sektori = sectornames2003en)

# or
# lapply(files2003, function(x) transform(x, sektori = sectornames2003en))

lapply(files2003, function(x) print(x$sektori))

# Convert from wide to long format

library(tidyr)

files2003long <- lapply(files2003, gather, month, zaplata, 2:13)

lapply(files2003long, nrow)

all2003 <- do.call("rbind", files2003long)

head(all2003)

# Now we need to add the "year" variable.
# For this we need to put names to the list of data frames

names(files2003long)
files2003long <- setNames(files2003long, c(2000:2007))

# Now use the following function to fill in "year" from the names
# of "files2003long"

all2003$year <- rep(names(files2003long), sapply(files2003long, nrow))

head(all2003)
str(all2003)

all2003$month <- gsub("X", "", all2003$month)
all2003$month <- as.numeric(all2003$month)
all2003$year <- as.numeric(all2003$year)
all2003$zaplata <- as.numeric(all2003$zaplata)

all2003 <- all2003[ ,c(1,3,4,2)]

write.table(all2003, "zaplata-nacionalni-mesechni-2000-2007.csv", 
            sep = ",", row.names = FALSE, quote = FALSE)
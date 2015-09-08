rm(list=ls())

library(readxl)

excel_sheets("Labour_1.1.1.1.xls")

files2003 <- list()

for (i in 1:8) {
  files2003[[i]] <- read_excel("Labour_1.1.1.1.xls", sheet = i)
  assign("files2003", files2003)
}


length(files2003)

# set names

files2003 <- lapply(files2003, function(x) setNames(x, c("sektori", 1:12)))

View(files2003[[1]])

lapply(files2003, print(nrow))

sectornames2003bg <- files2003[[1]][["sektori"]][5:19]
sectornames2003en <- c("obshto", "selsko", "dobiwna", "prerabodwashta",
                       "energiq i woda", "stroitelstwo", "tyrgowiq", 
                       "hoteli", "transport", "finansi", "imoti", 
                       "dyrvawnouprawlenie", "obrazowanie", 
                       "zdraweopazwane", "drugi")

names2003 <- as.list(sectornames2003en)
names(names2003) <- sectornames2003bg
names2003

# Subset the dataframes using the names of the sectors

# We can use this command, but the names don't match exactly
# files2003 <- lapply(files2003, function(x) x[x[["sektori"]] %in% sectornames2003bg, ])

# Which makes the following unnecessary
## Remove first row, as "Общо" appears twice and on first row
## there are no values in the other columns.
# files2003 <- lapply(files2003, function(x) x[-1, ])

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

files2003long <- lapply(files2003, gather, month, naeti, 2:13)

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

# Make some additional adjustments

all2003$month <- gsub("X", "", all2003$month)
all2003$month <- as.numeric(all2003$month)
all2003$year <- as.numeric(all2003$year)

# There are NA values, when we convert "naeti" to numeric. 
# See where they are:
# all2003[which(is.na(all2003$naeti)), ]
# navalues <- which(is.na(all2003$naeti))
# Check one of these values in the wide format 
# (year 2004, month 1, "obshto")
# View(files2003[[5]])
# It's because there are spaces between digits
# Remove them, but as neither gsub, nor functions from the
# stringr library work (probably because of the encoding),
# we have to use the library stringi

library(stringi)

all2003$naeti <- stri_replace_all_charclass(all2003$naeti, "\\p{WHITE_SPACE}", "")

# And now convert to numeric

all2003$naeti <- as.numeric(all2003$naeti)

head(all2003)
all2003 <- all2003[ ,c(1,3,4,2)]
head(all2003)

write.table(all2003, "naetilica-nacionalni-mesechni-2000-2007.csv", 
            sep = ",", quote = FALSE, row.names = FALSE)
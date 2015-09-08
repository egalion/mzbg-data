rm(list=ls())

library(readxl)

excel_sheets("Labour_1.1.3.xls")

rm2006 <- read_excel("Labour_1.1.3.xls", sheet = 1)

View(rm2006)

# Set column names

colnames(rm2006) <- c("sektori", c(paste("swobodni", 1:4, sep = "-")),
                      c(paste("koef", 1:4, sep = "-")),
                      c(paste("zaeti", 1:4, sep = "-"))
                      )

# Find where the data for each year begins.
# Then use it as a starting point.
# Add the number of other sectors to mark the end point.

startcount <- which(rm2006$sektori == "Общо")
# endcount <- which(rm2006$sektori == "Общо") + 14

# Create vector for subset
# We can use a for loop (it works OK), but instead
# sapply and seq can do the job.

# tmp <- list()
# for (i in 1:length(startcount)) {
#   tmp[[i]] <- seq(from = startcount[i], to = endcount[i])
# }

# Subset

# rm2006 <- rm2006[unlist(tmp), ]

rm2006 <- rm2006[as.vector(sapply(startcount, seq, length.out = 15)), ]

# Add year

rm2006$year <- c(rep("2006", 15), rep("2007", 15), rep("2008", 15))

# Replace sector names in cyrillic with names in latin

sectornames2003en <- c("obshto", "selsko", "dobiwna", "prerabodwashta",
                       "energiq i woda", "stroitelstwo", "tyrgowiq", 
                       "hoteli", "transport", "finansi", "imoti", 
                       "dyrvawnouprawlenie", "obrazowanie", 
                       "zdraweopazwane", "drugi")

rm2006$sektori <- rep(sectornames2003en, 3)

# Convert data to long format

library(tidyr)
library(dplyr)

# Convert to long form
step1 <- gather(rm2006, pokazatel, stojnost, -sektori, -year)

# Split the variable "pokazatel" into to new variables - 
# "kategoriq" and "month", using a regex pattern
step2 <- extract(step1, pokazatel, c("kategoriq", "month"), "([a-zA-Z]*)-(.)")
# Alternatively use
# proben <- separate(step1, pokazatel, c("kategoriq", "month"), sep = "-")

# Spread the vallues of "kategoriq" using "stojnost" from step1
step3 <- spread(step2, kategoriq, stojnost)

# Optional - this is not a true long format. We can convert it
# if we want to, using "gather" again.
# step4 <- gather(step3, pokazatel, stojnost, 4:6)

head(step3)

# Make some additional adjustments

for (i in c(colnames(step3))[2:6]) {
  step3[[i]] <- as.numeric(step3[[i]])
}

rabotni_mesta_2006_2008 <- step3[ ,c(1,6,5,4,2,3)]
head(rabotni_mesta_2006_2008)

write.table(rabotni_mesta_2006_2008, "rabotni-mesta-nacionalni-trimesechni-2006-2008.csv",
            quote = FALSE, row.names = FALSE, sep = ",")


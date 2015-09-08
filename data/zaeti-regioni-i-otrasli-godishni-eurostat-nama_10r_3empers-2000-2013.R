rm = list(ls())

library(eurostat)

empl <- get_eurostat("nama_10r_3empers", time_format = "num")

head(empl)

emplBG_reg <- empl[grepl("BG", empl$geo), ]
head(emplBG_reg)

write.csv(emplBG_reg, "zaeti-regioni-i-otrasli-godishni-eurostat-nama_10r_3empers-2000-2013.csv", row.names = FALSE)

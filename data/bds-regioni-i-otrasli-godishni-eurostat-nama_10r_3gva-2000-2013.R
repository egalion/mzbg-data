rm(list = ls())

library(eurostat)

bds <- get_eurostat("nama_10r_3gva", time_format = "num")

bds_bg <- bds[grepl("BG", bds$geo), ]

head(bds_bg)


sapply(bds_bg[ , 1:3], function(x) unique(factor(x)))

write.csv(bds_bg, "bds-regioni-i-otrasli-godishni-eurostat-nama_10r_3gva-2000-2013.csv", row.names = FALSE)

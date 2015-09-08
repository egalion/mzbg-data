rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lfsq_epgana", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

sapply(bgdata[ ,1:6], function(x) unique(factor(x)))

write.csv(bgdata, "zaetost-nacionalni-trimesechni-nepylno-eurostat-lfsq_epgana-1998-2008.csv",
          row.names = FALSE)
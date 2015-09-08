rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lfsq_epgais", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

sapply(bgdata[ ,1:6], function(x) unique(factor(x)))

write.csv(bgdata, "zaetost-nacionalni-trimesechni-nepylno-profesii-eurostat-lfsq_epgais-2000-2015.csv",
          row.names = FALSE)
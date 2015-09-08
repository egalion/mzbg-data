rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("namq_10_a10_e", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

head(bgdata)

sapply(bgdata[ ,1:4], function(x) unique(factor(x)))

write.csv(bgdata, "zaetost-nacionalni-trimesechni-eurostat-namq_10_a10-2000-2015.csv",
          row.names = FALSE)
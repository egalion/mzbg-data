rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("namq_10_a10", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

head(bgdata)

sapply(bgdata[ ,1:4], function(x) unique(factor(x)))

write.csv(bgdata, "bds-nacionalni-trimesechni-eurostat-namq_10_a10-2000-2015.csv",
          row.names = FALSE)
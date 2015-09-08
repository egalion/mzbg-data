rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lfsq_epgan2", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

sapply(bgdata[ ,1:6], function(x) unique(factor(x)))

write.csv(bgdata, "zaetost-nacionalni-trimesechni-nepylno-eurostat-lfsq_epgan2-2008-2015.csv",
          row.names = FALSE)
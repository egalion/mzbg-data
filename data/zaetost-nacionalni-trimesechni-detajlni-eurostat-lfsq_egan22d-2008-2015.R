rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lfsq_egan22d", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

head(bgdata)

sapply(bgdata[ ,1:4], function(x) unique(factor(x)))

write.csv(bgdata, "zaetost-nacionalni-trimesechni-detajlni-eurostat-lfsq_egan22d-2008-2015.csv",
          row.names = FALSE)
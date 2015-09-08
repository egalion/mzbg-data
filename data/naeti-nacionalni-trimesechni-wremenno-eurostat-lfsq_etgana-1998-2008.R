rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lfsq_etgana", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

sapply(bgdata[ ,1:4], function(x) unique(factor(x)))

write.csv(bgdata, "naeti-nacionalni-trimesechni-wremenno-eurostat-lfsq_etgana-1998-2008.csv",
          row.names = FALSE)
rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lfsq_eegana", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

sapply(bgdata[ ,1:4], function(x) unique(factor(x)))

write.csv(bgdata, "naeti-nacionalni-trimesechni-eurostat-lfsq_eegana-1998-2008.csv",
          row.names = FALSE)
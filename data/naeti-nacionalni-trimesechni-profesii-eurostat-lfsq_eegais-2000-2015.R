rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lfsq_eegais", time_format = "raw")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

sapply(bgdata[ ,1:4], function(x) unique(factor(x)))

write.csv(bgdata, "naeti-nacionalni-trimesechni-profesii-eurostat-lfsq_eegais-2000-2015.csv",
          row.names = FALSE)
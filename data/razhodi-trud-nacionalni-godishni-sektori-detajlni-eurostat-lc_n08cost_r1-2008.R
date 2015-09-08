rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lc_n08cost_r1", time_format = "num")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

head(bgdata)

sapply(bgdata[ ,2:7], function(x) unique(factor(x)))

write.csv(bgdata, "razhodi-trud-nacionalni-godishni-sektori-detajlni-eurostat-lc_n08cost_r1-2008.csv",
          row.names = FALSE)
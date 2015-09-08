rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("lc_ncost_r2", time_format = "num")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

head(bgdata)

sapply(bgdata[ ,1:4], function(x) unique(factor(x)))

write.csv(bgdata, "razhodi-trud-nacionalni-godishni-sektori-detajlni-eurostat-lc_ncost_r2-2008-i-2014.csv",
          row.names = FALSE)


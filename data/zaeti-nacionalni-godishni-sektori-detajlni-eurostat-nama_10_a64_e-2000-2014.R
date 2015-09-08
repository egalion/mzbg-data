rm(list = ls())

library(eurostat)

eurdata <- get_eurostat("nama_10_a64_e", time_format = "num")

head(eurdata)

bgdata <- eurdata[grepl("BG", eurdata$geo), ]

head(bgdata)

sapply(bgdata[ ,1:3], function(x) unique(factor(x)))

write.csv(bgdata, "zaeti-nacionalni-godishni-sektori-detajlni-eurostat-nama_10_a64_e-2000-2014.csv",
          row.names = FALSE)
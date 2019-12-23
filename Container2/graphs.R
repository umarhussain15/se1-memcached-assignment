library(lattice)
Sys.time()
read.table("output-throughput-latency/stats.csv", header=TRUE) -> csvDataFrameSource
csvDataFrame <- csvDataFrameSource
ts <- (as.numeric(Sys.time())*1000)
trellis.device("pdf", file=paste("graph1_",ts,".pdf", sep =""), color=T, width=6.5, height=5.0)

xyplot(requests ~ rate, data = csvDataFrame[,c("rate","requests")],
        xlab="Rate",
        ylab="Througput (req/sec)",
        main="Graph 1",
        type=c("p","l"))
dev.off() -> null

trellis.device("pdf", file=paste("graph2_",ts,".pdf", sep =""), color=T, width=6.5, height=5.0)

xyplot(latency/1000 ~ requests , data = csvDataFrame[,c("requests","latency")],
        xlab="Througput (req/sec)",
        ylab="Latency (s)",
        main="Graph 2",
        type=c("p","l"))
dev.off() -> null 

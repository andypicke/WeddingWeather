
# Figuring out best times for our wedding, weatherwise!

rm(list=ls())
library(ggplot2)
library(lubridate)

# KBU = Boulder (closest NWS station to Estes Park)
## Try writing a function to get weatger data for specified year
get_weather <- function(whyear){
url<-paste0("https://www.wunderground.com/history/airport/KBDU/",whyear,"/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=",whyear,"&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=&format=1")
fname<-paste0("DenWeather",whyear,".csv")
download.file(url,fname)
wea<-read.csv(fname)
if (nrow(wea)==0){
        print("no data for this year!")
        break
}
wea$MST <- as.Date(wea$MST,"%Y-%m-%d")
wea$month <- months(wea$MST)
wea$yday <- yday(wea$MST)
wea$year <- year(wea$MST)
wea
}

wea1<-get_weather("2010")
wea2<-get_weather("2011")
wea3<-get_weather("2012")
wea4<-get_weather("2013")
wea5<-get_weather("2014")
wea6<-get_weather("2015")

allwea<-rbind(wea1,wea2,wea3,wea4,wea5,wea6)

qplot(allwea$yday,allwea$Max.TemperatureF,color=as.factor(allwea$year),geom=c("point","smooth"))

##
# convert precipitation to numeric values (T=NA here)
allwea$PrecipNum <- as.numeric(as.character(allwea$PrecipitationIn))

qplot(allwea$yday,allwea$PrecipNum,color=as.factor(allwea$year),geom="point")


# Plot cloud cover (percentage?)
qplot(allwea$yday,allwea$CloudCover,color=as.factor(allwea$year),geom="point")

# Plot max wind
qplot(allwea$yday,allwea$Max.Wind.SpeedMPH,color=as.factor(allwea$year),geom=c("point","smooth"),ylab="Max Wind")

allwea<-rbind(wea4,wea5,wea6)
# Try making googleVis calendar plot
library(googleVis)
#op <- options(gvis.plot.tag = "chart") # do this for putting in R markdown?
Cal <- gvisCalendar(allwea, 
                    datevar="MST", 
                    numvar="Max.TemperatureF",
                    options=list(
                            title="Daily max temperature in Boulder",
                            height=320,
                            calendar="{yearLabel: { fontName: 'Times-Roman',
                               fontSize: 32, color: '#1A8763', bold: true},
                               cellSize: 10,
                               cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                               focusedCellColor: {stroke:'red'}}")
)
plot(Cal)

get_weather("2011")
        


# daily for 1 year
whyear="2012"
url<-paste0("https://www.wunderground.com/history/airport/KBDU/",whyear,"/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=",whyear,"&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=&format=1")
fname<-paste0("DenWeather",whyear,".csv")
download.file(url,fname)
wea<-read.csv(fname)
wea$MST <- as.Date(wea$MST,"%Y-%m-%d")
wea$month <- months(wea$MST)

# add yearday (to compare different years easily)
wea$yday <- yday(wea$MST)

str(wea)

# Let's take a look at just last year first.
plot(wea$MST,wea$Max.Temperature)

#hist(wea$Max.TemperatureF)

qplot(wea$yday,wea$Max.TemperatureF,geom=c("point","smooth"),xlab='Yearday',ylab = 'Max Temp',main=whyear)

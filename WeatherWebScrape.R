##---------------------------------------------------\
##-------------------------------------------------| |
##          ***Simple Weather Webscrape***         | |
##               ***FROMDATA.ORG***                | |
##-------------------------------------------------| |
##---------------------------------------------------/

##----Set working directory----
setwd("C:/Users/Nick/FromData/Rcode")

##----Set Location Code----
loc_code = "KLAS"

##----Set Retrieval Date----
retrieval_date = as.Date("2014-03-09") # Could also be today: 'Sys.Date()'

##----Set Site Address----
# Site = "http://www.wunderground.com/history/airport/KLAS/2014/3/10/DailyHistory.html?format=1"
site_prefix = "http://www.wunderground.com/history/airport/"
site_suffix = "/DailyHistory.html?format=1"
weather_link = paste(site_prefix,loc_code,"/",gsub("-","/",retrieval_date),
                     site_suffix,sep="")

##----Retrieve Web Info----
weather_info = readLines(weather_link)[-1]
weather_info = strsplit(weather_info,",")
headers = weather_info[[1]]
weather_info = weather_info[-1]

weather_info = do.call(rbind.data.frame,weather_info)
names(weather_info)= headers

##----Convert Data Frame Columns----
weather_info = data.frame(lapply(weather_info, as.character), stringsAsFactors=FALSE)
numeric_cols = c(2,3,4,5,6,8,9,10,13)
weather_info[numeric_cols] = lapply(weather_info[numeric_cols],as.numeric)
weather_info[is.na(weather_info)]=0
colnames(weather_info)[14]="Date"
weather_info$Date = as.Date(substr(weather_info$Date,1,10))

plot(weather_info$TemperatureF,type="l",main="Temperature",ylab="Temp",xlab="Hour")

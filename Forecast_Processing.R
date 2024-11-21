library(odbc)
library(dplyr)
library(tidyr)

con <- dbConnect(odbc::odbc(), 
                 .connection_string = "Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=W:/MIE262/Warp Shoes Project/WARP2011W.mdb;")
df <- dbGetQuery(con, "SELECT * FROM Product_Demand")
dbDisconnect(con)


df <- df %>%
  group_by(Year, Month, Product_Num) %>%
  summarise(total_demand = sum(Demand)) %>%
  select("Product_Num",  "Year", "Month","total_demand")

print(head(df))

write.csv(df, "W:/MIE262/Warp Shoes Project/forecast.csv")

#the csv is then passed to python to perform forecasting for Feb 2007
#we load it here to convert it back into a db table

feb_dem_df <- read.csv("W:/MIE262/Warp Shoes Project/feb_demand.csv")
feb_dem_df <- transmute(feb_dem_df, Product, Demand=Feb.Demand)
head(feb_dem_df)
con <- dbConnect(odbc::odbc(), 
                .connection_string = "Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=W:/MIE262/Warp Shoes Project/ForecastedDemandDatabase.mdb;")

dbWriteTable(con, "feb_2007_demand", feb_dem_df, overwrite=TRUE)
check <- dbGetQuery(con, "SELECT COUNT(*) FROM feb_2007_demand")
print(check)
dbDisconnect(con)

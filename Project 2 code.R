library(dplyr)
library(openxlsx)
library(ggplot2)
library(scales)
library(stringr)
library(plotly)
library(janitor)

#Bring in data files 
library(readxl)
consump_meat <- read_excel("~/R/Project 2/Meat_consumption.xlsx")


consump_eggs <-read_excel("~/R/Project 2/Egg product consumption.xlsx")


consump_dairy <- read_excel("~/R/Project 2/dairy_consumption.xlsx")


#Clean meat consumption data
consump_meat$...3 <- NULL
consump_meat$...4 <- NULL
consump_meat$...5 <- NULL
consump_meat$...6 <- NULL
consump_meat$...7 <- NULL
consump_meat$...8 <- NULL
consump_meat$...10 <- NULL
consump_meat$...11 <- NULL
consump_meat$...12 <- NULL
consump_meat <- consump_meat[-c(3:71),]
consump_meat <- consump_meat[-c(113:124),]
consump_meat <- consump_meat %>% dplyr::rename("Year"=1)
consump_meat <- consump_meat %>% dplyr::rename("Total Supply"=3)
consump_meat <- consump_meat %>% dplyr::rename("Per Capita Consumption (lbs. per person)"=5)
consump_meat <- consump_meat %>% dplyr::rename("US Population (/1000 persons)"=4)
consump_meat <- consump_meat[-c(1:2),]
consump_meat <- consump_meat[!grepl("Q", consump_meat$...2),]
Years <- c(1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020)
consump_meat$`Year` <- Years
consump_meat$`Per Capita Consumption (lbs. per person)` <- as.numeric(consump_meat$`Per Capita Consumption (lbs. per person)`)
consump_meat$`Total Supply` <- as.numeric(consump_meat$`Total Supply`)
consump_meat$`US Population (/1000 persons)` <- as.numeric(consump_meat$`US Population (/1000 persons)`)
meat_consumption <- consump_meat %>% dplyr::select(Year, 'Per Capita Consumption (lbs. per person)')
meat_consumption$product <- "meat"

#Clean dairy consumption data
consump_dairy$...2 <- NULL
consump_dairy <- consump_dairy %>% dplyr::rename("Per Capita Consumption (lbs. per person)"=19)
consump_dairy <- consump_dairy %>% dplyr::rename("Year"=1)
dairy_consumption <- consump_dairy %>% dplyr::select(Year,'Per Capita Consumption (lbs. per person)')
dairy_consumption <- dairy_consumption[-c(1:28),]
dairy_consumption$Year <- as.numeric(dairy_consumption$Year)
dairy_consumption$`Per Capita Consumption (lbs. per person)` <- as.numeric(dairy_consumption$`Per Capita Consumption (lbs. per person)`)
dairy_consumption <- dairy_consumption[-c(23:29),]
dairy_consumption$product <- "dairy"

#Clean egg consumption data
consump_eggs <-consump_eggs %>% dplyr::rename("Per Capita Consumption (lbs. per person)" =15)
consump_eggs <- consump_eggs %>% dplyr::rename("Year"=1)
consump_eggs <- consump_eggs[-c(1:47),]
consump_eggs <- consump_eggs[!grepl("Q", consump_eggs$...2),]
consump_eggs <- consump_eggs[-c(23:31),]
consump_eggs$Year <- Years
egg_consumption <- consump_eggs %>% dplyr::select(Year, 'Per Capita Consumption (lbs. per person)')
egg_consumption$`Per Capita Consumption (lbs. per person)` <- as.numeric(egg_consumption$`Per Capita Consumption (lbs. per person)`)
egg_consumption$product <- "egg"

new_data <- (rbind(egg_consumption, meat_consumption))
animal_products <- (rbind(new_data, dairy_consumption))



#-------------------------------------Bring in and health data --------------------------------------------------------

health_data <- read_excel("~/R/Project 2/diabetes&obesity.xlsx")
health_data <- health_data[-(1:2),]
health_data$...2 <- NULL
health_data$...3 <- NULL
health_data$...5 <- NULL
health_data$...7 <- NULL
health_data$...9 <- NULL
health_data$...11 <- NULL
health_data$...13 <- NULL
health_data$...15 <- NULL
health_data$...17 <- NULL
health_data$...19 <- NULL
health_data$...21 <- NULL
health_data$...23 <- NULL
health_data <- na.omit(health_data)
health_data$...4 <- as.numeric(health_data$...4)

health_data <- t(health_data)

health_data <- data.frame(health_data)

health_data$X2 <- NULL

h_data <- health_data %>% dplyr::select(X3, X9, X11)
h_data <- h_data[-(1),]
  

Years2 <- c("1999-2000", "2001-2002", "2003-2004", "2005-2006", "2007-2008", "2009-2010", "2011-2012", "2013-2014", "2015-2016", "2017-2018")
healthy_data <- data.frame(Year=character(10), Diabetes_rate= integer(10), Hypertension_rate = integer(10), Obesity_rate= integer(10))
healthy_data$Year <- Years2
healthy_data$Diabetes_rate <-h_data$X3
healthy_data$Hypertension_rate <- h_data$X9
healthy_data$Obesity_rate <- h_data$X11
healthy_data$Diabetes_rate <- as.numeric(healthy_data$Diabetes_rate)
healthy_data$Hypertension_rate <- as.numeric(healthy_data$Hypertension_rate)
healthy_data$Obesity_rate <- as.numeric(healthy_data$Obesity_rate)


save(animal_products, file = "./Animal_product_consumption.RData")
save(healthy_data, file = "./health_data.RData")

view(animal_products)

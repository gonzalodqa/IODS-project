# Gonzalo de Quesada
# 26/11/2017
# Chapter 4: create_human.R

#read the datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Look the structure, dimensions and summaries:

str(hd)
dim(hd)
summary(hd)

###########################################################

str(gii)
dim(gii)
summary(gii)


# Rename variables with shorter names:

colnames(hd)[1] <- "HDI.rank"
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "lifexp"
colnames(hd)[5] <- "yr.eduexp"
colnames(hd)[6] <- "meanyr.edu"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNIrank-HDIrank"


colnames(gii)[1] <- "GII.rank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "matermor"
colnames(gii)[5] <- "adobirth"
colnames(gii)[6] <- "repreparl"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labforceF"
colnames(gii)[10] <- "labforceM"

colnames(hd)
colnames(gii)

# Mutate the "Gender inequality" data to create 2 new variables. First is the ratio edu2F/edu2M. Second is labforceF/labforceM.

gii <- mutate(gii, ratio.edu2 = gii$edu2F/gii$edu2M)
gii <- mutate(gii, ratio.labforce = gii$labforceF/gii$labforceM)

colnames(gii)
summary(gii$ratio.edu2)
summary(gii$ratio.labforce)

# Join the two datasets using variable country as the identifier:

library(dplyr)
human <- inner_join(hd, gii, by = "country")

# Overview the new dataset:

glimpse(human)


# save data

setwd("C:/Users/D E L L/Documents/GitHub/IODS-project/Data")
write.table(human, file = "human.csv", sep = ",", col.names = TRUE, row.names = FALSE)


setwd("C:/Users/D E L L/Documents/GitHub/IODS-project/Data")
human <- read.table("human.csv", header = TRUE, sep = ",")
str(human)


# We mutate the data transforming the GNI variable to numeric. But first we must transform the comma separating the thousands so R would be able to read it properly.

install.packages("stringr")
library(stringr)
library(dplyr)

human <- mutate(human, GNI = str_replace(human$GNI, pattern = ",", replace = "") %>% as.numeric())
human$GNI

# We want to keep only few variables in:

keep <- c("country", "ratio.edu2", "ratio.labforce", "yr.eduexp", "lifexp", "GNI", "matermor", "adobirth", "repreparl")
human <- select(human, one_of(keep))

# Remove all rows with missing values:
complete.cases(human)
data.frame(human, comp = complete.cases(human))
human_ <- filter(human, complete.cases(human))

str(human_)

# Remove observations which relate to regions instead of countries:
tail(human_, n= 10)

# It seems that the last 7 observations from human has regions instead of countries, so we should remove the last 7 observations.
# First we identify with a new object the last 7 observations and then we select everything except those last 7 observations.

last <- nrow(human_) - 7

human_ <- human_[1:last,]

# We define the row names of the data by the country names.

rownames(human_) <- human_$country

# We remove the country name column from the data.

human_ <- select(human_, -country)

str(human_)
glimpse(human_)

# Finally, we save overwriting the previous human.csv file.
setwd("C:/Users/D E L L/Documents/GitHub/IODS-project/Data")

write.table(human_, file = "human.csv", sep = ",", col.names = TRUE, row.names = TRUE)

human <- read.table(file="human.csv", header = TRUE, row.names = 1)
str(human)


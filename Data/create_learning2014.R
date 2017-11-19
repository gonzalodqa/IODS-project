# Gonzalo de Quesada

# November 07th, 2017 

# Rstudio exercise 2

# read the data into memory
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header = TRUE)

# look at the dimension of the data
dim(learning2014)

# look at the structure of the data
str(learning2014)

#Data contains 183 obbesvations and 63 variables

library(dplyr)

# Combine deep, stra and surf
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06", "D15", "D23", "D31")
stra_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")
surf_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21", "SU29", "SU08", "SU16", "SU24", "SU32")

# select the columns
deep_columns <- select(learning2014, one_of(deep_questions))
stra_columns <- select(learning2014, one_of(stra_questions))
surf_columns <- select(learning2014, one_of(surf_questions))

# apply mean to the columns
learning2014$deep <- rowMeans(deep_columns)
learning2014$stra <- rowMeans(stra_columns)
learning2014$surf <- rowMeans(surf_columns)

# scaling attitude
learning2014$Attitude <- learning2014$Attitude/10

# exclude observations where exam points is zero
learning2014 <- subset(learning2014, (Points > 0))

# select columns
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

learning2014col <- select(learning2014, one_of(keep_columns))

str(learning2014col)

dim(learning2014col)

# safe data
setwd("C:/Users/D E L L/Documents/GitHub/IODS-project/Data")

write.csv(learning2014col, file = "learning2014.csv", row.names = FALSE)

# check data
str(learning2014col)

head(learning2014col)

read.csv("learning2014.csv", header = TRUE)

library(ggplot2)

library(GGally)

p <- ggpairs(learning2014col, mapping = aes(col=gender), lower=list(combo=wrap("facethist", bins=20)))

p

model <- lm(Points ~ Attitude + stra + surf, learning2014col)

model

model1 <- lm(Points ~ Attitude, learning2014col)

model1

plot(model1, 1)

plot(model1, 2)

plot(model1, 5)

## Chapter 3: Logistic regresion
# Name: Gonzalo de Queada 
# Date: 17/11/2017
# File description: logistic regression
# Source: UCI Machine Learning Repository, Student Performance Data https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Read data
math <- read.csv("C:/Users/D E L L/Documents/GitHub/IODS-project/Data/student-mat.csv", sep = ";", header = TRUE)
por <- read.csv("C:/Users/D E L L/Documents/GitHub/IODS-project/Data/student-por.csv", sep = ";", header = TRUE)

str(math)
dim(math)

str(por)
dim(por)

# join datasets
library(dplyr)
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c("math", "por"))

dim(math_por)
str(math_por)

# new data with merge comuns
alc <- select(math_por, one_of("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"))
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
notjoined_columns

# for every column name not used
for(column_name in notjoined_columns) {
  # columns from 'math_por' with the same name
  two_columns <- select(math_por, starts_with(column_name))
  # first column vector of the two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if the first column vector is numeric
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }}
colnames(alc)
str(alc)
glimpse(alc)

# Use the average of the weekday and weekend alcohol consumption to create a new column
library(ggplot2)
alc <- mutate (alc, alc_use = (Dalc + Walc)/2)
g1 <- ggplot(data = alc, aes(x = alc_use, fill = sex))
g1 + geom_bar()

alc <- mutate(alc, high_use = alc_use > 2)
g2 <- ggplot(alc, aes(high_use))
g2 + facet_wrap("sex") + geom_bar()

# save file
write.csv(alc, file = "C:/Users/D E L L/Documents/GitHub/IODS-project/Data/alc.csv", row.names = FALSE)


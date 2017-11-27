# Gonzalo de Quesada
# 26/11/2017
# Chapter 4: create_human.R

#read the datasets

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#dimensions and structure of the data

dim(hd)
dim(gii)
str(hd)
str(gii)

# library

library(dplyr)

#summaries

summary(hd)
summary(gii)

#rename the variables 

colnames(hd) <- c("rank", "country", "hdi", "life_exp", "exp_edu", "mean_edu","gni_c","gni_rank")
colnames(gii) <-  c("gii_rank", "country","gii", "mat_mort","ad_birth","repr_parl","sedu_f","sed_m","lab_f","lab_m")

# Mutate gender inequality

gii <- mutate(gii, sedu_ratio= sedu_f/sed_m)

gii <- mutate(gii, lab_ratio=lab_f/lab_m)

# join the datasets by country

human <- inner_join(hd, gii, by = "country")
str(human)
dim(human)

# save data

write.csv(human, file = "human.csv", row.names = FALSE)


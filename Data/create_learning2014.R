Gonzalo de Quesada
November 07th 
Rstudio exercise 2

# read the data into memory
data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header = TRUE)

# look at the dimension of the data
dim(data)

# look at the structure of the data
str(data)

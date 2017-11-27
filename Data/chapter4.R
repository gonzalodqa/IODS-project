library(MASS)
summary(Boston)
dim(Boston)
str(Boston)
install.packages("contrib.url")

library(dplyr)
install.packages("corrplot")
library(corrplot)

cor_matrix<-cor(Boston) %>% round(digits=2)
cor_matrix
corrplot(cor_matrix, method="circle", type="upper", cl.pos="b", tl.pos="d", tl.cex=0.6)

boston_scaled <- scale(Boston)
summary(boston_scaled)
class(boston_scaled)
boston_scaled <- as.data.frame(boston_scaled)
bins <- quantile(boston_scaled$crim)
crime <- cut(boston_scaled$crim, breaks = bins, include.lowest = TRUE, label=c("low","med_low", "med_high", "high"))
table(crime)
boston_scaled <- dplyr::select(boston_scaled, -crim)
boston_scaled <- data.frame(boston_scaled, crime)

n <- nrow(boston_scaled)
ind <- sample(n,  size = n * 0.8)
train <- boston_scaled[ind,]
test <- boston_scaled[-ind,]
correct_classes <- test$crime
test <- dplyr::select(test, -crime)

lda.fit <- lda(crime ~ . , data = train)
lda.fit
lda.arrows <- function(x, myscale = 1, arrow_heads = 0.1, color = "red", tex = 0.75, choices = c(1,2)){
  heads <- coef(x)
  arrows(x0 = 0, y0 = 0, 
         x1 = myscale * heads[,choices[1]], 
         y1 = myscale * heads[,choices[2]], col=color, length = arrow_heads)
  text(myscale * heads[,choices], labels = row.names(heads), 
       cex = tex, col=color, pos=3)
}
classes <- as.numeric(train$crime)
plot(lda.fit, dimen = 2, col=classes, pch=classes)
lda.arrows(lda.fit, myscale = 2)

lda.pred <- predict(lda.fit, newdata = test)
table(correct = correct_classes, predicted = lda.pred$class)

data("Boston")
boston_s <- scale(Boston)
boston_s <- as.data.frame(boston_s)
dist_eu <- dist(boston_s)
summary(dist_eu)

km <-kmeans(boston_s, centers = 4)
pairs(boston_s[6:10], col = km$cluster)

library(ggplot2)
set.seed(123)
k_max <- 10
twcss <- sapply(1:k_max, function(k){kmeans(boston_s, k)$tot.withinss})
qplot(x = 1:k_max, y = twcss, geom = 'line')

library(GGally)
km <-kmeans(boston_s, centers = 2)
pairs(boston_s[6:10],col = km$cluster)

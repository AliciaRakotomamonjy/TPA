newDfClients <- merge(x = clients, y = joined_immatriculations_catalogue, by = "immatriculation",all.x = T)
str(newDfClients)

# Diagramme des effectifs des categories
qplot(categorie, data = newDfClients,main = "Distributions des catégories sur les clients")


set.seed(123)
features <- newDfClients[, c("age", "sexe", "taux", "situationfamiliale", "nbenfantsacharge", "deuxiemevoiture")]
target <- newDfClients$categorie

features$sexe <- as.factor(features$sexe)
features$situationfamiliale <- as.factor(features$situationfamiliale)
features$deuxiemevoiture <- as.factor(features$deuxiemevoiture)
target <- as.factor(target)

data <- cbind(features, categorie = target)

set.seed(123)
trainIndex <- createDataPartition(data$categorie, p = .8, 
                                  list = FALSE, 
                                  times = 1)

trainData <- data[ trainIndex,]
testData  <- data[-trainIndex,]

model <- rpart(categorie ~ ., data = trainData, method = "class")

predictions <- predict(model, testData, type = "class")

confusionMatrix(predictions, testData$categorie)

plot(model)
text(model, use.n = TRUE)
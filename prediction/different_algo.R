library(caret)
library(rpart)
library(randomForest)
library(e1071)
library(nnet)
library(keras)

newDfClients$sexe <- as.numeric(factor(newDfClients$sexe))
newDfClients$situationfamiliale <- as.numeric(factor(newDfClients$situationfamiliale))
newDfClients$deuxiemevoiture <- as.numeric(factor(newDfClients$deuxiemevoiture))

set.seed(123)
trainIndex <- createDataPartition(newDfClients$categorie, p = 0.8, list = FALSE)
trainData <- newDfClients[trainIndex,]
testData <- newDfClients[-trainIndex,]

colSums(is.na(trainData))

trainData <- na.omit(trainData)

colSums(is.na(trainData))

decisionTreeModel <- rpart(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData)
randomForestModel <- randomForest(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, ntree = 100)

decisionTreePred <- predict(decisionTreeModel, testData, type = "class")
randomForestPred <- predict(randomForestModel, testData)

confusionMatrix(decisionTreePred, testData$categorie)
confusionMatrix(randomForestPred, testData$categorie)

# Réseau de neurones simple
nnModel <- nnet(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, size = 5, maxit = 100)

nnPred <- predict(nnModel, testData, type = "class")

nnPred <- as.factor(nnPred)
testData$categorie <- as.factor(testData$categorie)
levels(nnPred) <- levels(testData$categorie)

confusionMatrix(nnPred, testData$categorie)

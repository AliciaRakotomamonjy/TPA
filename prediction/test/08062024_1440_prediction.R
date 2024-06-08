newDfClients <- merge(x = clients, y = joined_immatriculations_catalogue, by = "immatriculation",all.x = T)
str(newDfClients)

# Préparation des données
# Sélection des colonnes d'intérêt
data <- newDfClients[, c("age", "sexe", "taux", "situationfamiliale", "nbenfantsacharge", "deuxiemevoiture", "categorie")]

# Conversion des colonnes catégorielles en facteurs
data$sexe <- factor(data$sexe, levels = unique(data$sexe))
data$situationfamiliale <- factor(data$situationfamiliale, levels = unique(data$situationfamiliale))
data$deuxiemevoiture <- factor(data$deuxiemevoiture, levels = unique(data$deuxiemevoiture))

# Séparation des données en ensembles d'entraînement et de test
set.seed(123)
trainIndex <- sample(1:nrow(data), 0.8 * nrow(data))
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Assurer que les niveaux des facteurs sont les mêmes dans les ensembles d'entraînement et de test
trainData$sexe <- factor(trainData$sexe, levels = levels(data$sexe))
testData$sexe <- factor(testData$sexe, levels = levels(data$sexe))
trainData$situationfamiliale <- factor(trainData$situationfamiliale, levels = levels(data$situationfamiliale))
testData$situationfamiliale <- factor(testData$situationfamiliale, levels = levels(data$situationfamiliale))
trainData$deuxiemevoiture <- factor(trainData$deuxiemevoiture, levels = levels(data$deuxiemevoiture))
testData$deuxiemevoiture <- factor(testData$deuxiemevoiture, levels = levels(data$deuxiemevoiture))

required_packages <- c("caret", "rpart", "rpart.plot", "randomForest", "nnet")
installed_packages <- installed.packages()[, "Package"]
missing_packages <- required_packages[!(required_packages %in% installed_packages)]

if (length(missing_packages) > 0) {
    install.packages(missing_packages, dependencies = TRUE)
}

# Chargement des bibliothèques nécessaires
library(caret)
library(rpart)
library(rpart.plot)
library(randomForest)
library(nnet)

# Création des modèles d'arbres de décision
decisionTreeModel <- rpart(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData)
# Modèle 1 - Arbre de décision avec split = "information" et minbucket = 2500
tree_rp1 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "information"), control = rpart.control(minbucket = 2500))
# Modèle 2 - Arbre de décision avec split = "gini" et minbucket = 2500
tree_rp2 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "gini"), control = rpart.control(minbucket = 2500))
# Modèle 3 - Arbre de décision avec split = "information" et minbucket = 5000
tree_rp3 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "information"), control = rpart.control(minbucket = 5000))
# Modèle 4 - Arbre de décision avec split = "gini" et minbucket = 5000
tree_rp4 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "gini"), control = rpart.control(minbucket = 5000))

# Prédictions avec les modèles d'arbres de décision
decisionTreePred <- predict(decisionTreeModel, testData, type = "class")
pred_rp1 <- predict(tree_rp1, newdata = testData, type = "class")
pred_rp2 <- predict(tree_rp2, newdata = testData, type = "class")
pred_rp3 <- predict(tree_rp3, newdata = testData, type = "class")
pred_rp4 <- predict(tree_rp4, newdata = testData, type = "class")
# Calcul des performances des modèles d'arbres de décision
perfomance_decisionTree <- confusionMatrix(decisionTreePred, testData$categorie)
performance_rp1 <- confusionMatrix(pred_rp1, testData$categorie)
performance_rp2 <- confusionMatrix(pred_rp2, testData$categorie)
performance_rp3 <- confusionMatrix(pred_rp3, testData$categorie)
performance_rp4 <- confusionMatrix(pred_rp4, testData$categorie)

# Affichage des performances
perfomance_decisionTree
performance_rp1
performance_rp2
performance_rp3
performance_rp4

#Erreur dans na.fail.default(list(categorie = c(4L, 4L, 3L, 3L, 1L, 1L, 1L,  : 
#   valeurs manquantes dans l'objet

# Nettoyage et préparation des données (pour foret aleatoire et reseau de neurone)
newDfClients$sexe <- as.numeric(factor(newDfClients$sexe))
newDfClients$situationfamiliale <- as.numeric(factor(newDfClients$situationfamiliale))
newDfClients$deuxiemevoiture <- as.numeric(factor(newDfClients$deuxiemevoiture))

set.seed(123)
trainIndex <- createDataPartition(newDfClients$categorie, p = 0.8, list = FALSE)
trainData <- newDfClients[trainIndex, ]
testData <- newDfClients[-trainIndex, ]

colSums(is.na(trainData))
trainData <- na.omit(trainData)
colSums(is.na(trainData))

# Modèle de Forêt Aléatoire
randomForestModel <- randomForest(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, ntree = 200)
randomForestPred <- predict(randomForestModel, testData)
confusionMatrix(randomForestPred, testData$categorie)

# Modèle de Réseau de Neurones
nnModel <- nnet(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, size = 5, maxit = 100)
nnPred <- predict(nnModel, testData, type = "class")
nnPred <- as.factor(nnPred)
testData$categorie <- as.factor(testData$categorie)
levels(nnPred) <- levels(testData$categorie)
confusionMatrix(nnPred, testData$categorie)

marketing <- dbGetQuery(conn, "SELECT age,sexe,taux,situationFamiliale,nbenfantsacharge,deuxiemevoiture FROM marketing_kv_h_ext")

str(marketing)

marketing_predictions <- predict(randomForestModel, marketing)
marketing$predicted_categorie <- marketing_predictions

write.csv(marketing, file = "marketing.csv", row.names = FALSE)
getwd()
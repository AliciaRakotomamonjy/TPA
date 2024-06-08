#1. Preparation des donnees

# Extraction des colonnes : 
# Les colonnes sélectionnées du dataframe newDfClients sont assignées à l'objet data.
data <- newDfClients[, c("age", "sexe", "taux", "situationfamiliale", "nbenfantsacharge", "deuxiemevoiture", "categorie")]

# Conversion en facteurs : 
# Les colonnes sexe, situationfamiliale et deuxiemevoiture sont converties en facteurs avec des niveaux uniques basés sur les données présentes.
data$sexe <- factor(data$sexe, levels = unique(data$sexe))
data$situationfamiliale <- factor(data$situationfamiliale, levels = unique(data$situationfamiliale))
data$deuxiemevoiture <- factor(data$deuxiemevoiture, levels = unique(data$deuxiemevoiture))

#2. Partitionnement des Données
# Séparation des données : 
# Les données sont séparées en ensembles d'entraînement (80%) et de test (20%) de manière aléatoire pour garantir la reproductibilité (set.seed(123)).
set.seed(123)
trainIndex <- sample(1:nrow(data), 0.8 * nrow(data))
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

#3. Harmonisation des Niveaux des Facteurs
# Assurer la cohérence : 
# Les niveaux des facteurs pour les données d'entraînement et de test sont ajustés pour s'assurer qu'ils ont les mêmes niveaux que l'ensemble complet.
trainData$sexe <- factor(trainData$sexe, levels = levels(data$sexe))
testData$sexe <- factor(testData$sexe, levels = levels(data$sexe))
trainData$situationfamiliale <- factor(trainData$situationfamiliale, levels = levels(data$situationfamiliale))
testData$situationfamiliale <- factor(testData$situationfamiliale, levels = levels(data$situationfamiliale))
trainData$deuxiemevoiture <- factor(trainData$deuxiemevoiture, levels = levels(data$deuxiemevoiture))
testData$deuxiemevoiture <- factor(testData$deuxiemevoiture, levels = levels(data$deuxiemevoiture))

library(rpart)

# install.packages("rpart.plot")

library(rpart.plot)

# Construction des arbres : 
# Quatre arbres de décision sont construits avec différentes méthodes de division (information et gini) 
# et tailles minimales de bucket (2500 et 5000).

tree_rp1 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "information"), control = rpart.control(minbucket = 2500))
tree_rp2 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "gini"), control = rpart.control(minbucket = 2500))
tree_rp3 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "information"), control = rpart.control(minbucket = 5000))
tree_rp4 <- rpart(categorie ~ ., data = trainData, method = "class", parms = list(split = "gini"), control = rpart.control(minbucket = 5000))

# Les prédictions sont faites sur les données de test pour chaque arbre.
pred_rp1 <- predict(tree_rp1, newdata = testData, type = "class")
pred_rp2 <- predict(tree_rp2, newdata = testData, type = "class")
pred_rp3 <- predict(tree_rp3, newdata = testData, type = "class")
pred_rp4 <- predict(tree_rp4, newdata = testData, type = "class")

library(caret)

# calculate_performance utilise la matrice de confusion pour évaluer les performances des modèles
calculate_performance <- function(predictions, actuals) {
    confusionMatrix(predictions, actuals)
}

performance_rp1 <- calculate_performance(pred_rp1, testData$categorie)
performance_rp2 <- calculate_performance(pred_rp2, testData$categorie)
performance_rp3 <- calculate_performance(pred_rp3, testData$categorie)
performance_rp4 <- calculate_performance(pred_rp4, testData$categorie)

performance_rp1

# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              3718
#   Véhicules de Luxe / Haut de Gamme                998
#   SUV                                                0
#   Voitures Familiales                               10
#   Voitures de Sport                                 11
#   Véhicules Hybrides / Électriques                   1
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             2469
#   Véhicules de Luxe / Haut de Gamme                              5792
#   SUV                                                               0
#   Voitures Familiales                                              24
#   Voitures de Sport                                                11
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                2189                   2
#   Véhicules de Luxe / Haut de Gamme  443                   5
#   SUV                                  0                   0
#   Voitures Familiales               2171                8522
#   Voitures de Sport                  788                 638
#   Véhicules Hybrides / Électriques     1                 128
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                                2
#   Véhicules de Luxe / Haut de Gamme                 8
#   SUV                                               0
#   Voitures Familiales                            3871
#   Voitures de Sport                              4117
#   Véhicules Hybrides / Électriques                  1
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               1
#   Véhicules de Luxe / Haut de Gamme                              444
#   SUV                                                              0
#   Voitures Familiales                                           1648
#   Voitures de Sport                                                5
#   Véhicules Hybrides / Électriques                              1980

# Overall Statistics
                                          
#                Accuracy : 0.6033          
#                  95% CI : (0.5984, 0.6081)
#     No Information Rate : 0.2324          
#     P-Value [Acc > NIR] : < 2.2e-16       
                                          
#                   Kappa : 0.5088          
                                          
#  Mcnemar's Test P-Value : < 2.2e-16       

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                            0.78472
# Specificity                            0.86775
# Pos Pred Value                         0.44362
# Neg Pred Value                         0.96774
# Prevalence                             0.11846
# Detection Rate                         0.09295
# Detection Prevalence                   0.20954
# Balanced Accuracy                      0.82624
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.6982
# Specificity                                            0.9401
# Pos Pred Value                                         0.7532
# Neg Pred Value                                         0.9225
# Prevalence                                             0.2074
# Detection Rate                                         0.1448
# Detection Prevalence                                   0.1923
# Balanced Accuracy                                      0.8191
#                      Class: SUV Class: Voitures Familiales
# Sensitivity              0.0000                     0.9168
# Specificity              1.0000                     0.7484
# Pos Pred Value              NaN                     0.5246
# Neg Pred Value           0.8602                     0.9675
# Prevalence               0.1398                     0.2324
# Detection Rate           0.0000                     0.2131
# Detection Prevalence     0.0000                     0.4062
# Balanced Accuracy        0.5000                     0.8326
#                      Class: Voitures de Sport
# Sensitivity                            0.5147
# Specificity                            0.9546
# Pos Pred Value                         0.7391
# Neg Pred Value                         0.8872
# Prevalence                             0.2000
# Detection Rate                         0.1029
# Detection Prevalence                   0.1393
# Balanced Accuracy                      0.7346
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                          0.48553
# Specificity                                          0.99635
# Pos Pred Value                                       0.93794
# Neg Pred Value                                       0.94462
# Prevalence                                           0.10196
# Detection Rate                                       0.04950
# Detection Prevalence                                 0.05278
# Balanced Accuracy                                    0.74094

performance_rp2
# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              3718
#   Véhicules de Luxe / Haut de Gamme                998
#   SUV                                                0
#   Voitures Familiales                               10
#   Voitures de Sport                                 11
#   Véhicules Hybrides / Électriques                   1
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             2469
#   Véhicules de Luxe / Haut de Gamme                              5792
#   SUV                                                               0
#   Voitures Familiales                                              24
#   Voitures de Sport                                                11
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                2189                   2
#   Véhicules de Luxe / Haut de Gamme  443                   5
#   SUV                                  0                   0
#   Voitures Familiales               2171                8522
#   Voitures de Sport                  788                 638
#   Véhicules Hybrides / Électriques     1                 128
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                                2
#   Véhicules de Luxe / Haut de Gamme                 8
#   SUV                                               0
#   Voitures Familiales                            3871
#   Voitures de Sport                              4117
#   Véhicules Hybrides / Électriques                  1
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               1
#   Véhicules de Luxe / Haut de Gamme                                1
#   SUV                                                              0
#   Voitures Familiales                                           1648
#   Voitures de Sport                                                5
#   Véhicules Hybrides / Électriques                              2423

# Overall Statistics
                                          
#                Accuracy : 0.6143          
#                  95% CI : (0.6095, 0.6191)
#     No Information Rate : 0.2324          
#     P-Value [Acc > NIR] : < 2.2e-16       
                                          
#                   Kappa : 0.5232          
                                          
#  Mcnemar's Test P-Value : < 2.2e-16       

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                            0.78472
# Specificity                            0.86775
# Pos Pred Value                         0.44362
# Neg Pred Value                         0.96774
# Prevalence                             0.11846
# Detection Rate                         0.09295
# Detection Prevalence                   0.20954
# Balanced Accuracy                      0.82624
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.6982
# Specificity                                            0.9541
# Pos Pred Value                                         0.7992
# Neg Pred Value                                         0.9235
# Prevalence                                             0.2074
# Detection Rate                                         0.1448
# Detection Prevalence                                   0.1812
# Balanced Accuracy                                      0.8261
#                      Class: SUV Class: Voitures Familiales
# Sensitivity              0.0000                     0.9168
# Specificity              1.0000                     0.7484
# Pos Pred Value              NaN                     0.5246
# Neg Pred Value           0.8602                     0.9675
# Prevalence               0.1398                     0.2324
# Detection Rate           0.0000                     0.2131
# Detection Prevalence     0.0000                     0.4062
# Balanced Accuracy        0.5000                     0.8326
#                      Class: Voitures de Sport
# Sensitivity                            0.5147
# Specificity                            0.9546
# Pos Pred Value                         0.7391
# Neg Pred Value                         0.8872
# Prevalence                             0.2000
# Detection Rate                         0.1029
# Detection Prevalence                   0.1393
# Balanced Accuracy                      0.7346
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                          0.59416
# Specificity                                          0.99635
# Pos Pred Value                                       0.94871
# Neg Pred Value                                       0.95580
# Prevalence                                           0.10196
# Detection Rate                                       0.06058
# Detection Prevalence                                 0.06385
# Balanced Accuracy                                    0.79526

performance_rp3

# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              3718
#   Véhicules de Luxe / Haut de Gamme                999
#   SUV                                                0
#   Voitures Familiales                                9
#   Voitures de Sport                                 11
#   Véhicules Hybrides / Électriques                   1
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             2469
#   Véhicules de Luxe / Haut de Gamme                              5792
#   SUV                                                               0
#   Voitures Familiales                                              24
#   Voitures de Sport                                                11
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                2189                   2
#   Véhicules de Luxe / Haut de Gamme  443                 582
#   SUV                                  0                   0
#   Voitures Familiales               2171                7945
#   Voitures de Sport                  788                 638
#   Véhicules Hybrides / Électriques     1                 128
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                                2
#   Véhicules de Luxe / Haut de Gamme               508
#   SUV                                               0
#   Voitures Familiales                            3371
#   Voitures de Sport                              4117
#   Véhicules Hybrides / Électriques                  1
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               1
#   Véhicules de Luxe / Haut de Gamme                              444
#   SUV                                                              0
#   Voitures Familiales                                           1648
#   Voitures de Sport                                                5
#   Véhicules Hybrides / Électriques                              1980

# Overall Statistics
                                         
#                Accuracy : 0.5888         
#                  95% CI : (0.584, 0.5937)
#     No Information Rate : 0.2324         
#     P-Value [Acc > NIR] : < 2.2e-16      
                                         
#                   Kappa : 0.4914         
                                         
#  Mcnemar's Test P-Value : < 2.2e-16      

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                            0.78472
# Specificity                            0.86775
# Pos Pred Value                         0.44362
# Neg Pred Value                         0.96774
# Prevalence                             0.11846
# Detection Rate                         0.09295
# Detection Prevalence                   0.20954
# Balanced Accuracy                      0.82624
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.6982
# Specificity                                            0.9061
# Pos Pred Value                                         0.6606
# Neg Pred Value                                         0.9198
# Prevalence                                             0.2074
# Detection Rate                                         0.1448
# Detection Prevalence                                   0.2192
# Balanced Accuracy                                      0.8021
#                      Class: SUV Class: Voitures Familiales
# Sensitivity              0.0000                     0.8548
# Specificity              1.0000                     0.7647
# Pos Pred Value              NaN                     0.5238
# Neg Pred Value           0.8602                     0.9456
# Prevalence               0.1398                     0.2324
# Detection Rate           0.0000                     0.1986
# Detection Prevalence     0.0000                     0.3792
# Balanced Accuracy        0.5000                     0.8098
#                      Class: Voitures de Sport
# Sensitivity                            0.5147
# Specificity                            0.9546
# Pos Pred Value                         0.7391
# Neg Pred Value                         0.8872
# Prevalence                             0.2000
# Detection Rate                         0.1029
# Detection Prevalence                   0.1393
# Balanced Accuracy                      0.7346
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                          0.48553
# Specificity                                          0.99635
# Pos Pred Value                                       0.93794
# Neg Pred Value                                       0.94462
# Prevalence                                           0.10196
# Detection Rate                                       0.04950
# Detection Prevalence                                 0.05278
# Balanced Accuracy                                    0.74094

performance_rp4
# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              3718
#   Véhicules de Luxe / Haut de Gamme                999
#   SUV                                                0
#   Voitures Familiales                                9
#   Voitures de Sport                                 11
#   Véhicules Hybrides / Électriques                   1
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             2469
#   Véhicules de Luxe / Haut de Gamme                              4780
#   SUV                                                               0
#   Voitures Familiales                                            1036
#   Voitures de Sport                                                11
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                2189                   2
#   Véhicules de Luxe / Haut de Gamme  443                 582
#   SUV                                  0                   0
#   Voitures Familiales               2171                7945
#   Voitures de Sport                  788                 638
#   Véhicules Hybrides / Électriques     1                 128
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                                2
#   Véhicules de Luxe / Haut de Gamme               506
#   SUV                                               0
#   Voitures Familiales                            3373
#   Voitures de Sport                              4117
#   Véhicules Hybrides / Électriques                  1
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               1
#   Véhicules de Luxe / Haut de Gamme                                1
#   SUV                                                              0
#   Voitures Familiales                                           1648
#   Voitures de Sport                                                5
#   Véhicules Hybrides / Électriques                              2423

# Overall Statistics
                                          
#                Accuracy : 0.5746          
#                  95% CI : (0.5697, 0.5795)
#     No Information Rate : 0.2324          
#     P-Value [Acc > NIR] : < 2.2e-16       
                                          
#                   Kappa : 0.4741          
                                          
#  Mcnemar's Test P-Value : < 2.2e-16       

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                            0.78472
# Specificity                            0.86775
# Pos Pred Value                         0.44362
# Neg Pred Value                         0.96774
# Prevalence                             0.11846
# Detection Rate                         0.09295
# Detection Prevalence                   0.20954
# Balanced Accuracy                      0.82624
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.5762
# Specificity                                            0.9202
# Pos Pred Value                                         0.6538
# Neg Pred Value                                         0.8924
# Prevalence                                             0.2074
# Detection Rate                                         0.1195
# Detection Prevalence                                   0.1828
# Balanced Accuracy                                      0.7482
#                      Class: SUV Class: Voitures Familiales
# Sensitivity              0.0000                     0.8548
# Specificity              1.0000                     0.7317
# Pos Pred Value              NaN                     0.4910
# Neg Pred Value           0.8602                     0.9433
# Prevalence               0.1398                     0.2324
# Detection Rate           0.0000                     0.1986
# Detection Prevalence     0.0000                     0.4046
# Balanced Accuracy        0.5000                     0.7932
#                      Class: Voitures de Sport
# Sensitivity                            0.5147
# Specificity                            0.9546
# Pos Pred Value                         0.7391
# Neg Pred Value                         0.8872
# Prevalence                             0.2000
# Detection Rate                         0.1029
# Detection Prevalence                   0.1393
# Balanced Accuracy                      0.7346
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                          0.59416
# Specificity                                          0.99635
# Pos Pred Value                                       0.94871
# Neg Pred Value                                       0.95580
# Prevalence                                           0.10196
# Detection Rate                                       0.06058
# Detection Prevalence                                 0.06385
# Balanced Accuracy                                    0.79526

library(caret)
library(rpart)
library(randomForest)
library(e1071)
library(nnet)
library(keras)

# Pretraitement des donnees :
# Conversion des colonnes catégorielles en numériques :

newDfClients$sexe <- as.numeric(factor(newDfClients$sexe))
newDfClients$situationfamiliale <- as.numeric(factor(newDfClients$situationfamiliale))
newDfClients$deuxiemevoiture <- as.numeric(factor(newDfClients$deuxiemevoiture))

#Séparation des données en ensembles d'entraînement et de test :
#Le jeu de données est divisé en un ensemble d'entraînement (80%) et un ensemble de test (20%). La graine (seed) est fixée pour garantir la reproductibilité.
set.seed(123)
trainIndex <- createDataPartition(newDfClients$categorie, p = 0.8, list = FALSE)
trainData <- newDfClients[trainIndex,]
testData <- newDfClients[-trainIndex,]

# Suppression des valeurs manquantes dans l'ensemble d'entraînement :
colSums(is.na(trainData))
#    immatriculation                age               sexe 
#                  0                163                  0 
#               taux situationfamiliale   nbenfantsacharge 
#                174                  0                157 
#    deuxiemevoiture             marque                nom 
#                141                  1                  1 
#          puissance           nbplaces           nbportes 
#                  1                  1                  1 
#           longueur            couleur           occasion 
#                  1                  1                  1 
#               prix          categorie 
#                  1                  1 

trainData <- na.omit(trainData)
colSums(is.na(trainData))
#  immatriculation                age               sexe 
#                  0                  0                  0 
#               taux situationfamiliale   nbenfantsacharge 
#                  0                  0                  0 
#    deuxiemevoiture             marque                nom 
#                  0                  0                  0 
#          puissance           nbplaces           nbportes 
#                  0                  0                  0 
#           longueur            couleur           occasion 
#                  0                  0                  0 
#               prix          categorie 
#                  0                  0 

# Les valeurs manquantes sont comptées et ensuite supprimées de l'ensemble d'entraînement.

# Modèles de Classification

# Arbre de décision :
decisionTreeModel <- rpart(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData)
decisionTreePred <- predict(decisionTreeModel, testData, type = "class")
confusionMatrix(decisionTreePred, testData$categorie)

# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              3582
#   Véhicules de Luxe / Haut de Gamme               1028
#   SUV                                                0
#   Voitures Familiales                               22
#   Voitures de Sport                                 26
#   Véhicules Hybrides / Électriques                   0
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             2412
#   Véhicules de Luxe / Haut de Gamme                              5927
#   SUV                                                               0
#   Voitures Familiales                                              58
#   Voitures de Sport                                                20
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                2146                  17
#   Véhicules de Luxe / Haut de Gamme  424                  12
#   SUV                                  0                   0
#   Voitures Familiales               2227                8511
#   Voitures de Sport                  835                 676
#   Véhicules Hybrides / Électriques     0                 139
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                               15
#   Véhicules de Luxe / Haut de Gamme                 5
#   SUV                                               0
#   Voitures Familiales                            3755
#   Voitures de Sport                              4075
#   Véhicules Hybrides / Électriques                  1
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               2
#   Véhicules de Luxe / Haut de Gamme                               16
#   SUV                                                              0
#   Voitures Familiales                                           1593
#   Voitures de Sport                                                4
#   Véhicules Hybrides / Électriques                              2468

# Overall Statistics
                                          
#                Accuracy : 0.6141          
#                  95% CI : (0.6093, 0.6189)
#     No Information Rate : 0.2339          
#     P-Value [Acc > NIR] : < 2.2e-16       
                                          
#                   Kappa : 0.5226          
                                          
#  Mcnemar's Test P-Value : NA              

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                            0.76900
# Specificity                            0.87005
# Pos Pred Value                         0.43822
# Neg Pred Value                         0.96619
# Prevalence                             0.11646
# Detection Rate                         0.08956
# Detection Prevalence                   0.20437
# Balanced Accuracy                      0.81953
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.7042
# Specificity                                            0.9530
# Pos Pred Value                                         0.7996
# Neg Pred Value                                         0.9236
# Prevalence                                             0.2104
# Detection Rate                                         0.1482
# Detection Prevalence                                   0.1853
# Balanced Accuracy                                      0.8286
#                      Class: SUV Class: Voitures Familiales
# Sensitivity              0.0000                     0.9098
# Specificity              1.0000                     0.7502
# Pos Pred Value              NaN                     0.5265
# Neg Pred Value           0.8592                     0.9646
# Prevalence               0.1408                     0.2339
# Detection Rate           0.0000                     0.2128
# Detection Prevalence     0.0000                     0.4042
# Balanced Accuracy        0.5000                     0.8300
#                      Class: Voitures de Sport
# Sensitivity                            0.5190
# Specificity                            0.9514
# Pos Pred Value                         0.7230
# Neg Pred Value                         0.8901
# Prevalence                             0.1963
# Detection Rate                         0.1019
# Detection Prevalence                   0.1409
# Balanced Accuracy                      0.7352
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                          0.60446
# Specificity                                          0.99610
# Pos Pred Value                                       0.94632
# Neg Pred Value                                       0.95680
# Prevalence                                           0.10209
# Detection Rate                                       0.06171
# Detection Prevalence                                 0.06521
# Balanced Accuracy                                    0.80028


# Foret Aleatoire
# Ce modèle utilise 100 arbres pour faire ses prédictions.
randomForestModel <- randomForest(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, ntree = 100)
randomForestPred <- predict(randomForestModel, testData)
confusionMatrix(randomForestPred, testData$categorie)

# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              3593
#   Véhicules de Luxe / Haut de Gamme                795
#   SUV                                              247
#   Voitures Familiales                                3
#   Voitures de Sport                                  2
#   Véhicules Hybrides / Électriques                   0
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             2316
#   Véhicules de Luxe / Haut de Gamme                              5643
#   SUV                                                             413
#   Voitures Familiales                                              14
#   Voitures de Sport                                                 3
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                1848                   2
#   Véhicules de Luxe / Haut de Gamme  356                   9
#   SUV                                440                  79
#   Voitures Familiales               2109                8234
#   Voitures de Sport                  853                 986
#   Véhicules Hybrides / Électriques     0                   8
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                                7
#   Véhicules de Luxe / Haut de Gamme                 2
#   SUV                                              62
#   Voitures Familiales                            3148
#   Voitures de Sport                              4597
#   Véhicules Hybrides / Électriques                  1
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               2
#   Véhicules de Luxe / Haut de Gamme                                3
#   SUV                                                              0
#   Voitures Familiales                                           1687
#   Voitures de Sport                                                3
#   Véhicules Hybrides / Électriques                              2370

# Overall Statistics
                                          
#                Accuracy : 0.6245          
#                  95% CI : (0.6197, 0.6293)
#     No Information Rate : 0.2339          
#     P-Value [Acc > NIR] : < 2.2e-16       
                                          
#                   Kappa : 0.5363          
                                          
#  Mcnemar's Test P-Value : NA              

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                             0.7744
# Specificity                             0.8814
# Pos Pred Value                          0.4625
# Neg Pred Value                          0.9673
# Prevalence                              0.1165
# Detection Rate                          0.0902
# Detection Prevalence                    0.1950
# Balanced Accuracy                       0.8279
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.6727
# Specificity                                            0.9630
# Pos Pred Value                                         0.8289
# Neg Pred Value                                         0.9169
# Prevalence                                             0.2106
# Detection Rate                                         0.1417
# Detection Prevalence                                   0.1709
# Balanced Accuracy                                      0.8178
#                      Class: SUV Class: Voitures Familiales
# Sensitivity             0.07849                     0.8837
# Specificity             0.97660                     0.7719
# Pos Pred Value          0.35455                     0.5419
# Neg Pred Value          0.86614                     0.9560
# Prevalence              0.14073                     0.2339
# Detection Rate          0.01105                     0.2067
# Detection Prevalence    0.03115                     0.3814
# Balanced Accuracy       0.52754                     0.8278
#                      Class: Voitures de Sport
# Sensitivity                            0.5881
# Specificity                            0.9423
# Pos Pred Value                         0.7134
# Neg Pred Value                         0.9036
# Prevalence                             0.1962
# Detection Rate                         0.1154
# Detection Prevalence                   0.1618
# Balanced Accuracy                      0.7652
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                          0.58303
# Specificity                                          0.99975
# Pos Pred Value                                       0.99622
# Neg Pred Value                                       0.95475
# Prevalence                                           0.10205
# Detection Rate                                       0.05950
# Detection Prevalence                                 0.05972
# Balanced Accuracy                                    0.79139


# Réseau de neurones : Le modèle est configuré avec 5 neurones cachés et 100 itérations
nnModel <- nnet(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, size = 5, maxit = 100)

# weights:  71
# initial  value 314843.348698 
# iter  10 value 281363.746490
# iter  20 value 278460.521353
# iter  30 value 278391.914490
# iter  40 value 278384.236122
# iter  50 value 278367.117458
# iter  60 value 278353.662125
# iter  70 value 275908.289167
# iter  80 value 247551.893313
# iter  90 value 230499.323795
# iter 100 value 222208.537797
# final  value 222208.537797 
# stopped after 100 iterations

nnPred <- predict(nnModel, testData, type = "class")
nnPred <- as.factor(nnPred)
testData$categorie <- as.factor(testData$categorie)
levels(nnPred) <- levels(testData$categorie)
confusionMatrix(nnPred, testData$categorie)

# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                                 0
#   Véhicules de Luxe / Haut de Gamme               3928
#   SUV                                              712
#   Voitures Familiales                                0
#   Voitures de Sport                                  0
#   Véhicules Hybrides / Électriques                   0
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                                0
#   Véhicules de Luxe / Haut de Gamme                              6567
#   SUV                                                            1822
#   Voitures Familiales                                               0
#   Voitures de Sport                                                 0
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                   0                   1
#   Véhicules de Luxe / Haut de Gamme 2552                  17
#   SUV                               3054                9300
#   Voitures Familiales                  0                   0
#   Voitures de Sport                    0                   0
#   Véhicules Hybrides / Électriques     0                   0
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                                0
#   Véhicules de Luxe / Haut de Gamme                18
#   SUV                                            7799
#   Voitures Familiales                               0
#   Voitures de Sport                                 0
#   Véhicules Hybrides / Électriques                  0
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               0
#   Véhicules de Luxe / Haut de Gamme                                8
#   SUV                                                           4057
#   Voitures Familiales                                              0
#   Voitures de Sport                                                0
#   Véhicules Hybrides / Électriques                                 0

# Overall Statistics
                                          
#                Accuracy : 0.2415          
#                  95% CI : (0.2373, 0.2458)
#     No Information Rate : 0.2339          
#     P-Value [Acc > NIR] : 0.0001798       
                                          
#                   Kappa : 0.0931          
                                          
#  Mcnemar's Test P-Value : NA              

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                          0.0000000
# Specificity                          0.9999716
# Pos Pred Value                       0.0000000
# Neg Pred Value                       0.8835166
# Prevalence                           0.1164805
# Detection Rate                       0.0000000
# Detection Prevalence                 0.0000251
# Balanced Accuracy                    0.4999858
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.7828
# Specificity                                            0.7926
# Pos Pred Value                                         0.5017
# Neg Pred Value                                         0.9319
# Prevalence                                             0.2106
# Detection Rate                                         0.1649
# Detection Prevalence                                   0.3286
# Balanced Accuracy                                      0.7877
#                      Class: SUV Class: Voitures Familiales
# Sensitivity             0.54477                     0.0000
# Specificity             0.30790                     1.0000
# Pos Pred Value          0.11419                        NaN
# Neg Pred Value          0.80506                     0.7661
# Prevalence              0.14073                     0.2339
# Detection Rate          0.07667                     0.0000
# Detection Prevalence    0.67137                     0.0000
# Balanced Accuracy       0.42634                     0.5000
#                      Class: Voitures de Sport
# Sensitivity                            0.0000
# Specificity                            1.0000
# Pos Pred Value                            NaN
# Neg Pred Value                         0.8038
# Prevalence                             0.1962
# Detection Rate                         0.0000
# Detection Prevalence                   0.0000
# Balanced Accuracy                      0.5000
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                            0.000
# Specificity                                            1.000
# Pos Pred Value                                           NaN
# Neg Pred Value                                         0.898
# Prevalence                                             0.102
# Detection Rate                                         0.000
# Detection Prevalence                                   0.000
# Balanced Accuracy                                      0.500

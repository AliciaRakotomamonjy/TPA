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
#Résultats 
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

performance_rp1
#Résultats 
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
#Résultats 
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
#Résultats
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
#Résultats 
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

#Erreur dans na.fail.default(list(categorie = c(4L, 4L, 3L, 3L, 1L, 1L, 1L,  : 
#   valeurs manquantes dans l'objet

colSums(is.na(trainData))
trainData <- na.omit(trainData)
colSums(is.na(trainData))

# Modèle de Forêt Aléatoire
randomForestModel <- randomForest(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, ntree = 100)
randomForestPred <- predict(randomForestModel, testData)
confusionMatrix(randomForestPred, testData$categorie)
#Résultats 
# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              3669
#   Véhicules de Luxe / Haut de Gamme                819
#   SUV                                              218
#   Voitures Familiales                                6
#   Voitures de Sport                                  6
#   Véhicules Hybrides / Électriques                   1
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             2446
#   Véhicules de Luxe / Haut de Gamme                              5539
#   SUV                                                             262
#   Voitures Familiales                                              11
#   Voitures de Sport                                                 8
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                1888                   2
#   Véhicules de Luxe / Haut de Gamme  457                   7
#   SUV                                367                 103
#   Voitures Familiales               2040                8115
#   Voitures de Sport                  816                1027
#   Véhicules Hybrides / Électriques     1                  12
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                                6
#   Véhicules de Luxe / Haut de Gamme                 6
#   SUV                                              61
#   Voitures Familiales                            3253
#   Voitures de Sport                              4631
#   Véhicules Hybrides / Électriques                  3
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               1
#   Véhicules de Luxe / Haut de Gamme                                1
#   SUV                                                              0
#   Voitures Familiales                                           1710
#   Voitures de Sport                                                3
#   Véhicules Hybrides / Électriques                              2348

# Overall Statistics
                                          
#                Accuracy : 0.6192          
#                  95% CI : (0.6144, 0.6239)
#     No Information Rate : 0.2326          
#     P-Value [Acc > NIR] : < 2.2e-16       
                                          
#                   Kappa : 0.5299          
                                          
#  Mcnemar's Test P-Value : < 2.2e-16       

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                            0.77750
# Specificity                            0.87635
# Pos Pred Value                         0.45794
# Neg Pred Value                         0.96701
# Prevalence                             0.11844
# Detection Rate                         0.09209
# Detection Prevalence                   0.20109
# Balanced Accuracy                      0.82692
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.6701
# Specificity                                            0.9591
# Pos Pred Value                                         0.8111
# Neg Pred Value                                         0.9174
# Prevalence                                             0.2075
# Detection Rate                                         0.1390
# Detection Prevalence                                   0.1714
# Balanced Accuracy                                      0.8146
#                      Class: SUV Class: Voitures Familiales
# Sensitivity            0.065901                     0.8758
# Specificity            0.981210                     0.7704
# Pos Pred Value         0.363007                     0.5362
# Neg Pred Value         0.866038                     0.9534
# Prevalence             0.139774                     0.2326
# Detection Rate         0.009211                     0.2037
# Detection Prevalence   0.025375                     0.3799
# Balanced Accuracy      0.523555                     0.8231
#                      Class: Voitures de Sport
# Sensitivity                            0.5818
# Specificity                            0.9417
# Pos Pred Value                         0.7134
# Neg Pred Value                         0.9002
# Prevalence                             0.1998
# Detection Rate                         0.1162
# Detection Prevalence                   0.1629
# Balanced Accuracy                      0.7617
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                          0.57790
# Specificity                                          0.99952
# Pos Pred Value                                       0.99281
# Neg Pred Value                                       0.95424
# Prevalence                                           0.10198
# Detection Rate                                       0.05893
# Detection Prevalence                                 0.05936
# Balanced Accuracy                                    0.78871


# Nettoyage et préparation des données (pour les réseaux de neurones)
newDfClients$sexe <- as.numeric(factor(newDfClients$sexe))
newDfClients$situationfamiliale <- as.numeric(factor(newDfClients$situationfamiliale))
newDfClients$deuxiemevoiture <- as.numeric(factor(newDfClients$deuxiemevoiture))

set.seed(123)
trainIndex <- createDataPartition(newDfClients$categorie, p = 0.8, list = FALSE)
trainData <- newDfClients[trainIndex, ]
testData <- newDfClients[-trainIndex, ]


# Modèle de Réseau de Neurones
nnModel <- nnet(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = trainData, size = 5, maxit = 100)
nnPred <- predict(nnModel, testData, type = "class")
nnPred <- as.factor(nnPred)
testData$categorie <- as.factor(testData$categorie)
levels(nnPred) <- levels(testData$categorie)
confusionMatrix(nnPred, testData$categorie)
 #Résultats
#  Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              4623
#   Véhicules de Luxe / Haut de Gamme                  7
#   SUV                                                0
#   Voitures Familiales                               10
#   Voitures de Sport                                  0
#   Véhicules Hybrides / Électriques                   0
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme
#   Voitures Citadines                                             3894
#   Véhicules de Luxe / Haut de Gamme                              4485
#   SUV                                                               0
#   Voitures Familiales                                              10
#   Voitures de Sport                                                 0
#   Véhicules Hybrides / Électriques                                  0
#                                    Reference
# Prediction                           SUV Voitures Familiales
#   Voitures Citadines                4951                2883
#   Véhicules de Luxe / Haut de Gamme  436                3069
#   SUV                                  0                 204
#   Voitures Familiales                212                2969
#   Voitures de Sport                    7                 193
#   Véhicules Hybrides / Électriques     0                   0
#                                    Reference
# Prediction                          Voitures de Sport
#   Voitures Citadines                             4303
#   Véhicules de Luxe / Haut de Gamme                14
#   SUV                                               1
#   Voitures Familiales                            3346
#   Voitures de Sport                               153
#   Véhicules Hybrides / Électriques                  0
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                               8
#   Véhicules de Luxe / Haut de Gamme                             1546
#   SUV                                                           2481
#   Voitures Familiales                                              4
#   Voitures de Sport                                               26
#   Véhicules Hybrides / Électriques                                 0

# Overall Statistics
                                          
#                Accuracy : 0.307           
#                  95% CI : (0.3025, 0.3116)
#     No Information Rate : 0.2339          
#     P-Value [Acc > NIR] : < 2.2e-16       
                                          
#                   Kappa : 0.1743          
                                          
#  Mcnemar's Test P-Value : < 2.2e-16       

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                             0.9963
# Specificity                             0.5443
# Pos Pred Value                          0.2237
# Neg Pred Value                          0.9991
# Prevalence                              0.1165
# Detection Rate                          0.1161
# Detection Prevalence                    0.5187
# Balanced Accuracy                       0.7703
#                      Class: Véhicules de Luxe / Haut de Gamme
# Sensitivity                                            0.5346
# Specificity                                            0.8387
# Pos Pred Value                                         0.4693
# Neg Pred Value                                         0.8711
# Prevalence                                             0.2106
# Detection Rate                                         0.1126
# Detection Prevalence                                   0.2399
# Balanced Accuracy                                      0.6867
#                      Class: SUV Class: Voitures Familiales
# Sensitivity             0.00000                    0.31863
# Specificity             0.92153                    0.88262
# Pos Pred Value          0.00000                    0.45321
# Neg Pred Value          0.84909                    0.80925
# Prevalence              0.14073                    0.23391
# Detection Rate          0.00000                    0.07453
# Detection Prevalence    0.06743                    0.16445
# Balanced Accuracy       0.46076                    0.60063
#                      Class: Voitures de Sport
# Sensitivity                          0.019573
# Specificity                          0.992941
# Pos Pred Value                       0.403694
# Neg Pred Value                       0.805758
# Prevalence                           0.196234
# Detection Rate                       0.003841
# Detection Prevalence                 0.009514
# Balanced Accuracy                    0.506257
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                            0.000
# Specificity                                            1.000
# Pos Pred Value                                           NaN
# Neg Pred Value                                         0.898
# Prevalence                                             0.102
# Detection Rate                                         0.000
# Detection Prevalence                                   0.000
# Balanced Accuracy                                      0.500
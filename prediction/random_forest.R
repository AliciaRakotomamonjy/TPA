newDfClients <- merge(x = clients, y = joined_immatriculations_catalogue, by = "immatriculation",all.x = T)
str(newDfClients)

library(randomForest)
library(lattice)
library(caret) # Pour la fonction confusionMatrix

# Supprimer les lignes avec des valeurs manquantes
cleaned_data <- na.omit(newDfClients)

set.seed(123)
train_indices <- createDataPartition(cleaned_data$categorie, p = 0.7, list = FALSE)
train_data <- cleaned_data[train_indices, ]
test_data <- cleaned_data[-train_indices, ]

rf_model <- randomForest(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, 
                         data = train_data, 
                         ntree = 100, 
                         mtry = 3)

predictions <- predict(rf_model, test_data)
conf_matrix <- confusionMatrix(predictions, test_data$categorie)

print(conf_matrix) #0.6071 

marketing <- dbGetQuery(conn, "SELECT age,sexe,taux,situationFamiliale,nbenfantsacharge,deuxiemevoiture FROM marketing_kv_h_ext")

str(marketing)

marketing_predictions <- predict(rf_model, marketing)
marketing$predicted_categorie <- marketing_predictions

write.csv(marketing, file = "marketing.csv", row.names = FALSE)
getwd()


library(RMySQL)
library(DBI)
library(readr)

conmyssql <- dbConnect(RMySQL::MySQL(), 
                 dbname = "automobile", 
                 host = "localhost", 
                 port = 3306, 
                 user = "root", 
                 password = "")

datas <- read_csv("marketing.csv")

dbWriteTable(conmyssql, name = "marketing", value = datas, append = TRUE, row.names = FALSE)

# Confusion Matrix and Statistics

#                                    Reference
# Prediction                          Voitures Citadines
#   Voitures Citadines                              9360
#   Véhicules de Luxe / Haut de Gamme                  2
#   SUV                                             1911
#   Voitures Familiales                              934
#   Voitures de Sport                                134
#   Véhicules Hybrides / Électriques                 221
#                                    Reference
# Prediction                          Véhicules de Luxe / Haut de Gamme   SUV
#   Voitures Citadines                                               11  1544
#   Véhicules de Luxe / Haut de Gamme                              6791   408
#   SUV                                                            4315 12318
#   Voitures Familiales                                             347  2712
#   Voitures de Sport                                                 0    19
#   Véhicules Hybrides / Électriques                                  1    24
#                                    Reference
# Prediction                          Voitures Familiales Voitures de Sport
#   Voitures Citadines                                694               290
#   Véhicules de Luxe / Haut de Gamme                1542                 0
#   SUV                                              4859               165
#   Voitures Familiales                              7605               268
#   Voitures de Sport                                  31                84
#   Véhicules Hybrides / Électriques                   16                34
#                                    Reference
# Prediction                          Véhicules Hybrides / Électriques
#   Voitures Citadines                                            1560
#   Véhicules de Luxe / Haut de Gamme                                1
#   SUV                                                            914
#   Voitures Familiales                                            481
#   Voitures de Sport                                               43
#   Véhicules Hybrides / Électriques                               118

# Overall Statistics
                                         
#                Accuracy : 0.6071         
#                  95% CI : (0.6031, 0.611)
#     No Information Rate : 0.2849         
#     P-Value [Acc > NIR] : < 2.2e-16      
                                         
#                   Kappa : 0.4805         
                                         
#  Mcnemar's Test P-Value : NA             

# Statistics by Class:

#                      Class: Voitures Citadines
# Sensitivity                             0.7451
# Specificity                             0.9131
# Pos Pred Value                          0.6954
# Neg Pred Value                          0.9308
# Prevalence                              0.2102
# Detection Rate                          0.1566
# Detection Prevalence                    0.2252
# Balanced Accuracy                       0.8291
#                      Class: Véhicules de Luxe / Haut de Gamme Class: SUV
# Sensitivity                                            0.5923     0.7235
# Specificity                                            0.9596     0.7153
# Pos Pred Value                                         0.7766     0.5031
# Neg Pred Value                                         0.9084     0.8666
# Prevalence                                             0.1919     0.2849
# Detection Rate                                         0.1136     0.2061
# Detection Prevalence                                   0.1463     0.4097
# Balanced Accuracy                                      0.7759     0.7194
#                      Class: Voitures Familiales Class: Voitures de Sport
# Sensitivity                              0.5157                 0.099881
# Specificity                              0.8946                 0.996147
# Pos Pred Value                           0.6159                 0.270096
# Neg Pred Value                           0.8494                 0.987266
# Prevalence                               0.2468                 0.014074
# Detection Rate                           0.1273                 0.001406
# Detection Prevalence                     0.2066                 0.005204
# Balanced Accuracy                        0.7052                 0.548014
#                      Class: Véhicules Hybrides / Électriques
# Sensitivity                                         0.037857
# Specificity                                         0.994774
# Pos Pred Value                                      0.285024
# Neg Pred Value                                      0.949463
# Prevalence                                          0.052161
# Detection Rate                                      0.001975
# Detection Prevalence                                0.006928
# Balanced Accuracy                                   0.516315
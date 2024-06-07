newDfClients <- merge(x = clients, y = joined_immatriculations_catalogue, by = "immatriculation",all.x = T)
str(newDfClients)

library(e1071)
library(caret)

data <- newDfClients[, c("age", "sexe", "taux", "situationfamiliale", "nbenfantsacharge", "deuxiemevoiture", "categorie")]

data$categorie <- as.factor(data$categorie)

set.seed(123)  # Pour la reproductibilité
index <- createDataPartition(data$categorie, p = 0.8, list = FALSE)
train_data <- data[index, ]
test_data <- data[-index, ]

svm_model <- svm(categorie ~ ., data = train_data, kernel = "radial", cost = 1, gamma = 0.1)

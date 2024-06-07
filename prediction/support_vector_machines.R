newDfClients <- merge(x = clients, y = joined_immatriculations_catalogue, by = "immatriculation",all.x = T)
str(newDfClients)

library(e1071)

set.seed(123)
train_index <- sample(1:nrow(newDfClients), 0.8*nrow(newDfClients))
train_data <- newDfClients[train_index, ]
test_data <- newDfClients[-train_index, ]

svm_model <- svm(categorie ~ age + sexe + taux + situationfamiliale + nbenfantsacharge + deuxiemevoiture, data = train_data, kernel = "linear")


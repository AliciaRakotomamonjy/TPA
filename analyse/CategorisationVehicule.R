# hive_jdbc_jar <- "F:/informatiqueMendrika/projectM2/hive/jar/hive-jdbc-3.1.3-standalone.jar" 

# Etape 2 : Identification des catégories de véhicules

catalogue <- dbGetQuery(conn, "select marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from CATALOGUE_MDB_EXT")

str(catalogue)

# Factorisation des caractères pour un bon traitement des données 
# Factorisation de la colonne marque 

catalogue$`marque` <- as.factor(catalogue$`marque`)

# Factorisation de la colonne nom

catalogue$`nom` <- as.factor(catalogue$`nom`)

# Factorisation de la colonne longueur

catalogue$`longueur` <- as.factor(catalogue$`longueur`)

# Factorisation de la colonne couleur 

catalogue$`couleur` <- as.factor(catalogue$`couleur`)

# Factorisation de la colonne occasion
catalogue$`occasion` <- as.factor(catalogue$`occasion`) 

str(catalogue)

# Résultats 
# 'data.frame':	270 obs. of  10 variables:
#  $ catalogue_mdb_ext.id       : chr  "665aebd15eab53512d2be54a" "665aebd15eab53512d2be54b" "665aebd15eab53512d2be54c" "665aebd15eab53512d2be54d" ...
#  $ marque   : Factor w/ 21 levels "Audi","BMW","Dacia",..: 21 21 21 21 21 21 21 21 21 21 ...
#  $ nom      : Factor w/ 32 levels "1007 1.4","120i",..: 26 26 26 26 26 26 26 26 26 26 ...
#  $ puissance: num  272 272 272 272 272 272 272 272 272 272 ...
#  $ longueur : Factor w/ 4 levels "courte","longue",..: 4 4 4 4 4 4 4 4 4 4 ...
#  $ nbplaces : num  5 5 5 5 5 5 5 5 5 5 ...
#  $ nbportes : num  5 5 5 5 5 5 5 5 5 5 ...
#  $ couleur  : Factor w/ 5 levels "blanc","bleu",..: 1 4 5 3 2 2 5 1 4 3 ...
#  $ occasion : Factor w/ 2 levels "false","true": 1 1 1 2 2 1 2 2 2 1 ...
#  $ prix     : num  50500 50500 50500 35350 35350 ...

# install.packages("ggplot2")
library(ggplot2)

# Répartition des données de la colonne puissance 
  ggplot(catalogue, aes(x = catalogue$puissance)) +
  geom_histogram(binwidth = 20, fill = "darkgrey", color = "black", alpha = 0.7) +
  geom_text(stat = "bin", aes(label = ..count..), vjust = -0.5, size = 3, binwidth = 20) +
  labs(title = "Distribution Détaillée de la Puissance des Véhicules",
       x = "Puissance (CV)",
       y = "Fréquence") +
  theme_minimal() +
  theme(
    panel.grid.major.y = element_line(color = "lightgrey"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(color = "lightgrey"),
    panel.grid.minor.x = element_blank(),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12),
    axis.text.x = element_text(angle = 0, hjust = 0.5)  # Texte horizontal et centré
  ) +
  scale_x_continuous(breaks = seq(0, max(catalogue$puissance, na.rm = TRUE) + 50, by = 100)) +
  scale_y_continuous(expand = c(0, 0))

# Résultats => aucune incohérence 

# Répartition des données de la colonne longueur 

if (max(as.numeric(catalogue$longueur) , na.rm = TRUE) > 100) {
  catalogue$longueur <- catalogue$longueur / 1000
  unite <- "m"
} else {
  unite <- "m"  
}

longueur_freq <- table(catalogue$`longueur`)

longueur_df <- as.data.frame(longueur_freq)
names(longueur_df) <- c("Longueur", "Fréquence")

ggplot(longueur_df, aes(x = Longueur, y = Fréquence)) +
  geom_bar(stat = "identity", 
          fill = "gray",  # Bleu uniforme
          color = "gray",   # Bordure noire pour une meilleure visibilité
          width = 0.7) +    # Largeur des barres à 70% pour un meilleur espacement
  labs(title = "Distribution de la Longueur des Véhicules",
       x = "",
       y = "Nombre de Véhicules") +
  theme_minimal() +
  theme(
    panel.grid.major.y = element_line(color = "lightgrey"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14),
    axis.text.x = element_text(angle = 0, hjust = 0.5, size = 12, face = "bold"),  # Texte en gras
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Titre centré et en gras
    plot.margin = unit(c(1, 1, 1, 1), "cm")  # Marges autour du graphique
  ) +
  scale_y_continuous(expand = c(0, 0), 
                   limits = c(0, max(longueur_df$Fréquence) * 1.1),
                   breaks = seq(0, max(longueur_df$Fréquence), by = 100))

# Résultats => aucune incohérence

# Répartition des données de la colonne nbPlace 

ggplot(catalogue, aes(x = nbplaces)) +
  geom_histogram(binwidth = 1, fill = "darkgrey", color = "black", alpha = 0.7) +
  geom_text(stat = "bin", aes(label =..count..), vjust = -0.5, size = 3, binwidth = 1) +
  labs(title = "Répartition des Nombres de Places par Véhicule",
       x = "Nombres de Places",
       y = "Fréquence") +
  theme_minimal() +
  theme(
    panel.grid.major.y = element_line(color = "lightgrey"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(color = "lightgrey"),
    panel.grid.minor.x = element_blank(),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12) 
  ) +
  scale_x_continuous(breaks = seq(min(catalogue$nbplaces, na.rm = TRUE), max(catalogue$nbplaces, na.rm = TRUE) + 1, by = 1)) +
  scale_y_continuous(expand = c(0, 0))

# Résultats => aucune incohérence


# Répartition des données de la colonne nbPorte

ggplot(catalogue, aes(x = nbportes)) +
  geom_histogram(binwidth = 1, fill = "darkgrey", color = "black", alpha = 0.7) +
  geom_text(stat = "bin", aes(label =..count..), vjust = -0.5, size = 3, binwidth = 1) +
  labs(title = "Répartition des Nombres de Portes par Véhicule",
       x = "Nombres de Portes",
       y = "Fréquence") +
  theme_minimal() +
  theme(
    panel.grid.major.y = element_line(color = "lightgrey"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(color = "lightgrey"),
    panel.grid.minor.x = element_blank(),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12) 
  ) +
  scale_x_continuous(breaks = seq(min(catalogue$nbportes, na.rm = TRUE), max(catalogue$nbportes, na.rm = TRUE) + 1, by = 1)) +
  scale_y_continuous(expand = c(0, 0))
  

# Mettre les colonnes nbPlaces, nbPortes, longueur en ordinal 

catalogue$`nbplaces` <- as.factor(as.numeric(catalogue$`nbplaces`))
catalogue$`nbplaces` <- factor(catalogue$`nbplaces`, ordered = TRUE, levels = sort(unique(catalogue$`nbplaces`)))

catalogue$`nbportes` <- as.factor(as.numeric(catalogue$`nbportes`))
catalogue$`nbportes` <- factor(catalogue$`nbportes`, ordered = TRUE, levels = sort(unique(catalogue$`nbportes`)))

catalogue$`longueur` <- factor(catalogue$`longueur`, levels = c("courte", "moyenne", "longue", "tr�s longue"), ordered = TRUE)

# Vérification de la corrélation entre les variables 

pairs(catalogue[,c("longueur", "puissance", "prix", "nbplaces", "nbportes", "couleur", "marque", "occasion")])

# Résultats : Il n'y a pas de motif clair dans les diagrammes de dispersion impliquant la couleur. Cela suggère que la couleur n'a pas d'impact significatif sur les autres variables.

# Enlever la variable couleur 

catalogueTraitement <- catalogue
catalogueTraitement$couleur <- NULL 
str(catalogueTraitement)

# Utilisation de K-means en variant le nombre de cluster 

# install.packages("cluster")
library(cluster)

dataMatrix <- daisy(catalogueTraitement)
summary(dataMatrix)

# install.packages("tsne")
library(tsne)

tsne_out <- tsne(dataMatrix, k=2)
tsne_out <- data.frame(tsne_out)
set.seed(10000)

for(k in 2:10) {
  km <- kmeans(dataMatrix, k)
  print(qplot(tsne_out[,1], tsne_out[,2], col=as.factor(km$cluster)))
}

# Résultats : K=6 : Données mieux séparées et détaillées, facilitation de l'analyse 

# Evaluation du nombre de cluster choisi K=6

kmeans6 <- kmeans(dataMatrix, 6)

qplot(longueur, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
qplot(puissance, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
qplot(nbportes, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
qplot(nbplaces, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
qplot(prix, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
qplot(occasion, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)

# Interprétation pour k=6 => Catégorisation des véhicules
# Cluster 1 :
# Interprétation : Voitures Citadines
# Caractéristiques : Petite taille, économie de carburant

# Cluster 2 :
# Interprétation : Véhicules de Luxe / Haut de Gamme
# Caractéristiques : Prix élevé, haute technologie

# Cluster 3 :

# Interprétation : SUV
# Caractéristiques : Garde au sol élevée, espace intérieur, polyvalence
# La dispersion suggère une large gamme : du compact au grand luxe

# Cluster 4 :

# Interprétation : Voitures Familiales
# Caractéristiques : Espace, confort, équilibre performance/économie

# Cluster 5 :

# Interprétation : Voitures de Sport
# Caractéristiques : Puissance élevée, maniabilité, design aérodynamique
# Proche du cluster Luxe, suggérant un chevauchement (pensez supercars)


# Cluster 6 :

# Interprétation : Véhicules Hybrides / Électriques
# Caractéristiques : Faibles émissions, nouvelles technologies, efficacité
# Au centre, suggérant des caractéristiques partagées avec d'autres catégories

# Ajout colonne catégorie dans les données du catalogue 

catalogue$categorie <- factor(kmeans6$cluster, levels=c(1,2,3,4,5,6), labels=c("Voitures Citadines", "Véhicules de Luxe / Haut de Gamme", "SUV", "Voitures Familiales", "Voitures de Sport", "Véhicules Hybrides / Électriques"))
table(catalogue$categorie)

# Copie du dataframe catalogue pour usage ultérieur
catalogueNew <- catalogue

# Etape 3 : Association des catégories aux immatriculations
immatriculations <- dbGetQuery(conn, "select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext")
str(immatriculations)

table(immatriculations$longueur)
catalogue$prix <- NULL

immatriculations$nbplaces <- factor(immatriculations$nbplaces,levels = c(5,7),ordered = TRUE)
immatriculations$longueur <- factor(immatriculations$`longueur`, levels = c("courte", "moyenne", "longue", "tr�s longue"), ordered = TRUE)
immatriculations$nbportes <- factor(immatriculations$nbportes,ordered = TRUE)

# install.packages("dplyr")
library(dplyr)
joined_immatriculations_catalogue <- inner_join(immatriculations,catalogue,by= c("nbplaces","marque","nom","puissance","longueur","nbportes","couleur","occasion"))
str(joined_immatriculations_catalogue)
count(joined_immatriculations_catalogue)

table(joined_immatriculations_catalogue$categorie)
qplot(categorie,data = catalogue)

# Etape 4 : Fusion clients et immatriculations

joined_immatriculations_catalogue <- joined_immatriculations_catalogue[!duplicated(joined_immatriculations_catalogue$immatriculation),]

clients <- dbGetQuery(conn, "select immatriculation, age, sexe, taux, situationfamiliale, nbenfantsacharge, deuxiemevoiture from clients_union");
str(clients)

newDfClients <- merge(x = clients, y = joined_immatriculations_catalogue, by = "immatriculation",all.x = T)
str(newDfClients)

# Diagramme des effectifs des categories
qplot(categorie, data = newDfClients,main = "Distributions des catégories sur les clients")


# install.packages("rpart")
# install.packages("rpart.plot")
# library(rpart)
# library(rpart.plot)
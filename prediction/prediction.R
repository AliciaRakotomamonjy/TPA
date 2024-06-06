 scale_y_continuous(expand = c(0, 0), 
+                        limits = c(0, max(longueur_df$Fréquence) * 1.1),
+                        breaks = seq(0, max(longueur_df$Fréquence), by = 100))
> 
> # Résultats => aucune incohérence
> 
> # Répartition des données de la colonne nbPlace 
> 
> ggplot(catalogue, aes(x = nbplaces)) +
+     geom_histogram(binwidth = 1, fill = "darkgrey", color = "black", alpha = 0.7) +
+     geom_text(stat = "bin", aes(label =..count..), vjust = -0.5, size = 3, binwidth = 1) +
+     labs(title = "Répartition des Nombres de Places par Véhicule",
+          x = "Nombres de Places",
+          y = "Fréquence") +
+     theme_minimal() +
+     theme(
+         panel.grid.major.y = element_line(color = "lightgrey"),
+         panel.grid.minor.y = element_blank(),
+         panel.grid.major.x = element_line(color = "lightgrey"),
+         panel.grid.minor.x = element_blank(),
+         axis.text = element_text(size = 10),
+         axis.title = element_text(size = 12) 
+     ) +
+     scale_x_continuous(breaks = seq(min(catalogue$nbplaces, na.rm = TRUE), max(catalogue$nbplaces, na.rm = TRUE) + 1, by = 1)) +
+     scale_y_continuous(expand = c(0, 0))
> 
> # Résultats => aucune incohérence
> 
> 
> # Répartition des données de la colonne nbPorte
> 
> ggplot(catalogue, aes(x = nbportes)) +
+     geom_histogram(binwidth = 1, fill = "darkgrey", color = "black", alpha = 0.7) +
+     geom_text(stat = "bin", aes(label =..count..), vjust = -0.5, size = 3, binwidth = 1) +
+     labs(title = "Répartition des Nombres de Places par Véhicule",
+          x = "Nombres de Places",
+          y = "Fréquence") +
+     theme_minimal() +
+     theme(
+         panel.grid.major.y = element_line(color = "lightgrey"),
+         panel.grid.minor.y = element_blank(),
+         panel.grid.major.x = element_line(color = "lightgrey"),
+         panel.grid.minor.x = element_blank(),
+         axis.text = element_text(size = 10),
+         axis.title = element_text(size = 12) 
+     ) +
+     scale_x_continuous(breaks = seq(min(catalogue$nbportes, na.rm = TRUE), max(catalogue$nbportes, na.rm = TRUE) + 1, by = 1)) +
+     scale_y_continuous(expand = c(0, 0))
> 
> catalogue$`nbplaces` <- as.factor(as.numeric(catalogue$`nbplaces`))
> catalogue$`nbplaces` <- factor(catalogue$`nbplaces`, ordered = TRUE, levels = sort(unique(catalogue$`nbplaces`)))
> 
> catalogue$`nbportes` <- as.factor(as.numeric(catalogue$`nbportes`))
> catalogue$`nbportes` <- factor(catalogue$`nbportes`, ordered = TRUE, levels = sort(unique(catalogue$`nbportes`)))
> 
> catalogue$`longueur` <- factor(catalogue$`longueur`, levels = c("courte", "moyenne", "longue", "tr�s longue"), ordered = TRUE)
> 
> pairs(catalogue[,c("longueur", "puissance", "prix", "nbplaces", "nbportes", "couleur", "marque", "occasion")])
> 
> catalogueTraitement <- catalogue
> catalogueTraitement$couleur <- NULL 
> str(catalogueTraitement)
'data.frame':	270 obs. of  8 variables:
 $ marque   : Factor w/ 21 levels "Audi","BMW","Dacia",..: 21 21 21 21 21 21 21 21 21 20 ...
 $ nom      : Factor w/ 32 levels "1007 1.4","120i",..: 26 26 26 26 26 26 26 26 26 29 ...
 $ puissance: num  272 272 272 272 272 272 272 272 272 150 ...
 $ nbplaces : Ord.factor w/ 2 levels "5"<"7": 1 1 1 1 1 1 1 1 1 2 ...
 $ nbportes : Ord.factor w/ 2 levels "3"<"5": 2 2 2 2 2 2 2 2 2 2 ...
 $ longueur : Ord.factor w/ 4 levels "courte"<"moyenne"<..: 4 4 4 4 4 4 4 4 4 3 ...
 $ occasion : Factor w/ 2 levels "false","true": 1 1 1 2 2 1 1 2 2 1 ...
 $ prix     : num  50500 50500 50500 35350 35350 ...
> library(cluster)
> 
> dataMatrix <- daisy(catalogueTraitement)
> summary(dataMatrix)
36315 dissimilarities, summarized :
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.0000  0.3568  0.4368  0.4389  0.5194  0.8649 
Metric :  mixed ;  Types = N, N, I, O, O, O, N, I 
Number of objects : 270
> 
> install.packages("tsne")
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding:

https://cran.rstudio.com/bin/windows/Rtools/
essai de l'URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/tsne_0.1-3.1.zip'
Content type 'application/zip' length 24119 bytes (23 KB)
downloaded 23 KB

le package ‘tsne’ a été décompressé et les sommes MD5 ont été vérifiées avec succés

Les packages binaires téléchargés sont dans
	C:\Users\tsiory\AppData\Local\Temp\Rtmpo9s3qI\downloaded_packages
> library(tsne)
> 
> tsne_out <- tsne(dataMatrix, k=2)
sigma summary: Min. : 0.260563879141514 |1st Qu. : 0.268801404491008 |Median : 0.278474953151435 |Mean : 0.284249415567324 |3rd Qu. : 0.294991961380526 |Max. : 0.326226106256929 |
Epoch: Iteration #100 error is: 14.4733086062214
Epoch: Iteration #200 error is: 0.133901104173422
Epoch: Iteration #300 error is: 0.122745146915544
Epoch: Iteration #400 error is: 0.122062111625124
Epoch: Iteration #500 error is: 0.122061197179629
Epoch: Iteration #600 error is: 0.122061038378317
Epoch: Iteration #700 error is: 0.122061014357435
Epoch: Iteration #800 error is: 0.122061010685197
Epoch: Iteration #900 error is: 0.122061010137961
Epoch: Iteration #1000 error is: 0.122061010052224
> tsne_out <- data.frame(tsne_out)
> set.seed(10000)
> 
> for(k in 2:10) {
+     km <- kmeans(dataMatrix, k)
+     print(qplot(tsne_out[,1], tsne_out[,2], col=as.factor(km$cluster)))
+ }
Message d'avis :
`qplot()` was deprecated in ggplot2 3.4.0.
This warning is displayed once every 8 hours.
Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated. 
> 
> catalogue$categorie <- factor(kmeans6$cluster, levels=c(1,2,3,4,5,6), labels=c("Voitures Citadines", "Véhicules de Luxe / Haut de Gamme", "SUV", "Voitures Familiales", "Voitures de Sport", "Véhicules Hybrides / Électriques"))
Erreur : objet 'kmeans6' introuvable
> 
> kmeans6 <- kmeans(dataMatrix, 6)
> 
> qplot(longueur, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(puissance, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(nbportes, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(nbplaces, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(prix, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(occasion, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> 
> catalogue$categorie <- factor(kmeans6$cluster, levels=c(1,2,3,4,5,6), labels=c("Voitures Citadines", "Véhicules de Luxe / Haut de Gamme", "SUV", "Voitures Familiales", "Voitures de Sport", "Véhicules Hybrides / Électriques"))
> table(catalogue$categorie)

               Voitures Citadines Véhicules de Luxe / Haut de Gamme 
                               35                                40 
                              SUV               Voitures Familiales 
                               85                                85 
                Voitures de Sport  Véhicules Hybrides / Électriques 
                               10                                15 
> catalogueNew <- catalogue
> immatriculations <- dbGetQuery(conn, "select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext")
Erreur dans .jcall(rp, "I", "fetch", stride, block) : 
  java.sql.SQLException: Error retrieving next row
> immatriculations <- dbGetQuery(conn, "select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext")
Erreur dans .jcall(conn@jc, "Ljava/sql/Statement;", "createStatement") : 
  java.sql.SQLException: org.apache.hive.org.apache.thrift.transport.TTransportException
> immatriculations <- dbGetQuery(conn, "select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext")
Erreur dans dbSendQuery(conn, statement, ...) : 
  Unable to retrieve JDBC result set
  JDBC ERROR: org.apache.hive.org.apache.thrift.transport.TTransportException: java.net.SocketException: Une connexion établie a été abandonnée par un logiciel de votre ordinateur hôte
  Statement: select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext
> library(RJDBC)
> immatriculations <- dbGetQuery(conn, "select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext")
Erreur dans dbSendQuery(conn, statement, ...) : 
  Unable to retrieve JDBC result set
  JDBC ERROR: org.apache.hive.org.apache.thrift.transport.TTransportException: java.net.SocketException: Une connexion établie a été abandonnée par un logiciel de votre ordinateur hôte
  Statement: select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext
> 
> 
> 
> 
> library(RJDBC)
> hive_jdbc_jar <- "C:/Jar/hive-jdbc-3.1.3-standalone.jar" 
> hive_driver <- "org.apache.hive.jdbc.HiveDriver"
> 
> 
> hive_url <- "jdbc:hive2://localhost:10000"
> 
> 
> drv <- JDBC(hive_driver, hive_jdbc_jar)
> 
> 
> conn <- dbConnect(drv, hive_url, "vagrant", "")
> 
> 
> show_tables <- dbGetQuery(conn, "show tables")
> 
> 
> print(show_tables);
                        tab_name
1          appreciations_ons_ext
2              catalogue_mdb_ext
3             catalogue_with_co2
4  catalogue_with_co2_with_empty
5                client_kv_h_ext
6                        clients
7                clients_ons_ext
8                  clients_union
9                 co2_hdfs_h_ext
10              criteres_ons_ext
11   immatriculations_hdfs_h_ext
12            marketing_kv_h_ext
13      recommandations_hdfs_ext
> 
> 
> 
> 
> # hive_jdbc_jar <- "F:/informatiqueMendrika/projectM2/hive/jar/hive-jdbc-3.1.3-standalone.jar" 
> 
> # Etape 2 : Identification des catégories de véhicules
> 
> catalogue <- dbGetQuery(conn, "select marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from CATALOGUE_MDB_EXT")
> 
> str(catalogue)
'data.frame':	270 obs. of  9 variables:
 $ marque   : chr  "Volvo" "Volvo" "Volvo" "Volvo" ...
 $ nom      : chr  "S80 T6" "S80 T6" "S80 T6" "S80 T6" ...
 $ puissance: num  272 272 272 272 272 272 272 272 272 150 ...
 $ nbplaces : num  5 5 5 5 5 5 5 5 5 7 ...
 $ nbportes : num  5 5 5 5 5 5 5 5 5 5 ...
 $ longueur : chr  "tr�s longue" "tr�s longue" "tr�s longue" "tr�s longue" ...
 $ couleur  : chr  "blanc" "noir" "rouge" "gris" ...
 $ occasion : chr  "false" "false" "false" "true" ...
 $ prix     : num  50500 50500 50500 35350 35350 ...
> 
> # Factorisation des caractères pour un bon traitement des données 
> # Factorisation de la colonne marque 
> 
> catalogue$`marque` <- as.factor(catalogue$`marque`)
> 
> # Factorisation de la colonne nom
> 
> catalogue$`nom` <- as.factor(catalogue$`nom`)
> 
> # Factorisation de la colonne longueur
> 
> catalogue$`longueur` <- as.factor(catalogue$`longueur`)
> 
> # Factorisation de la colonne couleur 
> 
> catalogue$`couleur` <- as.factor(catalogue$`couleur`)
> 
> # Factorisation de la colonne occasion
> catalogue$`occasion` <- as.factor(catalogue$`occasion`) 
> 
> str(catalogue)
'data.frame':	270 obs. of  9 variables:
 $ marque   : Factor w/ 21 levels "Audi","BMW","Dacia",..: 21 21 21 21 21 21 21 21 21 20 ...
 $ nom      : Factor w/ 32 levels "1007 1.4","120i",..: 26 26 26 26 26 26 26 26 26 29 ...
 $ puissance: num  272 272 272 272 272 272 272 272 272 150 ...
 $ nbplaces : num  5 5 5 5 5 5 5 5 5 7 ...
 $ nbportes : num  5 5 5 5 5 5 5 5 5 5 ...
 $ longueur : Factor w/ 4 levels "courte","longue",..: 4 4 4 4 4 4 4 4 4 2 ...
 $ couleur  : Factor w/ 5 levels "blanc","bleu",..: 1 4 5 3 2 3 2 5 4 5 ...
 $ occasion : Factor w/ 2 levels "false","true": 1 1 1 2 2 1 1 2 2 1 ...
 $ prix     : num  50500 50500 50500 35350 35350 ...
> 
> # Résultats 
> # 'data.frame':	270 obs. of  10 variables:
> #  $ catalogue_mdb_ext.id       : chr  "665aebd15eab53512d2be54a" "665aebd15eab53512d2be54b" "665aebd15eab53512d2be54c" "665aebd15eab53512d2be54d" ...
> #  $ marque   : Factor w/ 21 levels "Audi","BMW","Dacia",..: 21 21 21 21 21 21 21 21 21 21 ...
> #  $ nom      : Factor w/ 32 levels "1007 1.4","120i",..: 26 26 26 26 26 26 26 26 26 26 ...
> #  $ puissance: num  272 272 272 272 272 272 272 272 272 272 ...
> #  $ longueur : Factor w/ 4 levels "courte","longue",..: 4 4 4 4 4 4 4 4 4 4 ...
> #  $ nbplaces : num  5 5 5 5 5 5 5 5 5 5 ...
> #  $ nbportes : num  5 5 5 5 5 5 5 5 5 5 ...
> #  $ couleur  : Factor w/ 5 levels "blanc","bleu",..: 1 4 5 3 2 2 5 1 4 3 ...
> #  $ occasion : Factor w/ 2 levels "false","true": 1 1 1 2 2 1 2 2 2 1 ...
> #  $ prix     : num  50500 50500 50500 35350 35350 ...
> 
> # install.packages("ggplot2")
> library(ggplot2)
> 
> # Répartition des données de la colonne puissance 
> ggplot(catalogue, aes(x = catalogue$puissance)) +
+     geom_histogram(binwidth = 20, fill = "darkgrey", color = "black", alpha = 0.7) +
+     geom_text(stat = "bin", aes(label = ..count..), vjust = -0.5, size = 3, binwidth = 20) +
+     labs(title = "Distribution Détaillée de la Puissance des Véhicules",
+          x = "Puissance (CV)",
+          y = "Fréquence") +
+     theme_minimal() +
+     theme(
+         panel.grid.major.y = element_line(color = "lightgrey"),
+         panel.grid.minor.y = element_blank(),
+         panel.grid.major.x = element_line(color = "lightgrey"),
+         panel.grid.minor.x = element_blank(),
+         axis.text = element_text(size = 10),
+         axis.title = element_text(size = 12),
+         axis.text.x = element_text(angle = 0, hjust = 0.5)  # Texte horizontal et centré
+     ) +
+     scale_x_continuous(breaks = seq(0, max(catalogue$puissance, na.rm = TRUE) + 50, by = 100)) +
+     scale_y_continuous(expand = c(0, 0))
Messages d'avis :
1: Use of `catalogue$puissance` is discouraged.
ℹ Use `puissance` instead. 
2: Use of `catalogue$puissance` is discouraged.
ℹ Use `puissance` instead. 
> 
> # Résultats => aucune incohérence 
> 
> # Répartition des données de la colonne longueur 
> 
> if (max(as.numeric(catalogue$longueur) , na.rm = TRUE) > 100) {
+     catalogue$longueur <- catalogue$longueur / 1000
+     unite <- "m"
+ } else {
+     unite <- "m"  
+ }
> 
> longueur_freq <- table(catalogue$`longueur`)
> 
> longueur_df <- as.data.frame(longueur_freq)
> names(longueur_df) <- c("Longueur", "Fréquence")
> 
> ggplot(longueur_df, aes(x = Longueur, y = Fréquence)) +
+     geom_bar(stat = "identity", 
+              fill = "gray",  # Bleu uniforme
+              color = "gray",   # Bordure noire pour une meilleure visibilité
+              width = 0.7) +    # Largeur des barres à 70% pour un meilleur espacement
+     labs(title = "Distribution de la Longueur des Véhicules",
+          x = "",
+          y = "Nombre de Véhicules") +
+     theme_minimal() +
+     theme(
+         panel.grid.major.y = element_line(color = "lightgrey"),
+         panel.grid.minor.y = element_blank(),
+         panel.grid.major.x = element_blank(),
+         panel.grid.minor.x = element_blank(),
+         axis.text = element_text(size = 12),
+         axis.title = element_text(size = 14),
+         axis.text.x = element_text(angle = 0, hjust = 0.5, size = 12, face = "bold"),  # Texte en gras
+         plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Titre centré et en gras
+         plot.margin = unit(c(1, 1, 1, 1), "cm")  # Marges autour du graphique
+     ) +
+     scale_y_continuous(expand = c(0, 0), 
+                        limits = c(0, max(longueur_df$Fréquence) * 1.1),
+                        breaks = seq(0, max(longueur_df$Fréquence), by = 100))
> 
> # Résultats => aucune incohérence
> 
> # Répartition des données de la colonne nbPlace 
> 
> ggplot(catalogue, aes(x = nbplaces)) +
+     geom_histogram(binwidth = 1, fill = "darkgrey", color = "black", alpha = 0.7) +
+     geom_text(stat = "bin", aes(label =..count..), vjust = -0.5, size = 3, binwidth = 1) +
+     labs(title = "Répartition des Nombres de Places par Véhicule",
+          x = "Nombres de Places",
+          y = "Fréquence") +
+     theme_minimal() +
+     theme(
+         panel.grid.major.y = element_line(color = "lightgrey"),
+         panel.grid.minor.y = element_blank(),
+         panel.grid.major.x = element_line(color = "lightgrey"),
+         panel.grid.minor.x = element_blank(),
+         axis.text = element_text(size = 10),
+         axis.title = element_text(size = 12) 
+     ) +
+     scale_x_continuous(breaks = seq(min(catalogue$nbplaces, na.rm = TRUE), max(catalogue$nbplaces, na.rm = TRUE) + 1, by = 1)) +
+     scale_y_continuous(expand = c(0, 0))
> 
> # Résultats => aucune incohérence
> 
> 
> # Répartition des données de la colonne nbPorte
> 
> ggplot(catalogue, aes(x = nbportes)) +
+     geom_histogram(binwidth = 1, fill = "darkgrey", color = "black", alpha = 0.7) +
+     geom_text(stat = "bin", aes(label =..count..), vjust = -0.5, size = 3, binwidth = 1) +
+     labs(title = "Répartition des Nombres de Places par Véhicule",
+          x = "Nombres de Places",
+          y = "Fréquence") +
+     theme_minimal() +
+     theme(
+         panel.grid.major.y = element_line(color = "lightgrey"),
+         panel.grid.minor.y = element_blank(),
+         panel.grid.major.x = element_line(color = "lightgrey"),
+         panel.grid.minor.x = element_blank(),
+         axis.text = element_text(size = 10),
+         axis.title = element_text(size = 12) 
+     ) +
+     scale_x_continuous(breaks = seq(min(catalogue$nbportes, na.rm = TRUE), max(catalogue$nbportes, na.rm = TRUE) + 1, by = 1)) +
+     scale_y_continuous(expand = c(0, 0))
> 
> 
> # Mettre les colonnes nbPlaces, nbPortes, longueur en ordinal 
> 
> catalogue$`nbplaces` <- as.factor(as.numeric(catalogue$`nbplaces`))
> catalogue$`nbplaces` <- factor(catalogue$`nbplaces`, ordered = TRUE, levels = sort(unique(catalogue$`nbplaces`)))
> 
> catalogue$`nbportes` <- as.factor(as.numeric(catalogue$`nbportes`))
> catalogue$`nbportes` <- factor(catalogue$`nbportes`, ordered = TRUE, levels = sort(unique(catalogue$`nbportes`)))
> 
> catalogue$`longueur` <- factor(catalogue$`longueur`, levels = c("courte", "moyenne", "longue", "tr�s longue"), ordered = TRUE)
> 
> # Vérification de la corrélation entre les variables 
> 
> pairs(catalogue[,c("longueur", "puissance", "prix", "nbplaces", "nbportes", "couleur", "marque", "occasion")])
> 
> # Résultats : Il n'y a pas de motif clair dans les diagrammes de dispersion impliquant la couleur. Cela suggère que la couleur n'a pas d'impact significatif sur les autres variables.
> 
> # Enlever la variable couleur 
> 
> catalogueTraitement <- catalogue
> catalogueTraitement$couleur <- NULL 
> str(catalogueTraitement)
'data.frame':	270 obs. of  8 variables:
 $ marque   : Factor w/ 21 levels "Audi","BMW","Dacia",..: 21 21 21 21 21 21 21 21 21 20 ...
 $ nom      : Factor w/ 32 levels "1007 1.4","120i",..: 26 26 26 26 26 26 26 26 26 29 ...
 $ puissance: num  272 272 272 272 272 272 272 272 272 150 ...
 $ nbplaces : Ord.factor w/ 2 levels "5"<"7": 1 1 1 1 1 1 1 1 1 2 ...
 $ nbportes : Ord.factor w/ 2 levels "3"<"5": 2 2 2 2 2 2 2 2 2 2 ...
 $ longueur : Ord.factor w/ 4 levels "courte"<"moyenne"<..: 4 4 4 4 4 4 4 4 4 3 ...
 $ occasion : Factor w/ 2 levels "false","true": 1 1 1 2 2 1 1 2 2 1 ...
 $ prix     : num  50500 50500 50500 35350 35350 ...
> 
> # Utilisation de K-means en variant le nombre de cluster 
> 
> install.packages("cluster")
Error in install.packages : Updating loaded packages
> library(cluster)
> 
> dataMatrix <- daisy(catalogueTraitement)
> summary(dataMatrix)
36315 dissimilarities, summarized :
   Min. 1st Qu.  Median    Mean 3rd Qu. 
 0.0000  0.3568  0.4368  0.4389  0.5194 
   Max. 
 0.8649 
Metric :  mixed ;  Types = N, N, I, O, O, O, N, I 
Number of objects : 270
> 
> install.packages("tsne")
Error in install.packages : Updating loaded packages
> library(tsne)
> 
> tsne_out <- tsne(dataMatrix, k=2)
sigma summary: Min. : 0.260563879141514 |1st Qu. : 0.268801404491008 |Median : 0.278474953151435 |Mean : 0.284249415567324 |3rd Qu. : 0.294991961380526 |Max. : 0.326226106256929 |
Epoch: Iteration #100 error is: 14.284932784427
Epoch: Iteration #200 error is: 0.132248657181771
Epoch: Iteration #300 error is: 0.130816095214471
Epoch: Iteration #400 error is: 0.127195370421296
Epoch: Iteration #500 error is: 0.127126461449813
Epoch: Iteration #600 error is: 0.127098664741292
Epoch: Iteration #700 error is: 0.125826979357342
Epoch: Iteration #800 error is: 0.125799504645366
Epoch: Iteration #900 error is: 0.125786992806602
Epoch: Iteration #1000 error is: 0.125771415653269
> tsne_out <- data.frame(tsne_out)
> set.seed(10000)
> 
> for(k in 2:10) {
+     km <- kmeans(dataMatrix, k)
+     print(qplot(tsne_out[,1], tsne_out[,2], col=as.factor(km$cluster)))
+ }
> 
> # Résultats : K=6 : Données mieux séparées et détaillées, facilitation de l'analyse 
> 
> # Evaluation du nombre de cluster choisi K=6
> 
> kmeans6 <- kmeans(dataMatrix, 6)
> 
> qplot(longueur, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(puissance, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(nbportes, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(nbplaces, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(prix, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> qplot(occasion, as.factor(kmeans6$cluster), data=catalogueTraitement) + geom_jitter(width = 0.3, height = 0.3)
> 
> # Interprétation pour k=6 => Catégorisation des véhicules
> # Cluster 1 :
> # Interprétation : Voitures Citadines
> # Caractéristiques : Petite taille, économie de carburant
> 
> # Cluster 2 :
> # Interprétation : Véhicules de Luxe / Haut de Gamme
> # Caractéristiques : Prix élevé, haute technologie
> 
> # Cluster 3 :
> 
> # Interprétation : SUV
> # Caractéristiques : Garde au sol élevée, espace intérieur, polyvalence
> # La dispersion suggère une large gamme : du compact au grand luxe
> 
> # Cluster 4 :
> 
> # Interprétation : Voitures Familiales
> # Caractéristiques : Espace, confort, équilibre performance/économie
> 
> # Cluster 5 :
> 
> # Interprétation : Voitures de Sport
> # Caractéristiques : Puissance élevée, maniabilité, design aérodynamique
> # Proche du cluster Luxe, suggérant un chevauchement (pensez supercars)
> 
> 
> # Cluster 6 :
> 
> # Interprétation : Véhicules Hybrides / Électriques
> # Caractéristiques : Faibles émissions, nouvelles technologies, efficacité
> # Au centre, suggérant des caractéristiques partagées avec d'autres catégories
> 
> # Ajout colonne catégorie dans les données du catalogue 
> 
> catalogue$categorie <- factor(kmeans6$cluster, levels=c(1,2,3,4,5,6), labels=c("Voitures Citadines", "Véhicules de Luxe / Haut de Gamme", "SUV", "Voitures Familiales", "Voitures de Sport", "Véhicules Hybrides / Électriques"))
> table(catalogue$categorie)

               Voitures Citadines 
                               35 
Véhicules de Luxe / Haut de Gamme 
                               40 
                              SUV 
                               85 
              Voitures Familiales 
                               85 
                Voitures de Sport 
                               10 
 Véhicules Hybrides / Électriques 
                               15 
> 
> # Copie du dataframe catalogue pour usage ultérieur
> catalogueNew <- catalogue
> 
> # Etape 3 : Association des catégories aux immatriculations
> immatriculations <- dbGetQuery(conn, "select immatriculation, marque, nom, puissance, nbplaces, nbportes, longueur, couleur, occasion, prix from immatriculations_hdfs_h_ext")
Messages d'avis :
1: Dans UseMethod("depth") :
  pas de méthode pour 'depth' applicable pour un objet de classe "NULL"
2: Dans UseMethod("depth") :
  pas de méthode pour 'depth' applicable pour un objet de classe "NULL"
> str(immatriculations)
'data.frame':	2000000 obs. of  10 variables:
 $ immatriculation: chr  "3176 TS 67" "3721 QS 49" "9099 UV 26" "3563 LA 55" ...
 $ marque         : chr  "Renault" "Volvo" "Volkswagen" "Peugeot" ...
 $ nom            : chr  "Laguna 2.0T" "S80 T6" "Golf 2.0 FSI" "1007 1.4" ...
 $ puissance      : num  170 272 150 75 75 193 135 136 150 150 ...
 $ nbplaces       : num  5 5 5 5 5 5 5 5 5 5 ...
 $ nbportes       : num  5 5 5 5 5 5 5 5 5 5 ...
 $ longueur       : chr  "longue" "tr�s longue" "moyenne" "courte" ...
 $ couleur        : chr  "blanc" "noir" "gris" "blanc" ...
 $ occasion       : chr  "false" "false" "true" "true" ...
 $ prix           : num  27300 50500 16029 9625 18310 ...
> 
> table(immatriculations$longueur)

     courte      longue     moyenne tr�s longue 
     549666      545179      231278      673877 
> catalogue$prix <- NULL
> 
> immatriculations$nbplaces <- factor(immatriculations$nbplaces,levels = c(5,7),ordered = TRUE)
> immatriculations$longueur <- factor(immatriculations$`longueur`, levels = c("courte", "moyenne", "longue", "tr�s longue"), ordered = TRUE)
> immatriculations$nbportes <- factor(immatriculations$nbportes,ordered = TRUE)
> 
> # install.packages("dplyr")
> library(dplyr)

Attachement du package : ‘dplyr’

Les objets suivants sont masqués depuis ‘package:stats’:

    filter, lag

Les objets suivants sont masqués depuis ‘package:base’:

    intersect, setdiff, setequal, union

> joined_immatriculations_catalogue <- inner_join(immatriculations,catalogue,by= c("nbplaces","marque","nom","puissance","longueur","nbportes","couleur","occasion"))
> str(joined_immatriculations_catalogue)
'data.frame':	2000000 obs. of  11 variables:
 $ immatriculation: chr  "3176 TS 67" "3721 QS 49" "9099 UV 26" "3563 LA 55" ...
 $ marque         : chr  "Renault" "Volvo" "Volkswagen" "Peugeot" ...
 $ nom            : chr  "Laguna 2.0T" "S80 T6" "Golf 2.0 FSI" "1007 1.4" ...
 $ puissance      : num  170 272 150 75 75 193 135 136 150 150 ...
 $ nbplaces       : Ord.factor w/ 2 levels "5"<"7": 1 1 1 1 1 1 1 1 1 1 ...
 $ nbportes       : Ord.factor w/ 2 levels "3"<"5": 2 2 2 2 2 2 2 2 2 2 ...
 $ longueur       : Ord.factor w/ 4 levels "courte"<"moyenne"<..: 3 4 2 1 1 4 2 2 2 3 ...
 $ couleur        : chr  "blanc" "noir" "gris" "blanc" ...
 $ occasion       : chr  "false" "false" "true" "true" ...
 $ prix           : num  27300 50500 16029 9625 18310 ...
 $ categorie      : Factor w/ 6 levels "Voitures Citadines",..: 3 2 4 1 1 3 3 4 4 4 ...
> count(joined_immatriculations_catalogue)
        n
1 2000000
> 
> table(joined_immatriculations_catalogue$categorie)

               Voitures Citadines 
                           418098 
Véhicules de Luxe / Haut de Gamme 
                           386869 
                              SUV 
                           570052 
              Voitures Familiales 
                           493413 
                Voitures de Sport 
                            27600 
 Véhicules Hybrides / Électriques 
                           103968 
> qplot(categorie,data = catalogue)
> 
> # Etape 4 : Fusion clients et immatriculations
> 
> joined_immatriculations_catalogue <- joined_immatriculations_catalogue[!duplicated(joined_immatriculations_catalogue$immatriculation),]
> 
> clients <- dbGetQuery(conn, "select immatriculation, age, sexe, taux, situationfamiliale, nbenfantsacharge, deuxiemevoiture from clients_union");
> str(clients)
'data.frame':	199992 obs. of  7 variables:
 $ immatriculation   : chr  "immatriculation" "8210 YS 91" "2060 NA 20" "8735 XO 78" ...
 $ age               : num  NA 31 39 68 39 46 44 70 71 21 ...
 $ sexe              : chr  "sexe" "M" "F" "M" ...
 $ taux              : num  NA 1286 1292 1397 1384 ...
 $ situationfamiliale: chr  "situationFamiliale" "En Couple" "En Couple" "En Couple" ...
 $ nbenfantsacharge  : num  NA 4 4 4 0 1 2 0 4 4 ...
 $ deuxiemevoiture   : chr  NA "false" "false" "false" ...
> 
> newDfClients <- merge(x = clients, y = joined_immatriculations_catalogue, by = "immatriculation",all.x = T)
> str(newDfClients)
'data.frame':	199992 obs. of  17 variables:
 $ immatriculation   : chr  "0 FW 80" "0 IH 52" "0 IM 93" "0 IO 54" ...
 $ age               : num  23 55 20 43 46 22 38 20 39 59 ...
 $ sexe              : chr  "M" "M" "M" "M" ...
 $ taux              : num  419 568 740 1068 534 ...
 $ situationfamiliale: chr  "En Couple" "En Couple" "En Couple" "En Couple" ...
 $ nbenfantsacharge  : num  4 1 0 0 0 0 2 0 0 0 ...
 $ deuxiemevoiture   : chr  "false" "false" "false" "true" ...
 $ marque            : chr  "Volvo" "Jaguar" "Jaguar" "Audi" ...
 $ nom               : chr  "S80 T6" "X-Type 2.5 V6" "X-Type 2.5 V6" "A2 1.4" ...
 $ puissance         : num  272 197 197 75 75 75 125 75 110 197 ...
 $ nbplaces          : Ord.factor w/ 2 levels "5"<"7": 1 1 1 1 1 1 1 1 1 1 ...
 $ nbportes          : Ord.factor w/ 2 levels "3"<"5": 2 2 2 2 2 2 2 2 2 2 ...
 $ longueur          : Ord.factor w/ 4 levels "courte"<"moyenne"<..: 4 3 3 1 1 1 3 1 2 3 ...
 $ couleur           : chr  "blanc" "rouge" "gris" "blanc" ...
 $ occasion          : chr  "false" "true" "false" "false" ...
 $ prix              : num  50500 25970 37100 18310 12817 ...
 $ categorie         : Factor w/ 6 levels "Voitures Citadines",..: 2 4 3 1 1 1 3 1 3 3 ...
> 
> # Diagramme des effectifs des categories
> qplot(categorie, data = newDfClients,main = "Distributions des catégories sur les clients")
> 
> 
> 
> install.packages("tsne")
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding:

https://cran.rstudio.com/bin/windows/Rtools/
Warning in install.packages :
  le package ‘tsne’ est en cours d'utilisation et ne sera pas installé
> install.packages("cluster")
Error in install.packages : Updating loaded packages
> install.packages("cluster")
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding:

https://cran.rstudio.com/bin/windows/Rtools/
Warning in install.packages :
  le package ‘cluster’ est en cours d'utilisation et ne sera pas installé
> 
> 
> 
> 
> 
> 
> library(caret)
Le chargement a nécessité le package : lattice
> library(dplyr)
> library(randomForest)
randomForest 4.7-1.1
Type rfNews() to see new features/changes/bug fixes.

Attachement du package : ‘randomForest’

L'objet suivant est masqué depuis ‘package:dplyr’:

    combine

L'objet suivant est masqué depuis ‘package:ggplot2’:

    margin

> library(rpart)
> library(rpart.plot)
Erreur dans library(rpart.plot) : 
  aucun package nommé ‘rpart.plot’ n'est trouvé
> set.seed(123)
> 
> 
> trainIndex <- createDataPartition(newDfClients$categorie, p = .7, 
+                                   list = FALSE, 
+                                   times = 1)
> trainData <- newDfClients[trainIndex, ]
> testData <- newDfClients[-trainIndex, ]
> 
> 
> trainX <- trainData %>%
+     select(-categorie, -immatriculation)  # Enlever la variable cible et la colonne immatriculation
> trainY <- trainData$categorie
> testX <- testData %>%
+     select(-categorie, -immatriculation)
> testY <- testData$categorie
> dmy <- dummyVars(" ~ .", data = trainX)
> trainX <- predict(dmy, newdata = trainX)
> testX <- predict(dmy, newdata = testX)
> 
> 
> treeModel <- rpart(trainY ~ ., data = trainX, method = "class")
Erreur dans model.frame.default(formula = trainY ~ ., data = trainX, na.action = function (x)  : 
  'data' doit être un tableau de données et non pas une matrice ou un tableau
> install.packages("rpart")
Error in install.packages : Updating loaded packages
> install.packages("rpart.plot")
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding:

https://cran.rstudio.com/bin/windows/Rtools/
essai de l'URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/rpart.plot_3.1.2.zip'
Content type 'application/zip' length 1038856 bytes (1014 KB)
downloaded 1014 KB

le package ‘rpart.plot’ a été décompressé et les sommes MD5 ont été vérifiées avec succés

Les packages binaires téléchargés sont dans
	C:\Users\tsiory\AppData\Local\Temp\Rtmpo9s3qI\downloaded_packages
> install.packages("rpart")
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding:

https://cran.rstudio.com/bin/windows/Rtools/
Warning in install.packages :
  le package ‘rpart’ est en cours d'utilisation et ne sera pas installé
> 
> 
> 
> 
> treeModel <- rpart(trainY ~ ., data = trainX, method = "class")
Erreur dans model.frame.default(formula = trainY ~ ., data = trainX, na.action = function (x)  : 
  'data' doit être un tableau de données et non pas une matrice ou un tableau
> dmy <- dummyVars(" ~ .", data = trainX)
> trainX <- predict(dmy, newdata = trainX)
> testX <- predict(dmy, newdata = testX)
Erreur dans predict.dummyVars(dmy, newdata = testX) : 
  Variable(s) 'sexesexe', 'situationfamilialesituationFamiliale' are not in newdata
> 
> 
> treeModel <- rpart(trainY ~ ., data = trainX, method = "class")
Erreur dans model.frame.default(formula = trainY ~ ., data = trainX, na.action = function (x)  : 
  'data' doit être un tableau de données et non pas une matrice ou un tableau
>     
> 
> 
> 
> 
> 
> 
> data <- newDfClients[, c("age", "sexe", "taux", "situationfamiliale", "nbenfantsacharge", "deuxiemevoiture", "categorie")]
> 
> data$sexe <- as.factor(data$sexe)
> data$situationfamiliale <- as.factor(data$situationfamiliale)
> data$deuxiemevoiture <- as.factor(data$deuxiemevoiture)
> data$categorie <- as.factor(data$categorie)
> str(data)
'data.frame':	199992 obs. of  7 variables:
 $ age               : num  23 55 20 43 46 22 38 20 39 59 ...
 $ sexe              : Factor w/ 10 levels " ","?","F","Femme",..: 7 7 7 7 7 7 7 7 3 7 ...
 $ taux              : num  419 568 740 1068 534 ...
 $ situationfamiliale: Factor w/ 10 levels " ","?","C�libataire",..: 5 5 5 5 5 3 9 3 3 5 ...
 $ nbenfantsacharge  : num  4 1 0 0 0 0 2 0 0 0 ...
 $ deuxiemevoiture   : Factor w/ 2 levels "false","true": 1 1 1 2 2 1 1 1 1 1 ...
 $ categorie         : Factor w/ 6 levels "Voitures Citadines",..: 2 4 3 1 1 1 3 1 3 3 ...
> 
> 
> set.seed(123)
> 
> 
> trainIndex <- createDataPartition(data$categorie, p = .7, 
+                                   list = FALSE, 
+                                   times = 1)
> dataTrain <- data[ trainIndex,]
> dataTest  <- data[-trainIndex,]
> 
> 
> 
> model_rpart <- rpart(categorie ~ ., data = dataTrain, method = "class")
> 
> pred_rpart <- predict(model_rpart, dataTest, type = "class")
> model_rf <- randomForest(categorie ~ ., data = dataTrain)
Erreur dans na.fail.default(list(categorie = c(4L, 3L, 1L, 1L, 1L, 3L, 1L,  : 
  valeurs manquantes dans l'objet
> dataTrain <- na.omit(dataTrain)
> dataTest <- na.omit(dataTest)
> preProcess_missingdata_model <- preProcess(data, method = 'medianImpute')
> dataTrain <- predict(preProcess_missingdata_model, newdata = dataTrain)
> dataTest <- predict(preProcess_missingdata_model, newdata = dataTest)
> model_rpart <- rpart(categorie ~ ., data = dataTrain, method = "class")
> pred_rpart <- predict(model_rpart, dataTest, type = "class")
> 
> 
> model_rf <- randomForest(categorie ~ ., data = dataTrain)
> 
> 
> 
> confusionMatrix(pred_rpart, dataTest$categorie)
Confusion Matrix and Statistics

                                   Reference
Prediction                          Voitures Citadines
  Voitures Citadines                             12524
  Véhicules de Luxe / Haut de Gamme                  1
  SUV                                               25
  Voitures Familiales                                4
  Voitures de Sport                                  0
  Véhicules Hybrides / Électriques                   0
                                   Reference
Prediction                          Véhicules de Luxe / Haut de Gamme
  Voitures Citadines                                               12
  Véhicules de Luxe / Haut de Gamme                              7000
  SUV                                                            4439
  Voitures Familiales                                              21
  Voitures de Sport                                                 0
  Véhicules Hybrides / Électriques                                  0
                                   Reference
Prediction                            SUV Voitures Familiales
  Voitures Citadines                 3862                3029
  Véhicules de Luxe / Haut de Gamme   411                1731
  SUV                                9471                2601
  Voitures Familiales                3284                7383
  Voitures de Sport                     0                   0
  Véhicules Hybrides / Électriques      0                   0
                                   Reference
Prediction                          Voitures de Sport
  Voitures Citadines                              838
  Véhicules de Luxe / Haut de Gamme                 0
  SUV                                               0
  Voitures Familiales                               2
  Voitures de Sport                                 0
  Véhicules Hybrides / Électriques                  0
                                   Reference
Prediction                          Véhicules Hybrides / Électriques
  Voitures Citadines                                            3116
  Véhicules de Luxe / Haut de Gamme                                1
  SUV                                                              5
  Voitures Familiales                                              1
  Voitures de Sport                                                0
  Véhicules Hybrides / Électriques                                 0

Overall Statistics
                                          
               Accuracy : 0.6087          
                 95% CI : (0.6048, 0.6126)
    No Information Rate : 0.2849          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.4888          
                                          
 Mcnemar's Test P-Value : NA              

Statistics by Class:

                     Class: Voitures Citadines
Sensitivity                             0.9976
Specificity                             0.7700
Pos Pred Value                          0.5356
Neg Pred Value                          0.9992
Prevalence                              0.2101
Detection Rate                          0.2096
Detection Prevalence                    0.3912
Balanced Accuracy                       0.8838
                     Class: Véhicules de Luxe / Haut de Gamme
Sensitivity                                            0.6102
Specificity                                            0.9556
Pos Pred Value                                         0.7655
Neg Pred Value                                         0.9117
Prevalence                                             0.1920
Detection Rate                                         0.1171
Detection Prevalence                                   0.1530
Balanced Accuracy                                      0.7829
                     Class: SUV Class: Voitures Familiales
Sensitivity              0.5562                     0.5007
Specificity              0.8346                     0.9264
Pos Pred Value           0.5726                     0.6903
Neg Pred Value           0.8252                     0.8500
Prevalence               0.2849                     0.2467
Detection Rate           0.1585                     0.1235
Detection Prevalence     0.2768                     0.1790
Balanced Accuracy        0.6954                     0.7136
                     Class: Voitures de Sport
Sensitivity                           0.00000
Specificity                           1.00000
Pos Pred Value                            NaN
Neg Pred Value                        0.98594
Prevalence                            0.01406
Detection Rate                        0.00000
Detection Prevalence                  0.00000
Balanced Accuracy                     0.50000
                     Class: Véhicules Hybrides / Électriques
Sensitivity                                          0.00000
Specificity                                          1.00000
Pos Pred Value                                           NaN
Neg Pred Value                                       0.94774
Prevalence                                           0.05226
Detection Rate                                       0.00000
Detection Prevalence                                 0.00000
Balanced Accuracy                                    0.50000
> # Calcul de la matrice de confusion pour la forêt aléatoire
> confusionMatrix(pred_rf, dataTest$categorie)
Erreur : objet 'pred_rf' introuvable
> confusionMatrix(pred_rf, dataTest$categorie)
Erreur : objet 'pred_rf' introuvable
> pred_rf <- predict(model_rf, dataTest)
> confusionMatrix(pred_rf, dataTest$categorie)
Confusion Matrix and Statistics

                                   Reference
Prediction                          Voitures Citadines
  Voitures Citadines                              9668
  Véhicules de Luxe / Haut de Gamme                  1
  SUV                                             1995
  Voitures Familiales                              848
  Voitures de Sport                                 36
  Véhicules Hybrides / Électriques                   6
                                   Reference
Prediction                          Véhicules de Luxe / Haut de Gamme
  Voitures Citadines                                                6
  Véhicules de Luxe / Haut de Gamme                              6817
  SUV                                                            4637
  Voitures Familiales                                              12
  Voitures de Sport                                                 0
  Véhicules Hybrides / Électriques                                  0
                                   Reference
Prediction                            SUV Voitures Familiales
  Voitures Citadines                 1626                 629
  Véhicules de Luxe / Haut de Gamme    13                1623
  SUV                               12428                4520
  Voitures Familiales                2959                7968
  Voitures de Sport                     1                   0
  Véhicules Hybrides / Électriques      1                   4
                                   Reference
Prediction                          Voitures de Sport
  Voitures Citadines                              339
  Véhicules de Luxe / Haut de Gamme                 0
  SUV                                             237
  Voitures Familiales                             237
  Voitures de Sport                                27
  Véhicules Hybrides / Électriques                  0
                                   Reference
Prediction                          Véhicules Hybrides / Électriques
  Voitures Citadines                                            1679
  Véhicules de Luxe / Haut de Gamme                                1
  SUV                                                           1008
  Voitures Familiales                                            417
  Voitures de Sport                                               17
  Véhicules Hybrides / Électriques                                 1

Overall Statistics
                                          
               Accuracy : 0.6176          
                 95% CI : (0.6137, 0.6215)
    No Information Rate : 0.2849          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.4929          
                                          
 Mcnemar's Test P-Value : NA              

Statistics by Class:

                     Class: Voitures Citadines
Sensitivity                             0.7701
Specificity                             0.9094
Pos Pred Value                          0.6932
Neg Pred Value                          0.9370
Prevalence                              0.2101
Detection Rate                          0.1618
Detection Prevalence                    0.2334
Balanced Accuracy                       0.8397
                     Class: Véhicules de Luxe / Haut de Gamme
Sensitivity                                            0.5942
Specificity                                            0.9661
Pos Pred Value                                         0.8063
Neg Pred Value                                         0.9093
Prevalence                                             0.1920
Detection Rate                                         0.1141
Detection Prevalence                                   0.1415
Balanced Accuracy                                      0.7802
                     Class: SUV Class: Voitures Familiales
Sensitivity              0.7299                     0.5404
Specificity              0.7099                     0.9006
Pos Pred Value           0.5006                     0.6405
Neg Pred Value           0.8683                     0.8568
Prevalence               0.2849                     0.2467
Detection Rate           0.2080                     0.1333
Detection Prevalence     0.4154                     0.2082
Balanced Accuracy        0.7199                     0.7205
                     Class: Voitures de Sport
Sensitivity                         0.0321429
Specificity                         0.9990835
Pos Pred Value                      0.3333333
Neg Pred Value                      0.9863773
Prevalence                          0.0140560
Detection Rate                      0.0004518
Detection Prevalence                0.0013554
Balanced Accuracy                   0.5156132
                     Class: Véhicules Hybrides / Électriques
Sensitivity                                        3.202e-04
Specificity                                        9.998e-01
Pos Pred Value                                     8.333e-02
Neg Pred Value                                     9.477e-01
Prevalence                                         5.226e-02
Detection Rate                                     1.673e-05
Detection Prevalence                               2.008e-04
Balanced Accuracy                                  5.001e-01
> 
> 
> save.image("~/test.RData")
> 
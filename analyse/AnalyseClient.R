
# Charger les données de la table `clients` depuis la base de données
clients <- dbGetQuery(conn, "SELECT * FROM clients")


# 1. Age
# Afficher la structure des données
str(clients)

# Afficher la table des fréquences des âges pour identifier les valeurs incohérentes
table(clients$clients.age)

# Convertir la colonne `clients.age` en numérique, les valeurs non numériques seront converties en NA
clients$clients.age <- as.numeric(as.character(clients$clients.age))

# Supprimer les valeurs incohérentes (NA) et les valeurs négatives de la colonne `clients.age`
clients <- clients[!is.na(clients$clients.age) & clients$clients.age >= 0, ]

# Afficher un histogramme des fréquences
ggplot(clients, aes(x = clients.age)) +
  geom_histogram(binwidth = 5, fill = "light blue", color = "black") +  # Paramètres de l'histogramme
  labs(title = "Distribution des âges", x = "Âge", y = "Fréquence") +  # Ajouter des étiquettes et un titre
  scale_x_continuous(breaks = seq(0, max(clients$clients.age), by = 5)) +  # Ajouter des graduations pour l'axe des x
  scale_y_continuous(breaks = seq(0, max(table(clients$clients.age)), by = 10)) +  # Ajouter des graduations pour l'axe des y
  theme_minimal()


# 2. Sexe
# Afficher la table des fréquences des sexes pour identifier les valeurs incohérentes
table(clients$clients.sexe)

# Rassembler les valeurs similaires de `clients.sexe`
clients$clients.sexe <- ifelse(clients$clients.sexe %in% c("Femme", "Féminin", "F�minin"), "F",
                               ifelse(clients$clients.sexe %in% c("Masculin", "Homme"), "M",
                                      clients$clients.sexe))

# Supprimer les valeurs incohérentes "?","N/D","" et " " de la colonne `clients.sexe`
clients <- clients %>% filter(clients.sexe != "?" & clients.sexe != "N/D" & clients.sexe != "" & clients.sexe != " ")

# Créer un graphique pour visualiser la distribution des sexes
ggplot(clients, aes(x = clients.sexe)) +
  geom_bar(fill = "light blue", color = "black") +  # Utiliser geom_bar pour les variables discrètes
  labs(title = "Distribution des sexes", x = "Sexe", y = "Fréquence")+   # Ajouter des étiquettes et un titre
  theme_minimal()


# 3. Deuxième voiture
# Afficher la table des fréquences de deuxième voiture pour identifier les valeurs incohérentes
table(clients$clients.deuxiemevoiture)

# Suppression des champs non-renseignés
clients <- clients[!is.na(clients$clients.deuxiemevoiture), ]

# Création de raphique de visualisation
ggplot(clients, aes(x="true", y="false", fill=clients.deuxiemevoiture)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0) +
  theme_void() +
  theme(legend.position="right") +
  labs(fill="Deuxième voiture")



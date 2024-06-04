
# Charger les données de la table `clients` depuis la base de données
clients <- dbGetQuery(conn, "SELECT * FROM clients")

# Age
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
  theme_minimal()  # Appliquer un thème minimaliste

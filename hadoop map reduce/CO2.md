# Hadoop Map Reduce : Traitement du fichier CO2.csv

## Intégration du fichier CO2.csv dans HDFS

> Si HDFS n'est pas encore allumé il faudrait avec cette commande 

```bash
$ start-dfs.sh
```
> Le fichier CO2.csv est mis au préalable dans le répertoire de la VM

```bash
$ hadoop fs -put /vagrant/CO2.csv .
```
> Vérification du fichier 

```bash
$ hadoop fs -ls
```
**Voici le résultat:**
```
Found 1 items
-rw-r--r--   1 vagrant supergroup      38916 2024-05-27 08:12 CO2.csv
```

## Compilation du script map/reduce et construction du fichier jar

> Le fichier Co2.java est mis au préalable dans le répertoire de la VM

### Compilation du code map reduce

```bash
$ javac Co2.java
$ mkdir -p org/mbds
$ mv Co2*.class org/mbds
```

### Génération du fichier jar et nettoyage

```bash
$ jar -cvf co2-0.0.1.jar -C . org
$ rm -rf org
```

## Execution du fichier jar aux données CO2.csv
> Si le dossier co2_treatment existe il faudrait l'effacer 

```bash
$ hadoop fs -rm -r co2_treatment
```
> Les résultats du traitement des données CO2.csv faites par le map reduce seront stockés dans le dossier co2_treatment

```bash
$ hadoop jar co2-0.0.1.jar org.mbds.Co2 CO2.csv co2_treatment
```

> Visualisation des résultats du traitement 

```bash
$ hadoop fs -cat co2_treatment/*
```

**Voici le résultat:**
```
AUDI,-24000.40,26.10,191.60
BENTLEY,.00,84.00,102.00
BMW,-6315.89,39.26,80.53
CITROEN,-60001.00,.00,347.00
DS,-30000.50,16.50,159.00
HYUNDAI,-40000.67,8.67,151.00
JAGUAR,-60001.00,.00,271.00
KIA,-40000.67,10.33,157.67
LAND,.00,69.00,78.00
MERCEDES,7241.42,187.63,749.98
MINI,-30000.50,21.50,126.00
MITSUBISHI,.00,40.00,98.00
NISSAN,-4997.80,160.00,681.20
PEUGEOT,-30000.50,15.83,144.17
PORSCHE,.00,69.86,89.71
RENAULT,-60001.00,.00,206.00
SKODA,-6666.78,27.56,98.89
SMART,-60001.00,.00,191.36
TESLA,-60001.00,.00,245.89
TOYOTA,.00,32.00,43.00
VOLKSWAGEN,-17143.14,23.43,96.00
VOLVO,.00,42.45,72.73
```


## Intégration des données dans HIVE

### Démarrage du serveur Hadoop HIVE 

> Démarrage du serveur hadoop HIVe au cas où celui-ci n'est pas encore allumé

```bash
nohup hive --service metastore > /dev/null &
nohup hiveserver2 > /dev/null &
```

### Connexion à beeline puis HIVE

```bash
$ beeline
> !connect jdbc:hive2://localhost:10000
```

### Création d'une table dans HIVE avec les données résultants du map reduce

```bash
> CREATE EXTERNAL TABLE CO2_HDFS_H_EXT(
MARQUE string,
`BONUS/MALUS` DECIMAL(10,2),
`REJETCO2` DECIMAL(5,2),
`COUTENERGIE` DECIMAL(10,2)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

> LOAD DATA INPATH 'co2_treatment/*' OVERWRITE INTO TABLE CO2_HDFS_H_EXT;
```

### Vérification de la présence de données 

```bash
> SELECT COUNT(*) FROM CO2_HDFS_H_EXT;
```

**Voici le résultat:**
```
+------+
| _c0  |
+------+
| 22   |
+------+
```

```bash
> SELECT * FROM CO2_HDFS_H_EXT LIMIT 5;
```

### Création des views pour combiner les données du CO2 avec Catalogue

> Création de view CATALOGUE_WITH_CO2_WITH_EMPTY avec les données null
```bash
> CREATE VIEW IF NOT EXISTS CATALOGUE_WITH_CO2_WITH_EMPTY AS
SELECT c.id, c.marque, c.nom, c.puissance, c.longueur, c.nbplaces, c.nbportes, c.couleur, c.occasion, c.prix, 
       co2.`BONUS/MALUS`, co2.`REJETCO2`, co2.`COUTENERGIE`
FROM CATALOGUE_MDB_EXT c
LEFT JOIN CO2_HDFS_H_EXT co2 ON UPPER(c.marque) = UPPER(co2.MARQUE);
```
> Vérification des données
```bash
> SELECT * FROM CATALOGUE_WITH_CO2_WITH_EMPTY LIMIT 5;
```
> Création de view CATALOGUE_WITH_CO2 qui gère les données null
```bash
> CREATE VIEW IF NOT EXISTS CATALOGUE_WITH_CO2 AS
SELECT id, marque, nom, puissance, longueur, nbplaces, nbportes, couleur, occasion, prix,
       CASE
           WHEN `BONUS/MALUS` IS NOT NULL AND `REJETCO2` IS NOT NULL AND `COUTENERGIE` IS NOT NULL
           THEN `BONUS/MALUS`
           ELSE COALESCE((SELECT `BONUS/MALUS` FROM CO2_HDFS_H_EXT WHERE MARQUE IS NULL LIMIT 1), 0)
       END AS `BONUS/MALUS`,
       CASE
           WHEN `BONUS/MALUS` IS NOT NULL AND `REJETCO2` IS NOT NULL AND `COUTENERGIE` IS NOT NULL
           THEN `REJETCO2`
           ELSE COALESCE((SELECT `REJETCO2` FROM CO2_HDFS_H_EXT WHERE MARQUE IS NULL LIMIT 1), 0)
       END AS `REJETCO2`,
       CASE
           WHEN `BONUS/MALUS` IS NOT NULL AND `REJETCO2` IS NOT NULL AND `COUTENERGIE` IS NOT NULL
           THEN `COUTENERGIE`
           ELSE COALESCE((SELECT `COUTENERGIE` FROM CO2_HDFS_H_EXT WHERE MARQUE IS NULL LIMIT 1), 0)
       END AS `COUTENERGIE`
FROM CATALOGUE_WITH_CO2_WITH_EMPTY;
```

> Vérification des données
```bash
> SELECT * FROM CATALOGUE_WITH_CO2 LIMIT 5;
```
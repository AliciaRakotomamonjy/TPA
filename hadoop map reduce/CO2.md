# Hadoop Map Reduce : Traitement du fichier CO2.csv

## Intégration du fichier CO2.csv dans HDFS
> Le fichier CO2.csv est mis au préalable dans le répertoire de la VM

```bash
$ hadoop fs -put /vagrant/CO2.csv .
```
> Vérification du fichier 

```bash
$ hadoop fs -ls
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

## Intégration des données dans HIVE

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
STORED AS TEXTFILE LOCATION 'hdfs:/co2_treatment'
TBLPROPERTIES (
'skip.header.line.count'='1');
```

### Vérification de la présence de données 

```bash
> SELECT COUNT(*) FROM CO2_HDFS_H_EXT;
> SELECT * FROM CO2_HDFS_H_EXT LIMIT 5;
```

### Création des views pour combiner les données du CO2 avec Catalogue

> Création de view CATALOGUE_WITH_CO2_WITH_EMPTY avec les données null
```bash
> CREATE VIEW CATALOGUE_WITH_CO2_WITH_EMPTY AS
SELECT c.id, c.marque, c.nom, c.puissance, c.longueur, c.nbplaces, c.nbportes, c.couleur, c.occasion, c.prix, 
       co2.`BONUS/MALUS`, co2.`REJETCO2`, co2.`COUTENERGIE`
FROM CATALOGUE_MDB_EXT c
LEFT JOIN CO2_HDFS_H_EXT co2 ON c.marque = co2.MARQUE;
```
> Vérification des données
```bash
> SELECT * FROM CATALOGUE_WITH_CO2_WITH_EMPTY LIMIT 5;
```
> Création de view CATALOGUE_WITH_CO2 qui gère les données null
```bash
> CREATE VIEW CATALOGUE_WITH_CO2 AS
SELECT id, marque, nom, puissance, longueur, nbplaces, nbportes, couleur, occasion, prix,
       CASE
           WHEN `BONUS/MALUS` IS NOT NULL AND `REJETCO2` IS NOT NULL AND `COUTENERGIE` IS NOT NULL
           THEN `BONUS/MALUS`, `REJETCO2`, `COUTENERGIE`
           ELSE (SELECT COALESCE(`BONUS/MALUS`, 0) AS `BONUS/MALUS`,
                        COALESCE(`REJETCO2`, 0) AS `REJETCO2`,
                        COALESCE(`COUTENERGIE`, 0) AS `COUTENERGIE`
                 FROM CO2_HDFS_H_EXT
                 WHERE MARQUE IS NULL
                 LIMIT 1)
       END
FROM CATALOGUE_WITH_CO2_WITH_EMPTY;
```

> Vérification des données
```bash
> SELECT * FROM CATALOGUE_WITH_CO2 LIMIT 5;
```
# import du fichier Catalogue.csv dans mongodb

## Migration du fichier Immatriculations.csv dans HDFS

### Création d'un directory `immatriculations`
```bash
$ hdfs dfs -mkdir /immatriculations
```

### Migrer également Immatriculations.csv dans le répertoire `immatriculations` de HDFS
### RQ: le fichier CO2.csv est dans le répertoire de la VM
```bash
$ hdfs dfs -put /vagrant/Immatriculations.csv /immatriculations/
```

Vérification de la copie
```bash
$ hdfs dfs -ls /immatriculation
```
On a ce résultat
-"Found 1 item
-rw-r--r--   1 vagrant supergroup  120957648 2024-04-26 21:51 /immatriculations/Immatriculations.csv"

## Connexion à beeline puis HIVE

```bash
$ beeline
> !connect jdbc:hive2://localhost:10000
```

On a le module de connexion qui s'affiche:
    Enter username for jdbc:hive2://localhost:10000:
    Enter password for jdbc:hive2://localhost:10000:
Laisser les champs vides et cliquer sur "Enter"


On est maintenant connecté:
0: jdbc:hive2://localhost:10000>

## Création d'une table externe dans hive avec les données du fichier csv
```bash
> CREATE EXTERNAL TABLE  IMMATRICULATIONS_HDFS_H_EXT(
IMMATRICULATION string,
MARQUE string,
NOM string,
PUISSANCE int,
LONGUEUR string,
NBPLACES int,
NBPORTES int,
COULEUR string,
OCCASION boolean,
PRIX int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/immatriculations'
TBLPROPERTIES (
'skip.header.line.count'='1');
```

Vérification de la présence des données
-"SELECT COUNT(*) FROM IMMATRICULATIONS_HDFS_H_EXT;"

Voici le résultat:
+----------+
|   _c0    |
+----------+
| 2000000  |
+----------+
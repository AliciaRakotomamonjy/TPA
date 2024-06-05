# ----------------------------- CLIENT1 ET MARKETING ---------------------------------

## Lancement de de Kvstore :
```bash
nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &
```

## Copie des fichiers Java dans le répertoire de Kvstore :
```bash
cp /vagrant/ClientMarketing.java $KVHOME/examples/hello
```

## Compilation des classes Java :
```bash
mkdir -p migrationKv
javac /$KVHOME/examples/hello/ClientMarketing.java -d migrationKv
```

## Exécution des ETL
```bash
java -cp $CLASSPATH:migrationKv ClientMarketing
```

## Démarrage de hive
```bash
start-dfs.sh
start-yarn.sh
nohup hive --service metastore > hive_metastore.log 2>&1 &
nohup hiveserver2 > hive_server.log 2>&1 &
```

## Connexion à HIVE
```bash
beeline -u jdbc:hive2://localhost:10000
```

## Création de la table client et marketing dans hive pointant vers nosql
```bash
jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE CLIENT_KV_H_EXT  (
AGE int, 
SEXE string, 
TAUX int, 
SITUATIONFAMILIALE string, 
NBENFANTSACHARGE int, 
DEUXIEMEVOITURE boolean,  
IMMATRICULATION string)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000", 
"oracle.kv.hadoop.hosts" = "localhost/127.0.0.1", 
"oracle.kv.tableName" = "CLIENT");

jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE MARKETING_KV_H_EXT(
    AGE int, 
    SEXE string, 
    TAUX int, 
    SITUATIONFAMILIALE string, 
    NBENFANTSACHARGE int, 
    DEUXIEMEVOITURE boolean)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" ="localhost:5000", 
"oracle.kv.hadoop.hosts" = "localhost/127.0.0.1", 
"oracle.kv.tableName" = "MARKETING");

jdbc:hive2://localhost:10000> select count(*) from MARKETING_KV_H_EXT;
+------+
| _c0  |
+------+
| 20   |
+------+

jdbc:hive2://localhost:10000> select count(*) from CLIENT_KV_H_EXT;
+--------+
|  _c0   |
+--------+
| 99991  |
+--------+
```


# ----------------------------- CATALOGUE ---------------------------------

## Démarrage de mongodb
```bash
sudo systemctl start mongod
```

## Suppression de la table catalogue s'il existe déjà
```bash
mongo
> use automobile
> db.catalogues.drop()
```

Pour quitter mongo, on excécute la commande exit
```bash
> exit
```

## import du fichier Catalogue.csv dans mongodb
```bash
tail -n +2 /vagrant/Catalogue.csv | mongoimport \
--uri='mongodb://127.0.0.1:27017/automobile?w=majority' \
--collection='catalogues' \
--type=csv \
--columnsHaveTypes \
--fields="marque.string(),nom.string(),puissance.int32(),longueur.string(),nbplaces.int32(),nbportes.int32(),couleur.string(),occasion.boolean(),prix.int32()"
```

Pour vérifier si les données sont bien présents dans mongodb

```bash
mongo
> use automobile
> db.catalogues.find().count()
> db.catalogues.find().limit(10)
```
Pour quitter mongo, on excécute la commande exit
```bash
> exit
```

## Connexion à HIVE
```bash
beeline -u jdbc:hive2://localhost:10000
```

## Suppression de la table si elle existe déjà
```bash
jdbc:hive2://localhost:10000> DROP TABLE CATALOGUE_MDB_EXT;
```

## Création de la table externe pointant vers la table catalogues dans mongodb
```bash
jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE CATALOGUE_MDB_EXT(
    id STRING,
    marque STRING,
    nom STRING,
    puissance INT,
    longueur STRING,
    nbplaces INT,
    nbportes INT,
    couleur STRING,
    occasion BOOLEAN,
    prix INT
) STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id"}')
TBLPROPERTIES('mongo.uri'='mongodb://127.0.0.1:27017/automobile.catalogues');
```
## On vérifie les données

```bash
jdbc:hive2://localhost:10000>  SELECT count(*) FROM CATALOGUE_MDB_EXT;
+------+
| _c0  |
+------+
| 270  |
+------+
jdbc:hive2://localhost:10000>  SELECT * FROM CATALOGUE_MDB_EXT LIMIT 5;
```


# ----------------------------- IMMATRICULATION ---------------------------------

## Création d'un directory `immatriculations`
```bash
hdfs dfs -mkdir /immatriculations
```
## Chargement du fichier local dans HDFS
```bash
hdfs dfs -put /vagrant/Immatriculations.csv /immatriculations/
```

## Vérification de la copie
```bash
hdfs dfs -ls /immatriculations
```

## Connexion à HIVE
```bash
beeline -u jdbc:hive2://localhost:10000
```

## Création d'une table externe dans hive avec les données du fichier csv
```bash
jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE  IMMATRICULATIONS_HDFS_H_EXT(
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

## Vérification de la présence des données
```bash
jdbc:hive2://localhost:10000> SELECT COUNT(*) FROM IMMATRICULATIONS_HDFS_H_EXT;
+----------+
|   _c0    |
+----------+
| 2000000  |
+----------+
```

# ----------------------------- CLIENT18 ---------------------------------

## Connexion à HIVE
```bash
beeline -u jdbc:hive2://localhost:10000
```

## Cration de la table interne

```bash
jdbc:hive2://localhost:10000> CREATE TABLE IF NOT EXISTS CLIENTS (
    age INT,
    sexe STRING,
    taux INT,
    situationFamiliale STRING,
    nbEnfantsAcharge INT,
    deuxiemeVoiture BOOLEAN,
    immatriculation STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```

# Migration des donnees du fichier dans la table
```bash
jdbc:hive2://localhost:10000> LOAD DATA LOCAL INPATH '/vagrant/Clients_18.csv' OVERWRITE INTO TABLE CLIENTS;
```
# verifier les donnees
```bash
jdbc:hive2://localhost:10000> select count(*) from CLIENTS;
+---------+
|   _c0   |
+---------+
| 100001  |
+---------+
```

# création d'une view pour combiner tous les clients
```bash
jdbc:hive2://localhost:10000> CREATE OR REPLACE VIEW CLIENTS_UNION as 
 SELECT * from CLIENT_KV_H_EXT
 UNION ALL
 SELECT * FROM CLIENTS;
```


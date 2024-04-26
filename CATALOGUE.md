# import du fichier Catalogue.csv dans mongodb

```bash
$ tail -n +2 /vagrant/Catalogue.csv | mongoimport \
--uri='mongodb://127.0.0.1:27017/automobile?w=majority' \
--collection='catalogues' \
--type=csv \
--columnsHaveTypes \
--fields="marque.string(),nom.string(),puissance.int32(),longueur.string(),nbPlaces.int32(),nbPortes.int32(),couleur.string(),occasion.boolean(),prix.int32()"
```
Le résultat de la commande devrait afficher 
- "connected to: localhost"
- "imported 270 documents"


Pour vérifier si les données sont bien présents dans mongodb

```bash
$ mongo
> use automobile
> db.catalogues.find().count()
> db.catalogues.find().limit(10)
```

Pour quitter mongo, on excécute la commande exit

```bash
> exit
```

Après on se connecte sur hive (username: oracle, password : welcome1)
```bash
$ beeline
beeline> !connect jdbc:hive2://localhost:10000
Enter username for jdbc:hive2://localhost:10000: 
Enter password for jdbc:hive2://localhost:10000: 
```

Une fois connecté, on crée la table externe pointant vers la table catalogues dans mongodb
```bash
0: jdbc:hive2://localhost:10000 > CREATE EXTERNAL TABLE CATALOGUE_MDB_EXT(
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

On vérifie les données

```bash
0: jdbc:hive2://localhost:10000 >  SELECT count(*) FROM CATALOGUE_MDB_EXT;
0: jdbc:hive2://localhost:10000 >  SELECT * FROM CATALOGUE_MDB_EXT LIMIT 5;
```
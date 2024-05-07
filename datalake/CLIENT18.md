# Se connecter a Hive

```bash
$ beeline
> !connect jdbc:hive2://localhost:10000
```

# creation de la table interne

```bash
CREATE TABLE IF NOT EXISTS CLIENTS (
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

# migration des donnees
```bash
LOAD DATA LOCAL INPATH '/vagrant/Clients_18.csv' OVERWRITE INTO TABLE CLIENTS;
```
# verifier les donnees
```bash
select * from CLIENTS limit 100;
```

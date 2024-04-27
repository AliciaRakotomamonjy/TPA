# Lancement de de Kvstore :
 
> nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &

# Copie des fichiers Java dans le répertoire de Kvstore :
>cp /vagrant/MigrationKvstore.java $KVHOME/examples/hello
>cp /vagrant/Marketing.java $KVHOME/examples/hello

# Compilation des classes Java :
>mkdir migrationKv
>javac /$KVHOME/examples/hello/MigrationKvstore.java -d migrationKv
>javac /$KVHOME/examples/hello/MigrationKvstore.java -d migrationKv

# Exécution des ETL 
>java -cp $CLASSPATH:migrationKv MigrationKvstore
>java -cp $CLASSPATH:migrationKv Marketing

# On se connecte a HIVE
>beeline -u jdbc:hive2://localhost:10000

# Creation des tables externes 
CREATE EXTERNAL TABLE CLIENT_KV_H_EXT  (
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

CREATE EXTERNAL TABLE MARKETING_KV_H_EXT(
    IDMARKETING int,
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

# Test des donnees insérées
select * from MARKETING_KV_H_EXT limit 100;







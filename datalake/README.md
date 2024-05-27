# ----------------------------- CLIENT ET MARKETING ---------------------------------

# Lancement de de Kvstore :
nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &

# Copie des fichiers Java dans le répertoire de Kvstore :
cp /vagrant/ClientMarketing.java $KVHOME/examples/hello

# Compilation des classes Java :
mkdir -p migrationKv
javac /$KVHOME/examples/hello/ClientMarketing.java -d migrationKv

# Exécution des ETL 
>java -cp $CLASSPATH:migrationKv ClientMarketing
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import oracle.kv.KVStore;
import oracle.kv.KVStoreFactory;
import oracle.kv.table.TableAPI;
import oracle.kv.table.Table;
import oracle.kv.table.Row;
import oracle.kv.KVStoreConfig;
import java.nio.charset.StandardCharsets;

public class MigrationKvstore {
    public static void main(String[] args) {
        String csvFilePath = "/vagrant/Clients_1.csv"; // Chemin vers le fichier CSV Clients_1
        String kvstoreName = "kvstore"; // Nom du Kvstore
        String kvstoreHost = "localhost"; // Adresse du Kvstore
        int kvstorePort = 5000; // Port du Kvstore

        // Connexion au Kvstore
        KVStore kvstore = KVStoreFactory.getStore(
                new KVStoreConfig(kvstoreName, kvstoreHost + ":" + kvstorePort));

        // Récupération de l'API de table
        TableAPI tableAPI = kvstore.getTableAPI();

        Table table = tableAPI.getTable("CLIENT");
        System.out.println("tableee" + table);

        // Vérification si la table existe déjà
        if (table == null) {
            // Création de la table dans le Kvstore
            tableAPI.executeSync("CREATE TABLE CLIENT (" +
                    "AGE INTEGER, " +
                    "SEXE STRING, " +
                    "TAUX INTEGER, " +
                    "SITUATIONFAMILIALE STRING, " +
                    "NBENFANTSACHARGE INTEGER, " +
                    "DEUXIEMEVOITURE BOOLEAN, " +
                    "IMMATRICULATION STRING, " +
                    "PRIMARY KEY (IMMATRICULATION))");
        }

        // Lecture du fichier CSV et insertion des données dans la table CLIENT
        try {
            List<String> lines = Files.readAllLines(Paths.get(csvFilePath), StandardCharsets.UTF_8);
        
            // Définir une variable booléenne pour suivre si nous sommes à la première ligne ou non
            boolean isFirstLine = true;
        
            for (String line : lines) {
                // Vérifier si nous sommes à la première ligne
                if (isFirstLine) {
                    isFirstLine = false; // Marquer que nous avons déjà passé la première ligne
                    continue; // Passer à la ligne suivante sans traiter la première ligne
                }
                
                String[] values = line.split(",");
                System.out.println("eto"+values[0].trim());
                if (values[0].trim()==" ") {
                    continue; // Passer à la ligne suivante sans traiter la première ligne
                }
                Row row = tableAPI.getTable("CLIENT").createRow();
                row.put("AGE", Integer.parseInt(values[0].trim()));
                row.put("SEXE", values[1].trim());
                row.put("TAUX", Integer.parseInt(values[2].trim()));
                row.put("SITUATIONFAMILIALE", values[3].trim());
                row.put("NBENFANTSACHARGE", Integer.parseInt(values[4].trim()));
                row.put("DEUXIEMEVOITURE", Boolean.parseBoolean(values[5].trim()));
                row.put("IMMATRICULATION", values[6].trim());
                tableAPI.put(row, null, null);
            }
            System.out.println("Données insérées avec succès dans la table CLIENT.");
        } catch (IOException e) {
            e.printStackTrace();
        }
        

        // Fermeture de la connexion au Kvstore
        kvstore.close();
    }
}

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


public class Marketing {
    public static void main(String[] args) {
        String csvFilePath = "/vagrant/Marketing.csv"; // Chemin vers le fichier CSV Marketing
        String kvstoreName = "kvstore"; // Nom du Kvstore
        String kvstoreHost = "localhost"; // Adresse du Kvstore
        int kvstorePort = 5000; // Port du Kvstore

            // Connexion au Kvstore
        KVStore kvstore = KVStoreFactory.getStore(
            new KVStoreConfig(kvstoreName, kvstoreHost + ":" + kvstorePort));

        // Récupération de l'API de table
        TableAPI tableAPI = kvstore.getTableAPI();

        // Vérification si la table existe déjà
        Table table = tableAPI.getTable("MARKETING");
        if (table == null) {
            // Création de la table dans le Kvstore
            tableAPI.executeSync("CREATE TABLE MARKETING (" +
                "IDMARKETING INTEGER, " +
                "AGE INTEGER, " +
                "SEXE STRING, " +
                "TAUX INTEGER, " +
                "SITUATIONFAMILIALE STRING, " +
                "NBENFANTSACHARGE INTEGER, " +
                "DEUXIEMEVOITURE BOOLEAN, " +
                "PRIMARY KEY (IDMARKETING))");
        }

        // Lecture du fichier CSV et insertion des données dans la table MARKETING
        try {
            List<String> lines = Files.readAllLines(Paths.get(csvFilePath));
            for (String line : lines) {
                // Vérifier si nous sommes à la première ligne
                if (isFirstLine) {
                    isFirstLine = false; // Marquer que nous avons déjà passé la première ligne
                    continue; // Passer à la ligne suivante sans traiter la première ligne
                }
                String[] values = line.split(",");
                Row row = tableAPI.getTable("MARKETING").createRow();
                row.put("IDMARKETING", Integer.parseInt(values[0].trim()));
                row.put("AGE", Integer.parseInt(values[1].trim()));
                row.put("SEXE", values[2].trim());
                row.put("TAUX", Integer.parseInt(values[3].trim()));
                row.put("SITUATIONFAMILIALE", values[4].trim());
                row.put("NBENFANTSACHARGE", Integer.parseInt(values[5].trim()));
                row.put("DEUXIEMEVOITURE", Boolean.parseBoolean(values[6].trim()));
                tableAPI.put(row, null, null);
            }
            System.out.println("Données insérées avec succès dans la table MARKETING.");
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Fermeture de la connexion au Kvstore
        kvstore.close();
    }
}

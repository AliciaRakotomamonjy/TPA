

import oracle.kv.KVStore;
import java.util.List;
import java.util.Iterator;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.FaultException;
import oracle.kv.StatementResult;
import oracle.kv.table.TableAPI;
import oracle.kv.table.Table;
import oracle.kv.table.Row;
import oracle.kv.table.PrimaryKey;
import oracle.kv.ConsistencyException;
import oracle.kv.RequestTimeoutException;
import java.lang.Integer;
import oracle.kv.table.TableIterator;
import oracle.kv.table.EnumValue;
import java.io.File;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import java.util.StringTokenizer;


import java.util.ArrayList;
import java.util.List;

public class ClientMarketing {
    private final KVStore store;
    private final String tabClients = "CLIENT";
    private final String tabMarketings = "MARKETING";
    private final String mainPath = "/vagrant";

    /**
     * Parses command line args and opens the KVStore.
     */
	ClientMarketing(String[] argv) {

		String storeName = "kvstore";
		String hostName = "localhost";
		String hostPort = "5000";
        final int nArgs = argv.length;
		int argc = 0;
		store = KVStoreFactory.getStore
		    (new KVStoreConfig(storeName, hostName + ":" + hostPort));
        if(store==null){
            System.out.println("----------Le store est null");
        }
	}

    /**
     * Runs the DDL command line program.
     */
    public static void main(String args[]) {
        try {
			ClientMarketing clm= new ClientMarketing(args);
            clm.initTableAndData(clm);

        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    public void initTableAndData(ClientMarketing clm){
        clm.dropTableClient();
        clm.dropTableMarketing();
        clm.createTableClient();
        clm.createTableMarketing();
        clm.loadClientDataFromFile(mainPath+"/Clients_1.csv");
        clm.loadMarketingDataFromFile(mainPath+"/Marketing.csv");
    }

    /**
		void loadClientDataFromFile(String clientDataFileName)
		cette methodes permet de charger les clients depuis le fichier 
		appelé Clients_1.csv. 
		Pour chaque client chargé, la
		méthide insertAClientRow sera appélée
	*/
	void loadClientDataFromFile(String clientDataFileName){
		InputStreamReader 	ipsr;
		BufferedReader 		br=null;
		InputStream 		ips;
		
		// Variables pour stocker les données lues d'un fichier. 
		String 		ligne; 
		System.out.println("********************************** Dans : loadClientDataFromFile *********************************" );
		
		/* parcourir les lignes du fichier texte et découper chaque ligne */
		try {
			ips  = new FileInputStream(clientDataFileName); 
			ipsr = new InputStreamReader(ips); 
			br   = new BufferedReader(ipsr); 
  
			/* open text file to read data */

			//parcourir le fichier ligne par ligne depuis la deuxième ligne et découper chaque ligne en 
			//morceau séparés par le symbole ; 
            boolean isFirstLine = true; 
			while ((ligne = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                } 
				
				ArrayList<String> clientRecord= new ArrayList<String>();	
				StringTokenizer val = new StringTokenizer(ligne,",");
				while(val.hasMoreTokens()) { 
						clientRecord.add(val.nextToken().toString()); 
				}
				Integer age = null;
				
				try {
					 age		= Integer.parseInt(clientRecord.get(0));
				}catch(Exception e){

				}
				
				String sexe		= clientRecord.get(1);
				int taux		= Integer.parseInt(clientRecord.get(2));
				String situationFamiliale	= clientRecord.get(3);
				int nbEnfantsACharge		= Integer.parseInt(clientRecord.get(4));
				boolean deuxiemeVoiture		= Boolean.parseBoolean(clientRecord.get(5));
				String immatriculation	= clientRecord.get(6);
				System.out.println("age="+age+" sexe="+sexe+" taux="+taux
				+" situationFamiliale="+situationFamiliale+" nbEnfantsACharge="+nbEnfantsACharge+" deuxiemeVoiture="+deuxiemeVoiture
				+" immatriculation="+immatriculation);
				// Add the client in the KVStore
				this.insertAClientRow(immatriculation,age,sexe,taux,situationFamiliale,nbEnfantsACharge,deuxiemeVoiture);
			}
		}
		catch(Exception e){
			e.printStackTrace(); 
		}
	}

    /**
		void loadMarketingDataFromFile(String marketingDataFileName)
		cette methodes permet de charger les clients depuis le fichier 
		appelé Marketing.csv. 
		Pour chaque marketing chargé, la
		méthode insertAMarketingRow sera appélée
	*/
	void loadMarketingDataFromFile(String marketingDataFileName){
		InputStreamReader 	ipsr;
		BufferedReader 		br=null;
		InputStream 		ips;
		
		// Variables pour stocker les données lues d'un fichier. 
		String 		ligne; 
		System.out.println("********************************** Dans : loadClientDataFromFile *********************************" );
		
		/* parcourir les lignes du fichier texte et découper chaque ligne */
		try {
			ips  = new FileInputStream(marketingDataFileName); 
			ipsr = new InputStreamReader(ips); 
			br   = new BufferedReader(ipsr); 
  
			/* open text file to read data */

			//parcourir le fichier ligne par ligne depuis la deuxième ligne et découper chaque ligne en 
			//morceau séparés par le symbole ; 
            boolean isFirstLine = true; 
			while ((ligne = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }  
				

				ArrayList<String> clientRecord= new ArrayList<String>();	
				StringTokenizer val = new StringTokenizer(ligne,",");
				while(val.hasMoreTokens()) { 
						clientRecord.add(val.nextToken().toString()); 
				}
				int age		= Integer.parseInt(clientRecord.get(0));
				String sexe		= clientRecord.get(1);
				int taux		= Integer.parseInt(clientRecord.get(2));
				String situationFamiliale	= clientRecord.get(3);
				int nbEnfantsACharge		= Integer.parseInt(clientRecord.get(4));
				boolean deuxiemeVoiture		= Boolean.parseBoolean(clientRecord.get(5));
				System.out.println("age="+age+" sexe="+sexe+" taux="+taux
				+" situationFamiliale="+situationFamiliale+" nbEnfantsACharge="+nbEnfantsACharge+" deuxiemeVoiture="+deuxiemeVoiture
				);
				// Add the client in the KVStore
				this.insertAMarketingRow(age,sexe,taux,situationFamiliale,nbEnfantsACharge,deuxiemeVoiture);
			}
		}
		catch(Exception e){
			e.printStackTrace(); 
		}
	}

    private void insertAClientRow(String immatriculation, Integer age, String sexe, int taux, String situationFamiliale, 
			int nbEnfantsACharge, boolean deuxiemeVoiture){
		//TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		try {

			TableAPI tableH = store.getTableAPI();
			// The name you give to getTable() must be identical
			// to the name that you gave the table when you created
			// the table using the CREATE TABLE DDL statement.
			Table tableClient = tableH.getTable(tabClients);
			
			// Get a Row instance
			Row clientRow = tableClient.createRow();
			// Now put all of the cells in the row.
			// This does NOT actually write the data to
			// the store.

			// Create one row
			clientRow.put("AGE", age);
			clientRow.put("IMMATRICULATION", immatriculation);
			clientRow.put("DEUXIEMEVOITURE", deuxiemeVoiture);
			clientRow.put("NBENFANTSACHARGE", nbEnfantsACharge);
			clientRow.put("SITUATIONFAMILIALE", situationFamiliale);
			clientRow.put("TAUX", taux);
			clientRow.put("SEXE", sexe);

			// Now write the table to the store.
			// "item" is the row's primary key. If we had not set that value,
			// this operation will throw an 
			// IllegalArgumentException.
	 
			tableH.put(clientRow,null,null);

		} 
		catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} 
		catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}

	}

    private void insertAMarketingRow( int age, String sexe, int taux, String situationFamiliale, 
			int nbEnfantsACharge, boolean deuxiemeVoiture){
		//TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		try {

			TableAPI tableH = store.getTableAPI();
			// The name you give to getTable() must be identical
			// to the name that you gave the table when you created
			// the table using the CREATE TABLE DDL statement.
			Table tableMarketing = tableH.getTable(tabMarketings);
			
			// Get a Row instance
			Row marketingRow = tableMarketing.createRow();
			// Now put all of the cells in the row.
			// This does NOT actually write the data to
			// the store.

			// Create one row
			marketingRow.put("AGE", age);
			marketingRow.put("DEUXIEMEVOITURE", deuxiemeVoiture);
			marketingRow.put("NBENFANTSACHARGE", nbEnfantsACharge);
			marketingRow.put("SITUATIONFAMILIALE", situationFamiliale);
			marketingRow.put("TAUX", taux);
			marketingRow.put("SEXE", sexe);

			// Now write the table to the store.
			// "item" is the row's primary key. If we had not set that value,
			// this operation will throw an 
			// IllegalArgumentException.
	 
			tableH.put(marketingRow,null,null);

		} 
		catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} 
		catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}

	}


    public void dropTableClient() {
		String statement = null;
		
		statement ="drop table "+tabClients;
		executeDDL(statement);
	}

    public void dropTableMarketing() {
		String statement = null;
		statement ="drop table "+tabMarketings;
		executeDDL(statement);
	}

    /**
     * Méthode de création de la table client.
     */
    public void createTableClient() {
        String statement = null;
        statement = "create table " + tabClients + " ("
                + "AGE INTEGER,"
                + "SEXE STRING,"
                + "TAUX INTEGER,"
                + "SITUATIONFAMILIALE STRING,"
                + "NBENFANTSACHARGE INTEGER,"
                + "DEUXIEMEVOITURE BOOLEAN,"
                + "IMMATRICULATION STRING,"
                + "PRIMARY KEY (IMMATRICULATION))";
        executeDDL(statement);
    }

    /**
     * Méthode de création de la table marketing.
     */
    public void createTableMarketing() {
        String statement = null;
        statement = "create table " + tabMarketings + " ("
                + "AGE INTEGER,"
                + "SEXE STRING,"
                + "TAUX INTEGER,"
                + "SITUATIONFAMILIALE STRING,"
                + "NBENFANTSACHARGE INTEGER,"
                + "DEUXIEMEVOITURE BOOLEAN,"
                + "PRIMARY KEY (AGE, SEXE, TAUX, SITUATIONFAMILIALE, NBENFANTSACHARGE,DEUXIEMEVOITURE))";
        executeDDL(statement);
    }



    /**
     * Méthode générique pour executer les commandes DDL
     */
    public void executeDDL(String statement) {
        TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;

        System.out.println("****** Dans : executeDDL ********");
        try {
            /*
             * Add a table to the database.
             * Execute this statement asynchronously.
             */

            result = store.executeSync(statement);
            displayResult(result, statement);
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    /**
     * Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)
     */

    private void displayResult(StatementResult result, String statement) {
        System.out.println("===========================");
        if (result.isSuccessful()) {
            System.out.println("Statement was successful:\n\t" +
                    statement);
            System.out.println("Results:\n\t" + result.getInfo());
        } else if (result.isCancelled()) {
            System.out.println("Statement was cancelled:\n\t" +
                    statement);
        } else {
            /*
             * statement was not successful: may be in error, or may still
             * be in progress.
             */
            if (result.isDone()) {
                System.out.println("Statement failed:\n\t" + statement);
                System.out.println("Problem:\n\t" +
                        result.getErrorMessage());
            } else {

                System.out.println("Statement in progress:\n\t" +
                        statement);
                System.out.println("Status:\n\t" + result.getInfo());
            }
        }
    }
}

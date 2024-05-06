package org.mbds;

import java.io.IOException;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import java.util.regex.Pattern;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import java.io.UnsupportedEncodingException;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.text.DecimalFormat;

public class Co2 {

    private static final Log LOG = LogFactory.getLog(Co2.class);

    //Classe Mapper CO2
    public static class CO2Mapper extends Mapper<LongWritable, Text, Text, Text> {
        private Text outputKey = new Text();
        private Text outputValue = new Text();
        private boolean isHeader = true;
    
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            if (key.get() == 0)return;
    
            String[] fields = value.toString().split(",");
            if (fields.length <= 5) {
                String marqueModele = getMarque(fields[1]);
                String bonusMalus = getBonus(fields[2]);
                String rejetsC02 = fields[3].trim();
                String coutEnergie = getCout(fields[4]);

                String attributs = bonusMalus + "," + rejetsC02 + "," + coutEnergie;
                this.outputKey.set(marqueModele);
                this.outputValue.set(new Text(attributs));
                context.write(this.outputKey, this.outputValue);
            } else if(fields.length > 5){
                String marqueModele = getMarque(fields[1]);
                String bonusMalus = getBonus(fields[3]);
                String rejetsC02 = fields[4].trim();
                String coutEnergie = getCout(fields[5]);

                String attributs = bonusMalus + "," + rejetsC02 + "," + coutEnergie;
                this.outputKey.set(marqueModele);
                this.outputValue.set(new Text(attributs));
                context.write(this.outputKey, this.outputValue);
            }
            
        }

        private String getMarque(String marqueModele) {
            if (marqueModele.contains(" ")) {
                String marque = marqueModele.split(" ")[0];
                marque = marque.replace("\"", "");
                LOG.info("===========> Marque : " + marque);
                return marque;
            }
            return marqueModele;
        }
    
        private String getBonus(String bonusInput) {
            if (bonusInput.equalsIgnoreCase("-")) return "0";
            try {
                byte[] bytes = bonusInput.getBytes("UTF-8");
                bonusInput = new String(bytes, "UTF-8");
                bonusInput = bonusInput.replaceAll("€ 1", "").replaceAll("\\s+", "").replaceAll("€", "");
                bonusInput = garderNombre(bonusInput);
                LOG.info("===========> Bonus : " + bonusInput);
                return bonusInput;
            } catch (UnsupportedEncodingException e) {
                return "-1";
            }
        }

        private String getCout(String coutInput) {
            try {
                byte[] bytes = coutInput.getBytes("UTF-8");
                coutInput = new String(bytes, "UTF-8");
                coutInput = coutInput.replaceAll("€", "").replaceAll(" ", "").replaceAll("\\s", "").replaceAll("\\?", "").replaceAll("\\u00A0", "");
                coutInput = garderChiffres(coutInput);
                LOG.info("===========> Cout final : " + coutInput);
                return coutInput;
            } catch (UnsupportedEncodingException e) {
                return "-1";
            }
        }

        public static String garderChiffres(String texte) {
            Pattern pattern = Pattern.compile("\\D*(\\d+)\\D*");
            Matcher matcher = pattern.matcher(texte);

            StringBuilder chiffres = new StringBuilder();
            
            while (matcher.find()) {
                chiffres.append(matcher.group(1));
            }

            return chiffres.toString();
        }

        public static String garderNombre(String texte) {
            Pattern pattern = Pattern.compile("[-+]?\\d*\\.?\\d+");
            Matcher matcher = pattern.matcher(texte);
            
            StringBuilder chiffres = new StringBuilder();
            
            while (matcher.find()) {
                chiffres.append(matcher.group());
            }
            return chiffres.toString();
        }
    }

    //Classe Reducer CO2
    public static class CO2Reducer extends Reducer<Text, Text, Text, Text> {
        private Text newValue = new Text();

        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            double sumBonusMalus = 0;
            double sumRejet = 0;
            double sumCout = 0;
        
            int taille = 0;
        
            String[] fields = new String[0];
            for (Text val : values) {
                fields = val.toString().split(",");
                if(fields.length == 3) {
                    String cleanedBonusMalus = fields[0].trim().replaceAll("\\s+", "");
                    String cleanedRejet = fields[1].trim().replaceAll("\\s+", "");
                    String cleanedCout = fields[2].trim().replaceAll("\\s+", "");
        
                    sumBonusMalus += Double.parseDouble(cleanedBonusMalus);
                    sumRejet += Double.parseDouble(cleanedRejet);
                    sumCout += Double.parseDouble(cleanedCout);
                }
                taille++;
            }
        
            double[] theValue = new double[3];
            theValue[0]  = taille!= 0? sumBonusMalus / (double) taille : 0;
            theValue[1]  = taille!= 0? sumRejet / (double) taille : 0;
            theValue[2]  = taille!= 0? sumCout / (double) taille : 0;
            
            DecimalFormat df = new DecimalFormat("#.00");

            String newV = df.format(theValue[0]).concat(",").concat(df.format(theValue[1])).concat(",").concat(df.format(theValue[2]));
            this.newValue.set(newV);
            
            context.write(key, this.newValue);
        }
        
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Usage: CO2Driver <input path> <output path>");
            System.exit(-1);
        }

        Job job = Job.getInstance();
        job.setJarByClass(Co2.class);
        job.setJobName("CO2 Calculator");

        job.setMapperClass(CO2Mapper.class);
        job.setReducerClass(CO2Reducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}

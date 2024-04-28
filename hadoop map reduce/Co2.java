package org.mbds;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
import java.util.regex.Pattern;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class Co2 {

    //Classe Mapper CO2
    public static class CO2Mapper extends Mapper<LongWritable, Text, Text, Text> {
        private static final Pattern DELIMITER = Pattern.compile(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
    
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String line = value.toString();
            String[] fields = DELIMITER.split(line);
    
            if (fields.length >= 5) {
                String marqueModele = fields[1].trim();
                String marque = marqueModele.split(" ")[0];
    
                String bonusMalus = cleanBonusMalus(fields[2].trim());
                String emissionCO2 = cleanEmissionCO2(fields[3].trim());
                String coutEnergie = cleanCoutEnergie(fields[4].trim());
    
                String outputValue = bonusMalus + "," + emissionCO2 + "," + coutEnergie;
                context.write(new Text(marque), new Text(outputValue));
            }
        }
    
        private String cleanBonusMalus(String input) {
            String cleanedValue = input.split("€")[0].replaceAll("[+ \\u00A0]", "");
            return cleanedValue.equals("-") ? "0" : cleanedValue;
        }
    
        private String cleanEmissionCO2(String input) {
            return input.replaceAll("[+ \\u00A0]", "");
        }
    
        private String cleanCoutEnergie(String input) {
            return input.split("€")[0].replaceAll("[+ \\u00A0]", "");
        }
    }

    //Classe Reducer CO2
    public static class CO2Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            List<String> modelesEtDetails = new ArrayList<>();
            Map<String, double[]> marqueStats = new HashMap<>();
    
            for (Text value : values) {
                String[] fields = value.toString().split(",");
                if (fields.length >= 4) {
                    String marqueModele = fields[0];
                    String marque = marqueModele.split(" ")[0];
                    double emissionCO2 = Double.parseDouble(fields[1]);
                    double bonusMalus = Double.parseDouble(fields[2].replaceAll("[^0-9.-]", ""));
                    double coutEnergie = Double.parseDouble(fields[3]);
    
                    double[] stats = marqueStats.getOrDefault(marque, new double[3]);
                    stats[0] += bonusMalus;
                    stats[1] += emissionCO2;
                    stats[2] += coutEnergie;
                    marqueStats.put(marque, stats);
    
                    modelesEtDetails.add(marqueModele);
                }
            }
    
            for (Map.Entry<String, double[]> entry : marqueStats.entrySet()) {
                String marque = entry.getKey();
                double[] stats = entry.getValue();
                int count = modelesEtDetails.stream().filter(m -> m.startsWith(marque)).mapToInt(m -> 1).sum();
                double avgBonusMalus = stats[0] / count;
                double avgEmissionCO2 = stats[1] / count;
                double avgCoutEnergie = stats[2] / count;
    
                context.write(new Text(marque), new Text(String.format("%s,%.2f,%.2f,%.2f", marque, avgBonusMalus, avgEmissionCO2, avgCoutEnergie)));
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "CO2 Data Integration");
        job.setJarByClass(Co2.class);
    
        job.setMapperClass(CO2Mapper.class);
        job.setReducerClass(CO2Reducer.class);
    
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
    
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
    
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
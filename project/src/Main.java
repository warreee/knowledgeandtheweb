import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;

public class Main {

    private List<String> strings = new ArrayList<>();

    public static void main(String[] args) throws IOException {
        outerQuery();
    }

    private static void outerQuery() throws IOException {
        String queryString = readFile(System.getProperty("user.dir") + "/queries/ToEpoliticians.rq", Charset.defaultCharset());
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService("http://linkedpolitics.ops.few.vu.nl/sparql/", query);

        try {
            ResultSet results = qexec.execSelect();

            for (; results.hasNext(); ) {
                QuerySolution solution = results.nextSolution();

                    innerQuery(solution.get("person").toString(), "http://dbpedia.org/sparql/");


            }
        } finally {
            qexec.close();
        }

    }

    private static void innerQuery(String resource, String service) throws IOException {
        String queryString = replaceResource(resource);
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService(service, query);

        try {
            ResultSet results = qexec.execSelect();
            System.out.println(resource);
            for (; results.hasNext(); ) {
                QuerySolution solution = results.nextSolution();

                System.out.println(solution);

            }
        } finally {
            qexec.close();
        }

    }

<<<<<<< HEAD
    public static String getSolutionLiteral(QuerySolution solution, String rv) {
        try {
            return solution.getLiteral(rv).getValue().toString();
        } catch (NullPointerException e) {
            return " ";
        }
    }

    public static List<String> readLines(String path) throws IOException {
        return Files.readAllLines(Paths.get(path), Charset.defaultCharset());
=======
    private static List<String> readLines(String path, Charset encoding) throws IOException {
        return Files.readAllLines(Paths.get(path), encoding);
>>>>>>> b019cd76a76e35735647ab50b7a1d931bd448cc3

    }

    private static String replaceResource(String resource) throws IOException{
        return readLines(System.getProperty("user.dir") + "/queries/specificResource.rq", Charset.defaultCharset())
                .stream().map(s -> s.replace("$RESOURCE$", resource)).collect((Collectors.joining("\n")));
    }



    
    public static String readFile(String path)
            throws IOException {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, Charset.defaultCharset());
    }


    public static void writeToCSV(List<String> strings, String fileName) {
        try {
            FileWriter writer = new FileWriter(fileName, true);


            for (int i = 0; i < strings.size() - 1; i++) {

                writer.append(strings.get(i).replace("\n","")).append(", ");
            }

                writer.append(strings.get(strings.size() - 1)).append("\n");


            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void uniques(String fileName) throws Exception {
        List<String> lines = readLines(System.getProperty("user.dir") + "/" + fileName);
        HashSet<String> user = new HashSet<>();
        for (String l : lines) {
            String[] line = l.split(", ");

            user.add(line[0] + line[1]);


        }

        System.out.println(user.size());

    private static String readFile(String path, Charset encoding)
            throws IOException {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, encoding);

    }

}

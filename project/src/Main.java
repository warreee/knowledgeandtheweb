import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.jena.tdb.store.Hash;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;

public class Main {

    private List<String> strings = new ArrayList<>();

    public static void main(String[] args) throws Exception {

        //outerQuery();
        //dbPedia("scientist.rq");
        //dbPedia("economist.rq");
        uniques("data.csv");
    }

    private static void dbPedia(String queryFile) throws IOException {
        String queryString = readFile(System.getProperty("user.dir") + "/queries/" + queryFile);
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService("http://dbpedia.org/sparql/", query);

        try {
            ResultSet results = qexec.execSelect();


            for (; results.hasNext(); ) {
                QuerySolution solution = results.nextSolution();
                System.out.println(solution);
                List<String> res = results.getResultVars().stream().map(rv -> getSolutionLiteral(solution, rv)).collect(Collectors.toList());
                writeToCSV(res, "data.csv");
                System.out.println(solution);
            }


        } finally {
            qexec.close();
        }
    }

    private static void outerQuery() throws IOException {
        String queryString = readFile(System.getProperty("user.dir") + "/queries/ToEpoliticians.rq");
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService("http://linkedpolitics.ops.few.vu.nl/sparql/", query);

        try {

            ResultSet results = qexec.execSelect();
            HashSet<String> seenPersons = new HashSet<>();
            for (; results.hasNext(); ) {
                QuerySolution solution = results.nextSolution();

                if (!seenPersons.contains(solution.get("person").toString())
                        && !solution.get("person").toString().contains("http://dati.camera.it/ocd/persona.rdf")
                        && !solution.get("person").toString().contains("http://purl.org/linkedpolitics")) {
                    innerQuery(solution.get("person").toString(), "http://dbpedia.org/sparql/");

                }
                seenPersons.add(solution.get("person").toString());
            }
        } finally {
            qexec.close();
        }

    }

    private static void innerQuery(String resource, String service) throws IOException {
        String queryString = replaceResource(resource);
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService(service, query);
        System.out.println(resource);
        try {
            ResultSet results = qexec.execSelect();


            for (; results.hasNext(); ) {
                QuerySolution solution = results.nextSolution();
                List<String> res = results.getResultVars().stream().map(rv -> getSolutionLiteral(solution, rv)).collect(Collectors.toList());
                writeToCSV(res, "data.csv");
                System.out.println(solution);
            }


        } finally {
            qexec.close();
        }

    }

    public static String getSolutionLiteral(QuerySolution solution, String rv) {
        try {
            if (rv.equals("by")){
                return solution.getLiteral(rv).getValue().toString().substring(0,4);
            }
            return solution.getLiteral(rv).getValue().toString();
        } catch (NullPointerException e) {
            return " ";
        }
    }

    public static List<String> readLines(String path) throws IOException {
        return Files.readAllLines(Paths.get(path), Charset.defaultCharset());

    }

    private static String replaceResource(String resource) throws IOException {
        return readLines(System.getProperty("user.dir") + "/queries/specificResource.rq")
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

            writer.append(strings.get(0).replace("\n", "") + " " + strings.get(1).replace("\n","")).append(";");
            for (int i = 2; i < strings.size() - 1; i++) {

                writer.append(strings.get(i).replace("\n","")).append(";");
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
        HashSet<String> names = new HashSet<>();
        for (String l : lines) {
            String[] line = l.split(";");

            user.add(line[0]);

            names.add(line[0] + "\n");


        }

        writeListToCSV(new ArrayList<>(names), "names.csv");

        System.out.println(user.size());
    }

    public static void writeListToCSV(List<String> strings, String fileName) {
        try {
            FileWriter writer = new FileWriter(fileName, true);


            for (int i = 0; i < strings.size(); i++) {

                writer.append(strings.get(i));
            }


            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}

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

    private static List<String> readLines(String path, Charset encoding) throws IOException {
        return Files.readAllLines(Paths.get(path), encoding);

    }

    private static String replaceResource(String resource) throws IOException{
        return readLines(System.getProperty("user.dir") + "/queries/specificResource.rq", Charset.defaultCharset())
                .stream().map(s -> s.replace("$RESOURCE$", resource)).collect((Collectors.joining("\n")));
    }


    private static String readFile(String path, Charset encoding)
            throws IOException {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, encoding);
    }

}

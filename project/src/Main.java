import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;

import java.io.*;

public class Main {

    public static void main(String[] args) throws IOException {
        // Open the bloggers RDF graph from the filesystem
        InputStream in = null;
        try {
            in = new FileInputStream(new File("bloggers.rdf"));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        // Create an empty in-memory model and populate it from the graph
        Model model = ModelFactory.createMemModelMaker().createModel("test");
        model.read(in, null); // null base URI, since model URIs are absolute
        in.close();
        // Create a new query
        String queryString =
                "PREFIX foaf: <http://xmlns.com/foaf/0.1/> " +
                        "SELECT ?url " +
                        "WHERE {" +
                        " ?contributor foaf:name \"Jon Foobar\" . " +
                        " ?contributor foaf:weblog ?url . " +
                        " }";
        Query query = QueryFactory.create(queryString);
        // Execute the query and obtain results
        QueryExecution qe = QueryExecutionFactory.create(query, model);
        ResultSet results = qe.execSelect();
        // Output query results
        ResultSetFormatter.out(System.out, results, query);
        // Important - free up resources used running the query
        qe.close();
    }
}

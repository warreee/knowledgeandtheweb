import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

public class Main {

    public static void main(String[] args) {
        // Open the bloggers RDF graph from the filesystem
        InputStream in = new FileInputStream(new File("bloggers.rdf"));
        // Create an empty in-memory model and populate it from the graph
        Model model = ModelFactory.createMemModelMaker().createModel();
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

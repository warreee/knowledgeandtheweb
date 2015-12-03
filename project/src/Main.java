import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;

import java.io.*;

public class Main {

    public static void main(String[] args) throws IOException {
        test2();
    }

    private void test1() throws IOException {
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

    private static  void test2() {
        String queryString=
        "PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>"+
        "PREFIX nobel: <http://data.nobelprize.org/terms/>"+
        "PREFIX foaf: <http://xmlns.com/foaf/0.1/>"+
        "PREFIX yago: <http://yago-knowledge.org/resource/>"+
        "PREFIX viaf: <http://viaf.org/viaf/>"+
        "PREFIX meta: <http://www4.wiwiss.fu-berlin.de/bizer/d2r-server/metadata#>"+
        "PREFIX dcterms: <http://purl.org/dc/terms/>"+
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>"+
        "PREFIX d2r: <http://sites.wiwiss.fu-berlin.de/suhl/bizer/d2r-server/config.rdf#>"+
        "PREFIX dbpedia: <http://dbpedia.org/resource/>"+
        "PREFIX owl: <http://www.w3.org/2002/07/owl#>"+
        "PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>"+
        "PREFIX map: <http://data.nobelprize.org/resource/#>"+
        "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>"+
        "PREFIX freebase: <http://rdf.freebase.com/ns/>"+
        "PREFIX dbpprop: <http://dbpedia.org/property/>"+
        "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>" +
                "SELECT DISTINCT ?label"+
       " WHERE {"+
            "?laur rdf:type nobel:Laureate ."+
                    "?laur rdfs:label ?label ."+
                    "?laur dbpedia-owl:birthPlace <http://data.nobelprize.org/resource/country/Iceland> .}";

        // now creating query object
        Query query = QueryFactory.create(queryString);
        // initializing queryExecution factory with remote service.
        // **this actually was the main problem I couldn't figure out.**
        QueryExecution qexec = QueryExecutionFactory.sparqlService("http://data.nobelprize.org/sparql", query);

        //after it goes standard query execution and result processing which can
        // be found in almost any Jena/SPARQL tutorial.
        try {
            ResultSet results = qexec.execSelect();
            System.out.println(results.getResultVars().size());

            for ( ; results.hasNext();) {
                QuerySolution solution = results.nextSolution();
                System.out.println(solution.getLiteral("label") + " " );

            }
        }
        finally {
            qexec.close();
        }
    }

    private static  void test3() {
        String queryString=
                "PREFIX foaf:<http://xmlns.com/foaf/0.1/> " +
                        "SELECT ?firstname ?lastname WHERE { " +
                        "  ?speaker foaf:givenName ?firstname." +
                        "  ?speaker foaf:familyName ?lastname." +
                        "}";

        // now creating query object
        Query query = QueryFactory.create(queryString);
        // initializing queryExecution factory with remote service.
        // **this actually was the main problem I couldn't figure out.**
        QueryExecution qexec = QueryExecutionFactory.sparqlService("http://linkedpolitics.ops.few.vu.nl/sparql/", query);

        //after it goes standard query execution and result processing which can
        // be found in almost any Jena/SPARQL tutorial.
        try {
            ResultSet results = qexec.execSelect();
            System.out.println(results.getResultVars().size());

            for ( ; results.hasNext();) {
                QuerySolution solution = results.nextSolution();
                System.out.println(solution.getLiteral("firstname") + " " + solution.getLiteral("lastname"));

            }
        }
        finally {
            qexec.close();
        }
    }
}

import org.apache.jena.query.*;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by warreee on 12/16/15.
 */
public class NobelPrize2 {

    public static void main(String[] args) throws Exception {
        //nobelQuery("allNobelNames.rq", "allNobelNames.csv");
        nobelQuery2("allNobelNames_notOnDBPedia.csv", "almaMaterOfPerson_nobel.rq", "almaMaterOfPersonNobel.csv", "almaMaterOfPerson_notOnNobel.csv");
    }

    // Get all names of nobel prize winners from nobelprize.org
    public static void nobelQuery(String queryFile, String resultFile) throws IOException {
        String queryString = Main.readFile("/Users/katrienlaenen/Documents/Eclipse/NobelprizeUniversities/" + queryFile);
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService("http://data.nobelprize.org/sparql", query);

        try {
            ResultSet results = qexec.execSelect();


            for (; results.hasNext(); ) {
                QuerySolution solution = results.nextSolution();
                System.out.println(results.getResultVars());

                List<String> res = results.getResultVars().stream().map(rv -> Main.getSolutionLiteral(solution, rv)).collect(Collectors.toList());
                Main.writeToCSV(res, true, resultFile);
                System.out.println(solution);
            }


        } finally {
            qexec.close();
        }
    }
    
    // Get all universities of nobel prize winners from nobelprize.org which were not found on dbpedia
    public static void nobelQuery2(String namesFile, String queryFile, String resultFile, String notFoundFile) throws IOException {
    	Main2.getUniversitiesOfPersons("allNobelNames_notOnDBPedia.csv", "almaMaterOfPerson_nobel.rq", "almaMaterOfPersonNobel.csv", "allNobelNames_notOnNobel.csv", "http://data.nobelprize.org/sparql");
    }

}

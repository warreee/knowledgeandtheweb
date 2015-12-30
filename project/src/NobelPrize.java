import org.apache.jena.query.*;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by warreee on 12/16/15.
 */
public class NobelPrize {

    public static void main(String[] args) throws Exception {
        nobelQuery("allnobelwinners.rq");
        Main.uniques("data.csv");
    }

    public static void nobelQuery(String queryFile) throws IOException {
        String queryString = Main.readFile(System.getProperty("user.dir") + "/queries/" + queryFile);
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService("http://data.nobelprize.org/sparql", query);

        try {
            ResultSet results = qexec.execSelect();


            for (; results.hasNext(); ) {
                QuerySolution solution = results.nextSolution();
                System.out.println(results.getResultVars());

                List<String> res = results.getResultVars().stream().map(rv -> Main.getSolutionLiteral(solution, rv)).collect(Collectors.toList());
                Main.writeToCSV(res, true, "data.csv");
                System.out.println(solution);
            }


        } finally {
            qexec.close();
        }
    }

}

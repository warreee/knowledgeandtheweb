import org.apache.jena.query.*;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    static int nbNobelWinners;
	static int nbNobelWinnersFound;

    public static void main(String[] args) throws Exception {

       //getUniversitiesOfPersons("allNobelNames.csv", "almaMaterOfPerson.rq", "almaMaterOfPersonDBPedia.csv", "allNobelNames_notOnDBPedia.csv", "http://dbpedia.org/sparql/");
 
    }
    
    static void getUniversitiesOfPersons(String namesFile, String queryFile, String resultFile, String notFoundFile, String sparqlService) throws IOException {
    	String csvFile = "/Users/katrienlaenen/Documents/Eclipse/NobelprizeUniversities/" + namesFile;
    	
    	BufferedReader br = null;
    	String line = "";
    	String cvsSplitBy = ";"; // file has semicolon as separator

    	try {
    		br = new BufferedReader(new FileReader(csvFile));
    		while ((line = br.readLine()) != null) {

    			// Read person name on this line
    			String[] personName = line.split(cvsSplitBy);
    			String firstname = personName[0];
    			String lastname = personName[1];
    			
    			// Print name of person
        		System.out.println("Person [firstname= " + firstname + " , lastname= "
        				+ lastname + "]");
        		
        		// Create and run a query which looks for the universities of that person
        		getUniversityOfPerson(firstname, lastname, queryFile, resultFile, notFoundFile, sparqlService);
        		
        		// Count
        		nbNobelWinners++;
    		}


    	} catch (FileNotFoundException e) {
    		e.printStackTrace();
    	} catch (IOException e) {
    		e.printStackTrace();
    	} finally {
    		if (br != null) {
    			try {
    				br.close();
    			} catch (IOException e) {
    				e.printStackTrace();
    			}
    		}
    	}

    	System.out.println("Done! I found " + nbNobelWinnersFound + " of the " + nbNobelWinners + " Nobel Prize Winners .");
      }

    private static void getUniversityOfPerson(String firstname, String lastname, String queryFile, String resultFile, String notFoundFile, String sparqlService) throws IOException {
        // Read in the query and fill in the firstname and lastname of the person
    	String queryString = replaceFirstnameAndLastname(firstname, lastname, queryFile);
        
    	System.out.println("Query with FIRSTNAME replaced by: " + firstname + " and with LASTNAME replaced by: " + lastname);
    	System.out.println(queryString);
    
        // Run the query
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.sparqlService(sparqlService, query);

        try {
            ResultSet results = qexec.execSelect();

            Boolean found = false;
            
            for (; results.hasNext(); ) {
            	// If we are in this for loop, the person was found
            	found = true;
            	
            	// Get the solution
                QuerySolution solution = results.nextSolution();
                List<String> res = results.getResultVars().stream().map(rv -> getSolutionLiteral(solution, rv)).collect(Collectors.toList());
                
                // Store and show the query result
                writeToCSV2(firstname, lastname, res, true, resultFile);
                
                System.out.println(solution);
            }
            
            if(found){
            	nbNobelWinnersFound++;
            }
            else{
            	// Make a file with all the names of the persons that were not found
            	List<String> strings = new LinkedList<String>();
            	strings.add(firstname);
            	strings.add(lastname);
            	
            	writeToCSV(strings, true, notFoundFile);
            }

        } finally {
            qexec.close();
        }

    }
    
    private static String replaceFirstnameAndLastname(String firstname, String lastname, String queryFile) throws IOException {
        return readLines("/Users/katrienlaenen/Documents/Eclipse/NobelprizeUniversities/" + queryFile)
                .stream().map(s -> (s.replace("$FIRSTNAME$", firstname).replace("$LASTNAME$", lastname))).collect((Collectors.joining("\n")));
    }
    

    public static String getSolutionLiteral(QuerySolution solution, String rv) {
        try {
            return solution.getLiteral(rv).getValue().toString();
        } catch (NullPointerException e) {
            return " ";
        }
    }

    public static List<String> readLines(String path) throws IOException {
        return Files.readAllLines(Paths.get(path), Charset.defaultCharset());

    }

    public static String readFile(String path)
            throws IOException {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, Charset.defaultCharset());
    }


    public static void writeToCSV(List<String> strings, boolean nobel, String fileName) {
        try {
            FileWriter writer = new FileWriter(fileName, true);

            writer.append(strings.get(0).replace("\n", "") + ";" + strings.get(1).replace("\n", "")).append("\n");
          

            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public static void writeToCSV2(String firstname, String lastname, List<String> strings, boolean nobel, String fileName) {
        try {
            FileWriter writer = new FileWriter(fileName, true);

            writer.append(firstname + "*" + lastname + ";" + strings.get(0).replace("\n", "").replace(";"," ") + "\n");

            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
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

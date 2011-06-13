import java.io.*;
import java.util.ArrayList; 
import java.sql.*;



public class DictionaryParserThree {
	
	class TermItem {
		int ID;
		String theWord;
		int gutenbergRating;		
	}	
	
	class DefinitionItem {
		int ID;
		int termID;
		String theDefinition;		
	}
	
	class SentenceItem {
		int definitionID;
		String theSampleSentence;		
	}
	
	static int NUM_SEARCH_TERMS = 99753;  
    Connection conn;
    Statement stat;


	
	public void createDatabase() {
		conn = null;
		try {
			Class.forName("org.sqlite.JDBC");
		    conn = DriverManager.getConnection("jdbc:sqlite:dictionary2.db");
		    Statement stat = conn.createStatement();
		    stat.executeUpdate("drop table if exists termList;");  
		    stat.executeUpdate("create table termList (ID integer, Term string, GutenbergRating integer);");
		    stat.executeUpdate("drop table if exists definitionList;"); 
		    stat.executeUpdate("create table definitionList (ID integer, TermID integer, Definition string);");
		    stat.executeUpdate("drop table if exists sentenceList;"); 
		    stat.executeUpdate("create table sentenceList (DefinitionID integer, SampleSentence string);");
			   
		
		} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  	
	}
	
public void writeAllItemsToDatabase(ArrayList<TermItem>termList, 
									ArrayList<DefinitionItem>definitionList,
									ArrayList<SentenceItem>sentenceList) {
		
		try {			
			//  Check if single quote exists in definition or term anywhere.  Plenty of instances of
			//  two consecutive single quotes exist, which is fine for sqLite to process...  
			//  but one single quote causes an exception and needs to be padded with an additional 
			//  single quote.
		    // conn.setAutoCommit(false);
			
		   stat = conn.createStatement();
		   for (int i = 0; i < termList.size(); i++) {
		    	
		    	TermItem item = termList.get(i);
		    	
		    	item.theWord = item.theWord.replaceAll("'", "''");    	
				stat.addBatch("insert into termList values(" +
			    		item.ID +
			    		", '" +
			    		item.theWord +
			    		"'," +
			    		item.gutenbergRating +
			    		")");	
				

		    }
		   
			stat.executeBatch();
	    	stat = conn.createStatement();
	    	
		    for (int i = 0; i < definitionList.size(); i++) {   				   	
		    	
		    	DefinitionItem item = definitionList.get(i);	
		    	//  Pad single quotes with an extra one to write to database.
		    	//  Then, add an extra space after the i tag, because once stripped, it crams the sentence with the source.
		    	//  Finally, strip all tags.
		    	item.theDefinition = item.theDefinition.replaceAll("'", "''");
		    	String stringWithTagsStripped = item.theDefinition.replaceAll("\\<.*?>","");
		    	
		    	
				stat.addBatch("insert into definitionList values(" +
			    		item.ID +
			    		"," +
			    		item.termID +
			    		", '" +
			    		stringWithTagsStripped +
			    		"')");		
		    }
			stat.executeBatch();	
		   
		    
			for (int i = 0; i < sentenceList.size(); i++) {
				
				SentenceItem item = sentenceList.get(i);
				//  Pad single quotes with an extra one to write to database.
		    	//  Then, add an extra space after the i tag, because once stripped, it crams the sentence with the source.
		    	//  Finally, strip all tags.
		    	item.theSampleSentence = item.theSampleSentence.replaceAll("'", "''");
		    	String stringWithTagsStripped = item.theSampleSentence.replaceAll("</i>", "</i> ");
		    	stringWithTagsStripped = stringWithTagsStripped.replaceAll("\\<.*?>","");
				
				stat.addBatch("insert into sentenceList values(" +
			    		item.definitionID +
			    		", '" +
			    		stringWithTagsStripped +
			    		"')");		
				
			}
			
			stat.executeBatch();
			
		    		    
			stat.close();
			conn.close();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  		
	}	

    public static void main(String arg[]) {
    	
    	//  Files for input and output
    	File wordListFile = new File("WordList.txt");
    	File definitionsFile = new File ("DefinitionsAndSentences.txt");    	
    	File outputFile = new File ("debug.txt"); 
    	
    	InputStream inputStreamOne;
     	InputStreamReader readerOne;
    	BufferedReader binOne;
    	
    	InputStream inputStreamTwo;
     	InputStreamReader readerTwo;
    	BufferedReader binTwo;
    	
    	OutputStream outputStream;
     	OutputStreamWriter writerTwo;
    	BufferedWriter binThree;
    	   	
    	
    	//  Lists to store data to write to database
    	ArrayList<TermItem>databaseTermList = new ArrayList<TermItem>();
    	ArrayList<DefinitionItem>databaseDefinitionList = new ArrayList<DefinitionItem>();
    	ArrayList<SentenceItem>databaseSampleSentenceList = new ArrayList<SentenceItem>();
    	
    	//  Create instance to use in main()
    	DictionaryParserThree myInstance = new DictionaryParserThree();
    	
    	int totalTermCounter = 1;
    	int totalDefinitionCounter = 1;

		try {
			
			myInstance.createDatabase();
			//  Open streams for reading data from both files
			inputStreamOne = new FileInputStream(wordListFile);
	     	readerOne= new InputStreamReader(inputStreamOne);
	    	binOne= new BufferedReader(readerOne);
	    	
	    	inputStreamTwo = new FileInputStream(definitionsFile);
	     	readerTwo= new InputStreamReader(inputStreamTwo);
	    	binTwo= new BufferedReader(readerTwo);
	    	
	    	outputStream = new FileOutputStream(outputFile);
	     	writerTwo= new OutputStreamWriter(outputStream);
	    	binThree= new BufferedWriter(writerTwo);

	    	String inputLineTwo;
	    	String termArray[] = new String[NUM_SEARCH_TERMS];
	    	
	    	//  Populate string array with all definitions.
	    	for (int i = 0; (inputLineTwo = binTwo.readLine()) != null; i++) {
		    	 termArray[i] = inputLineTwo;  
	    	}	    	
	    	
	    	//  Read each line from the input file (contains top gutenberg words to be used)
	    	String inputLineOne;
	    	int gutenbergCounter = 0;
	    	while ((inputLineOne = binOne.readLine()) != null) {
	    		
	    		
	    		//  Each line contains three or four words.  Grab each word inside double brackets.
		    	String[] splitString = (inputLineOne.split("\\[\\["));  		    	
	    		for (String stringSegment : splitString) {
	    			
	    			if (stringSegment.matches((".*\\]\\].*")))
	    			{
	    				//  Increment counter to track Gutenberg rating (already from lowest to highest)
	    				gutenbergCounter++;
	    	    		
	    				boolean isCurrentTermSearchComplete = false;
	    		    	int lowerIndex = 0;
	    		    	int upperIndex = NUM_SEARCH_TERMS - 1;
	    		    	
	    		    	String searchTermOne = stringSegment.substring(0, stringSegment.indexOf("]]"));
	    		    	searchTermOne = searchTermOne.substring(0, 1).toUpperCase() + searchTermOne.substring(1);
	    		    	
	    				while (!isCurrentTermSearchComplete) {
	    					
	    					//  Go to halfway point of lowerIndex and upperIndex.
	    					String temp = termArray[(lowerIndex + upperIndex)/2];
	    					String currentTerm = temp.substring(temp.indexOf("<h1>") + 4, temp.indexOf("</h1>"));
	    						    					
	    	    	    					
	    					//  If definition term is lexicographically lower, need to increase lower Index
	    					//  and search higher.
	    					//  If definition term is lexicographically higher, need decrease upper index
	    					//  and search higher.
	    					//  If a match is found, need to find first definition, and record each definition
	    					//  in case of duplicates.
	    					
	    					if (currentTerm.compareTo(searchTermOne) < 0) {	    						
	    						lowerIndex = (lowerIndex + upperIndex)/2;
	    					}
	    					else if (currentTerm.compareTo(searchTermOne) > 0) {
	    						upperIndex = (lowerIndex + upperIndex)/2;   						
	    					}   					
	    					
	    					else {	
	    						//  Backtrack row-by-row until we reach the first term in the set.  Once we reach the beginning,
	    						//  cycle through each match in the set and obtain each definition until we reach the an unmatching term.

	    						//else {
	    							System.out.println(searchTermOne);
		    						int k = (lowerIndex + upperIndex)/2;
		    						boolean shouldIterateAgain = true;
		    						while (shouldIterateAgain) {
		    							
		    							if (k <= 0 || k >= NUM_SEARCH_TERMS) {
			    							shouldIterateAgain = false;
			    						}
		    							else {
				    						String current = termArray[k].substring(termArray[k].indexOf("<h1>") + 4, termArray[k].indexOf("</h1>"));
				    						String previous = termArray[k - 1].substring(termArray[k - 1].indexOf("<h1>") + 4, termArray[k - 1].indexOf("</h1>"));
					       					
				    						if (current.compareTo(previous) == 0) {			
				    							k--;
				    						}
					       					else {
					       						shouldIterateAgain = false;
					       					}
		    							}
		    						}  
		    						shouldIterateAgain = true;
		    						while (shouldIterateAgain) {
		    									    	
		    							//  Used to store data to later pass to DB
		    					        DictionaryParserThree.TermItem tempTermItem = myInstance.new TermItem();

		    					        //  Determine unique ID (which will be written to DB later)
		    					        //  Add current term and gutenberg rating.
		    					        tempTermItem.ID = totalTermCounter;		    					      	    					      
		    					    	tempTermItem.theWord = searchTermOne;   //  same as termArray[k]'s term
		    					 
		    							tempTermItem.gutenbergRating = gutenbergCounter;
		    							databaseTermList.add(tempTermItem);
		    							binThree.write("Term ID " + tempTermItem.ID + "  " + tempTermItem.theWord + "  guten rank is " + tempTermItem.gutenbergRating);
		    							binThree.newLine();							
		    				    		splitString = termArray[k].split("<def>");
		    				    		
		    				    		int m = 0;
	    					    		for (String stringSegment2 : splitString) {
	    					    			if (stringSegment2.matches(".*</def>.*") && m > 0) {
	    					    				
	    					    				//  Determine unique ID (which will be written to DB later)
	    					    				//  Add definition, as well as term ID it is associated with.
	    					    				DictionaryParserThree.DefinitionItem tempDefinitionItem = myInstance.new DefinitionItem();
	    					    				tempDefinitionItem.ID = totalDefinitionCounter;
	    					    				tempDefinitionItem.theDefinition = stringSegment2.substring(0, stringSegment2.indexOf("</def>"));
	    						    			tempDefinitionItem.termID = totalTermCounter;
	    						    			databaseDefinitionList.add(tempDefinitionItem);

	    						    			int n = 0;
	    						    			String[] splitString2 = (stringSegment2.split("<blockquote>")); 
	    	    					    		for (String stringSegment3 : splitString2) {
	    	    					    			if (stringSegment3.matches(".*</blockquote>.*") && n > 0) {
	    	    					    				//  Add data which will be added to DB later.
	    	    					    				//  Add sample sentence as well as the definition ID it is associated with.
	    	    					    				DictionaryParserThree.SentenceItem tempSentenceItem = myInstance.new SentenceItem();	
	    	    					    				tempSentenceItem.definitionID = totalDefinitionCounter;
	    	    					    				tempSentenceItem.theSampleSentence = stringSegment3.substring(0, stringSegment3.indexOf("</blockquote>"));
	    	    					    				databaseSampleSentenceList.add(tempSentenceItem);	    	    					    				
	    	    	    					    		
	    	    					    				binThree.write("Definition is" + tempDefinitionItem.theDefinition);
	    	    					    				binThree.newLine();
	    	    					    				binThree.write("     and sample sentence is " + tempSentenceItem.theSampleSentence);
	    	    		    							binThree.newLine();	
	    	    					    			}
	    	    					    			//  Increment counter for split string (for this line's sample sentence)
	    	    					    			n++;
	    	    					    		}
	    	    					    		totalDefinitionCounter++;
	    					    			}
	    					    			//  Increment counter for split string (for this line's definition)
	    				    				m++;
	    				    				
	    					    		}	    	    					    		
	    					    			    							
		    							totalTermCounter++;
		    							
		    							//  Compare next definition and see if duplicate exists.
		    							//  If so, add to string array.
	    					    		if (k < 0 || k >= NUM_SEARCH_TERMS - 1) {
			    							shouldIterateAgain = false;
			    						}
	    					    		else {   	    					    		
			    							String current = termArray[k].substring(termArray[k].indexOf("<h1>") + 4, termArray[k].indexOf("</h1>"));
				    						String next = termArray[k + 1].substring(termArray[k + 1].indexOf("<h1>") + 4, termArray[k + 1].indexOf("</h1>"));
					    					if (current.compareTo(next) == 0) {	
				    							k++;
				    						}
				    						else {
				    							shouldIterateAgain = false;
				    						}
	    					    		}
			   						//}	    						
		    						isCurrentTermSearchComplete = true;
		    						
	    						}
	    					}
	    					
	    					//  If the term does not exist in the database.
	    					if (Math.abs(upperIndex) - Math.abs(lowerIndex) <= 1)
	    					{
    							  isCurrentTermSearchComplete = true;
	    					}
	    				}
	    			}
	    		}   	    		
	    	}
	    	
	    	    	
	    	System.out.println("ended search.");	
	    	myInstance.writeAllItemsToDatabase(databaseTermList, databaseDefinitionList, databaseSampleSentenceList);	
	    	System.out.println("ended write.");
	    	
	    	binOne.close();
	    	readerOne.close();
	    	inputStreamOne.close();	    	
	    	
	    	binTwo.close();
	    	readerTwo.close();
	    	inputStreamTwo.close();	    	
	    	
	    	binThree.close();  
	    	writerTwo.close();
	    	outputStream.close();
	    	System.exit(0);


	    	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}    	
    }
}



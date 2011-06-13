import java.io.*;
import java.lang.*;

import java.util.ArrayList;

class WordListItem {
	String theWord;
	String partOfSpeech;
	String definition;
	int guttenbergRating;		
}	


public class DictionaryParserTwo {

	static int NUM_LINES = 875985;
	
	public static void main(String[] args) {
		File inputFile = new File("gutenbergDefinitions.txt");
    	File outputFile = new File ("gutenbergDefinitions2.txt");
    	// ArrayList<WordListItem>databaseSetList = new ArrayList<WordListItem>();
    	DictionaryParserTwo myInstance = new DictionaryParserTwo();

		try {
			
			//  Open streams for reading data from both files
			InputStream inputStream = new FileInputStream(inputFile);
	     	InputStreamReader readerOne= new InputStreamReader(inputStream);
	    	BufferedReader binOne= new BufferedReader(readerOne);
	    	
	    	OutputStream outputStream = new FileOutputStream(outputFile);
	     	OutputStreamWriter writerTwo= new OutputStreamWriter(outputStream);
	    	BufferedWriter binTwo= new BufferedWriter(writerTwo);

	    	String inputLine;
	    	//String inputStringArray[] = new String[NUM_LINES];
	    	
	    	//  Populate string array with all definitions.
	    	//int i = 0;
	    	String term;
	    	String testTerm;
	    	while ((inputLine = binOne.readLine()) != null) {
	    		
	    		if (inputLine.matches(".*<h1>.*") && inputLine.matches(".*</h1>.*")) { 
	    			term = inputLine.substring(inputLine.indexOf("<h1>"), inputLine.indexOf("</h1>") + 5);
	    			testTerm = inputLine.substring(inputLine.indexOf("<h1>") + 4, inputLine.indexOf("</h1>"));
	    			
	    			//  Scan through text and look for any terms that contain junk characters
	    			//  or any non-letters besides apostrophes and hyphens.  
	    			boolean canWrite = true;
	    			for (int x = 0; x < testTerm.length(); x++) {
	    				char temp = testTerm.charAt(x);
	    				String temp2 = (Character.toString(temp)).toUpperCase();
	 	    				
	    				if(temp2.compareTo("A") < 0 || temp2.compareTo("Z") > 0) {	    						
							if(temp2.compareTo("'") != 0) {//  && (temp2.compareTo("-") != 0)) {
								canWrite = false;
		    					break;
							}	
	    				}
	    			}
	    			
	    			if (canWrite) {
	    				binTwo.write(term);
	    				binTwo.newLine();
	    			}
	    		}
	    		
	    		if (inputLine.matches(".*<def>.*")) {
	    			String[] splitString = inputLine.split("<def>");
	    			
	    			int j = 0;
		    		for (String stringSegment : splitString) {
		    			if (stringSegment.matches(".*</def>.*") && j > 0) {
			    			term = stringSegment.substring(0, stringSegment.indexOf("</def>") + 6);
			    			binTwo.write("<def> " + term);
		    			}
	    				j++;
		    		}
	    		}
	    		if (inputLine.matches(".*<blockquote>.*")) {
	    			term = inputLine.substring(inputLine.indexOf("<blockquote>"));
	    			binTwo.write(term);
	    		}	
	    		if (inputLine.matches(".*/blockquote>")) {
	    			term = inputLine;
	    			binTwo.write(term);
	    		}
	    	}
	    	binTwo.close();
	    	writerTwo.close();
	    	outputStream.close();
	    	binOne.close();
	    	readerOne.close();
	    	inputStream.close();
	    	System.exit(0);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

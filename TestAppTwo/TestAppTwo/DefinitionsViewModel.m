//
//  DefinitionsViewModel.m
//  TestAppTwo
//
//  Created by Mike on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DefinitionsViewModel.h"

@implementation DefinitionsViewModel
@synthesize theTerm;
@synthesize definitionsAndSampleSentences;
@synthesize gutenbergRating;


- (id)init {
    // XXX: No need to call super since you call an overrided constuctor that calls super
    self = [super init];
    if (self) {
        [self initWithTerm:nil];
    }
    return self;
}

//  Allow initialization with term
- (id)initWithTerm:(NSString *) term {
    
    self = [super init];
    if (self) {
        // XXX: [string count] > 0 is a better "is null or empty" check
        if (term != nil) {
            theTerm = [[NSString alloc] initWithString:term];
            // XXX: So if term is nil, you dont init a database?
            [self initializeDatabase];
            [self getTermInformation];
        }
    }
    return self;
}

- (void)dealloc {
    [theTerm release];
    [definitionsAndSampleSentences release];
    [super dealloc];
}

//  Create database if it doesn't exist in documents directory, then open.
- (BOOL)initializeDatabase {

    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"dictionaryTerms.db"];
    
    //  If DB file does not exist yet, attempt to write to documents directory.
    if (![fileManager fileExistsAtPath:writableDBPath]) {
        
        NSString * defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dictionaryTerms.db"];
        if (![fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error]) {
            NSAssert(0, @"Mike, you failed to created database file with message '%@'.", [error localizedDescription]);
            return NO;
        } 
    }
    
    //  Attempt to open database.
    if (!sqlite3_open([writableDBPath UTF8String], &theDatabase) == SQLITE_OK) {
            NSAssert(0, @"Mike, you failed to open database file with message '%@'.", [error localizedDescription]);
            return NO;
    }
    
    return YES;
}

//  Call to scan database for all definitions associated with the search term.
//  Sample sentences currently unsupported.
- (BOOL) getTermInformation {
    
    sqlite3_stmt *selectStatementOne;
    sqlite3_stmt *selectStatementTwo;
    sqlite3_stmt *selectStatementThree;
    //sqlite3_stmt *selectStatementFour;
    
    NSString * getTermIDRequestInSQL = [NSString stringWithFormat:@"SELECT ID FROM termList WHERE Term LIKE \"%@\"", self.theTerm];
    NSString * getGutenbergRankRequestInSQL;
    NSString * getDefinitionAndDefinitionIDInSQL;
    //NSString * getSampleSentenceInSQL;
    NSMutableArray * currentDefinitionsArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray * currentSampleSentencesArray = [[NSMutableArray alloc] initWithCapacity:0]; 

    //  Get set of term IDs based on the search term.  Iterate through.
    if (sqlite3_prepare_v2(theDatabase, [getTermIDRequestInSQL UTF8String], -1, &selectStatementOne, nil)  == SQLITE_OK) {
        
        int currentTermID;
        while (sqlite3_step(selectStatementOne) == SQLITE_ROW) {
            currentTermID = sqlite3_column_int(selectStatementOne, 0);
         
            //  Get gutenberg rating based on ID of the search term.
            getGutenbergRankRequestInSQL = [NSString stringWithFormat:@"SELECT GutenbergRating FROM termList WHERE ID = %d", currentTermID];
            if (sqlite3_prepare_v2(theDatabase, [getGutenbergRankRequestInSQL UTF8String], -1, &selectStatementTwo, nil)  == SQLITE_OK) {

                while (sqlite3_step(selectStatementTwo) == SQLITE_ROW) {
                    
                    self.gutenbergRating = sqlite3_column_int(selectStatementTwo, 0);
                }
            } else {
                NSAssert(0, @"Mike, you failed to get gutenberg rank with error message '%@'.", sqlite3_errmsg(theDatabase));
            }
            
            
            //  Get definition and definitionID based on ID of the search term.
            getDefinitionAndDefinitionIDInSQL = [NSString stringWithFormat:@"SELECT Definition, ID FROM definitionList WHERE TermID = %d", currentTermID];
            if (sqlite3_prepare_v2(theDatabase, [getDefinitionAndDefinitionIDInSQL UTF8String], -1, &selectStatementThree, nil)  == SQLITE_OK) {

                while (sqlite3_step(selectStatementThree) == SQLITE_ROW) {
                    // get definition
                    [currentDefinitionsArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatementThree, 0)]];
                    
                    // XXX: Memory leak with currentSubSampleSentencesArray
                    // get definition, then prepare to get all associated sample sentences with that definition
                    //int definitionID = sqlite3_column_int(selectStatementThree, 1);
                    NSMutableArray * currentSubSampleSentencesArray = [[NSMutableArray alloc] initWithCapacity:0];
                    
                    //  Under construction until able to display better in DefinitionsViewController
                    /*getSampleSentenceInSQL = [NSString stringWithFormat:@"SELECT SampleSentence FROM sentenceList WHERE DefinitionID = %d", definitionID];
                    if (sqlite3_prepare_v2(theDatabase, [getSampleSentenceInSQL UTF8String], -1, &selectStatementFour, nil)  == SQLITE_OK) {
                        
                        while (sqlite3_step(selectStatementFour) == SQLITE_ROW) {
                            
                            [currentSubSampleSentencesArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatementFour, 0)]];
                       
                        }
                    } else {
                        NSAssert(0, @"Mike, you failed to get sample sentences with error message '%@'.", sqlite3_errmsg(theDatabase));

                    }  */

                    //  If no sample sentences exist, pass an empty string rather than nil, so as not to signal termination of the array
                    //if ([currentSampleSentencesArray count] == 0) {
                        [currentSubSampleSentencesArray addObject:@""];
                    //}
                    [currentSampleSentencesArray addObject:currentSubSampleSentencesArray];
                    
                }
            } else {
                NSAssert(0, @"Mike, you failed to get definition with error message '%@'.", sqlite3_errmsg(theDatabase));
            }  
        }
    } else {
        NSAssert(0, @"Mike, you failed to get term ID with error message '%@'.", sqlite3_errmsg(theDatabase));
    }
        
    self.definitionsAndSampleSentences = [NSDictionary dictionaryWithObjects:currentSampleSentencesArray forKeys:currentDefinitionsArray];
        
    return YES;
}

@end

//
//  DefinitionsViewModel.h
//  TestAppTwo
//
//  Created by Mike on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <sqlite3.h>

#import <Foundation/Foundation.h>
#import <sqlite3.h>

//  Model for querying database.
@interface DefinitionsViewModel : NSObject {

    sqlite3 * theDatabase;
    NSString * theTerm;
    NSDictionary * definitionsAndSampleSentences;
    int gutenbergRating;

}

@property (nonatomic, copy) NSString * theTerm;
@property (nonatomic, retain) NSDictionary * definitionsAndSampleSentences;
@property (nonatomic, assign) int gutenbergRating;


- (id)initWithTerm:(NSString *) term;
- (BOOL)initializeDatabase;
- (BOOL)getTermInformation;


@end

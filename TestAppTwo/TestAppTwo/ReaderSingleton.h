//
//  ReaderSingleton.h
//  TestAppTwo
//
//  Created by Mike on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// XXX: Change name of class. i.e. TextManager (singleton pattern should be implied)

//  Used to keep track of the user's text while switching between views via
//  the tab bar controller.
@interface ReaderSingleton : NSObject {
    
    NSString *currentText;
}

// XXX: Strings should be copy, not retain

@property (nonatomic,retain) NSString *currentText;
    
// XXX: Should be sharedInstance
+ (ReaderSingleton*) sharedAppInstance;

@end


    



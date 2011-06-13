//
//  ReaderSingleton.h
//  TestAppTwo
//
//  Created by Mike on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//  Used to keep track of the user's text while switching between views via
//  the tab bar controller.
@interface TextManager : NSObject {
    
    NSString *currentText;
}

@property (nonatomic,copy) NSString *currentText;

+ (TextManager*) sharedInstance;

@end


    



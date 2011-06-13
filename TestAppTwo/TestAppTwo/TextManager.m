//
//  ReaderSingleton.m
//  TestAppTwo
//
//  Created by Mike on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextManager.h"

@implementation TextManager
@synthesize currentText;

static TextManager *sharedInstance;

+(TextManager*) sharedInstance {
    
    @synchronized(self){
        if(!sharedInstance){
            sharedInstance = [[TextManager alloc] init];
        }
    }
    
    return sharedInstance;
}


@end




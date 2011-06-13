//
//  ReaderSingleton.m
//  TestAppTwo
//
//  Created by Mike on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReaderSingleton.h"

@implementation ReaderSingleton

@synthesize currentText;

+(ReaderSingleton*) sharedAppInstance {
    static ReaderSingleton *sharedAppInstance;
    
    @synchronized(self){
        if(!sharedAppInstance){
            sharedAppInstance = [[ReaderSingleton alloc] init];
        }
    }
    
    return sharedAppInstance;
}

-(void)dealloc { 
    [currentText release];
    [super dealloc];
}
@end




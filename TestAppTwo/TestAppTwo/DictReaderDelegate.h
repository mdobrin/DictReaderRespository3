//
//  TestAppTwoAppDelegate.h
//  TestAppTwo
//
//  Created by Mike on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderTextViewController.h"

@interface DictReaderDelegate : NSObject <UIApplicationDelegate> {
    
    IBOutlet UITabBarController *theTabBarController;
    IBOutlet UIWindow * window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *theTabBarController;

@end

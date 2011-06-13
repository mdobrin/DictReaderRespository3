//
//  TestAppTwoAppDelegate.m
//  TestAppTwo
//
//  Created by Mike on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DictReaderDelegate.h"

@implementation DictReaderDelegate

@synthesize window=_window;
@synthesize theTabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    //Tab Bar init
	UITabBarController * temp = [[[UITabBarController alloc] init] autorelease];
    self.theTabBarController = temp;
    
    
    //  Array to hold two navigation controllers (Read/Write, Read) and two view controllers (File, Information)
    NSMutableArray *localControllersArray = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    
    //  Add navigation controller to NSArray which contains Read/Write editor, plus its corresponding tab bar item
    
    ReaderTextViewController * tempReaderTextViewController = [[[ReaderTextViewController alloc] initWithReadOnlyOn:NO] autorelease];
    tempReaderTextViewController.title = @"Edit Mode";
    UINavigationController * tempNavigationController = [[[UINavigationController alloc] initWithRootViewController:tempReaderTextViewController] autorelease];
    UITabBarItem * tempTabBarItem = [[[UITabBarItem alloc] init] autorelease];
    tempTabBarItem.image = [UIImage imageNamed:@"pencil.png"];
    tempNavigationController.tabBarItem = tempTabBarItem;
    tempNavigationController.title = @"Edit";
    [localControllersArray addObject:tempNavigationController];
    
    //  Change read only value to YES for currently existing view controller, change text of its tab bar item,
    //  add these to a new UINavigation Controller initialized with them, then add to array.
    
    ReaderTextViewController * tempReaderTextViewController2 = [[[ReaderTextViewController alloc] initWithReadOnlyOn:YES] autorelease];
    tempReaderTextViewController2.title = @"Read Mode";
    UINavigationController * tempNavigationController2 = [[[UINavigationController alloc] initWithRootViewController:tempReaderTextViewController2] autorelease];
    UITabBarItem * tempTabBarItem2 = [[[UITabBarItem alloc] init] autorelease];
    tempTabBarItem2.image = [UIImage imageNamed:@"glasses.png"];
    tempNavigationController2.tabBarItem = tempTabBarItem2;
    tempNavigationController2.title = @"Read";
    [localControllersArray addObject:tempNavigationController2];
    
    //  Add View Controller with import tab bar item to the array for importing .txt files
    
    UIViewController * importViewController = [[[UIViewController alloc] init] autorelease];
    UITabBarItem * tempTabBarItem3 = [[[UITabBarItem alloc] init] autorelease];
    importViewController.tabBarItem = tempTabBarItem3;
    tempTabBarItem3.title = @"Import";
    tempTabBarItem3.image = [UIImage imageNamed:@"file.png"];
    UILabel * notice = [[[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 40)] autorelease];
    notice.text = @"Under Construction.";
    notice.textAlignment = UITextAlignmentCenter;
    UIColor * greenWhite = [UIColor colorWithRed:231.0f/255.0f green:244.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
    notice.backgroundColor = greenWhite;
    importViewController.view.backgroundColor = greenWhite;
    [importViewController.view addSubview:notice];
    [localControllersArray addObject:importViewController];
    
    //  Add View Controller with import tab bar item to the array for displaying app info
    
    UIViewController * infoViewController = [[[UIViewController alloc] initWithNibName:@"InfoViewController" bundle:nil] autorelease];
    UITabBarItem * tempTabBarItem4 = [[[UITabBarItem alloc] init] autorelease];
    infoViewController.tabBarItem = tempTabBarItem4;
    tempTabBarItem4.title = @"Info";
    tempTabBarItem4.image = [UIImage imageNamed:@"info.png"];
    [localControllersArray addObject:infoViewController];
    
    
    // load up our tab bar controller with the view controllers
    self.theTabBarController.viewControllers = localControllersArray;
    [self.window addSubview:self.theTabBarController.view];
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end

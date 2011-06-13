//
//  ReaderTextViewController.m
//  DictReader
//
//  Created by Mike on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReaderTextViewController.h"
#import "ReaderSingleton.h"

@implementation ReaderTextViewController
@synthesize textViewer;


//  Initialize view controller.  By default, read only is set to NO
- (id) init { 
    // XXX: No need to call super since you call an overrided constuctor that calls super
    self = [super init];
    if (self) {
        [self initWithReadOnlyOn:NO];
    }
    return self;
    
}

//  Custom initialize with read only turned on or off.
- (id) initWithReadOnlyOn:(BOOL)isReadOnly { 
    self = [super init];
    if (self) {
        shouldViewBeReadOnly = isReadOnly;
    }
    return self;
    
}

//  Upon disappearing, pass currently displayed text to the reader singleton 
//  to allow text sharing between views on the tab bar.
- (void)viewWillDisappear:(BOOL)animated {
    
    // XXX: You do not need to pull out the instance. i.e. [ReaderSingleton sharedAppInstance].currentText = self.textViewer.text
    ReaderSingleton *sharedAppInstance;
    sharedAppInstance = [ReaderSingleton sharedAppInstance];
    sharedAppInstance.currentText = self.textViewer.text;
}


//  Upon appearing, receive currently displayed text from the reader singleton
- (void) viewWillAppear:(BOOL)animated {
    
    // XXX: See above
    ReaderSingleton *sharedAppInstance;
    sharedAppInstance = [ReaderSingleton sharedAppInstance];
    self.textViewer.text = sharedAppInstance.currentText;
    
}


//  Called when view is loaded from code (not .nib file)
//  Add the lookup option to the current sharedMenuController.  Also set up
//  the primary text view as either read-only or edit.
- (void) loadView {

    [super loadView];
    
    //  Add Lookup option to system-wide menu controller.
    UIMenuItem *testMenuItem = [[UIMenuItem alloc] initWithTitle:@"Lookup" action:@selector(lookup:)];
    [UIMenuController sharedMenuController].menuItems = [NSArray arrayWithObject:testMenuItem];
    [testMenuItem release];
    
    // XXX: Memory leak. Either autorelease the ReaderTextView, or set to a variable that you can release, or take the self. off textViewer
    // XXX: Also, you should be overloading viewDidUnload and release this there as well
    
    //  Assign delegates for both UITextViewDelegate and ReaderTextViewDelegate
    self.textViewer = [[ReaderTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) ReadOnlyState:shouldViewBeReadOnly];
    self.textViewer.delegate = self;
    self.textViewer.readerDelegate = self;
    self.view = self.textViewer;    

}

- (void)dealloc {
    [textViewer release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//  App only supportes vertical orientation due to the use of a tab bar.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return (interfaceOrientation == UIInterfaceOrientationPortrait);  /* ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);*/
}

//  If word is looked up, push a new view controller onto the nav controller to display definitions and sample sentences.
- (void)onLookupSelected:(NSString *) textSelection {

    // XXX: Should release the controller right away since there is no need to autorelease
    DefinitionsViewController * next = [[[DefinitionsViewController alloc] initWithTerm:textSelection] autorelease];
    [self.navigationController pushViewController:next animated:YES];
}


//  If keyboard editing begins, display Done button in upper-right corner to allow user to hide keyboard.
- (void)textViewDidBeginEditing:(UITextView *)textView  {       
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
}

// XXX: This method is only called privately so it should be declared private
//  Event handler for done button press
- (void) doneButtonPressed {

    [[self navigationItem] setRightBarButtonItem:nil];
    [self.textViewer resignFirstResponder];
}




@end

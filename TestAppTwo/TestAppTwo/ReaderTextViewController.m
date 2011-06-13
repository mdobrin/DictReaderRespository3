//
//  ReaderTextViewController.m
//  DictReader
//
//  Created by Mike on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReaderTextViewController.h"
#import "TextManager.h"


@interface ReaderTextViewController (hidden)

- (void) doneButtonWasPressed;;

@end


@implementation ReaderTextViewController (hidden)

//  Event handler for done button press
- (void) doneButtonWasPressed {
    
    [[self navigationItem] setRightBarButtonItem:nil];
    [self.textViewer resignFirstResponder];
}

@end


@implementation ReaderTextViewController
@synthesize textViewer;


//  Initialize view controller.  By default, read only is set to NO
- (id) init { 

    return [self initWithReadOnlyOn:NO];    
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

    [TextManager sharedInstance].currentText = self.textViewer.text;
}


//  Upon appearing, receive currently displayed text from the reader singleton
- (void) viewWillAppear:(BOOL)animated {
    
    self.textViewer.text = [TextManager sharedInstance].currentText;
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
    
    // XXX: Also, you should be overloading viewDidUnload and release this there as well
    // YYY: Isn't viewDidUnload the counterpart for viewDidLoad?  loadView is the first time this memory is allocated
    // YYY: so wouldn't dealloc be the time when these are released?
    
    //  Assign delegates for both UITextViewDelegate and ReaderTextViewDelegate
    ReaderTextView * temp = [[[ReaderTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) readOnlyState:shouldViewBeReadOnly] autorelease];
    self.textViewer = temp;
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

    DefinitionsViewController * next = [[DefinitionsViewController alloc] initWithTerm:textSelection];
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}


//  If keyboard editing begins, display Done button in upper-right corner to allow user to hide keyboard.
- (void)textViewDidBeginEditing:(UITextView *)textView  {       
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonWasPressed)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
}





@end

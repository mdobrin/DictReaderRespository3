//
//  ReaderTextViewController.h
//  DictReader
//
//  Created by Mike on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReaderTextView.h"
#import "ReaderTextViewDelegate.h"
#import "DefinitionsViewController.h"

//  Used for interacting with user-input text in both read and edit modes.
@interface ReaderTextViewController : UIViewController<ReaderTextViewDelegate, UITextViewDelegate, UITabBarDelegate> { 
    // XXX: IBOutlet should be declared on property
    IBOutlet ReaderTextView * textViewer;
    // XXX: Does should imply that is might not be?
    BOOL shouldViewBeReadOnly;
}

@property (nonatomic, retain) ReaderTextView * textViewer; 

// XXX: objective c does no use is in variable names
// XXX: initWtihReadOnlyOn seems weird to me. perhaps initWithReadOnlyFlag
- (id) initWithReadOnlyOn:(BOOL)isReadOnly;
- (void) onLookupSelected:(NSString *) textSelection;
- (void) textViewDidBeginEditing:(UITextView *)textView;
// XXX: Personally, I would use doneButtonWasPressed
- (void) doneButtonPressed;


@end
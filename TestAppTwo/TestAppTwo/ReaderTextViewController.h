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

    IBOutlet ReaderTextView * textViewer;
    BOOL shouldViewBeReadOnly;
}

@property (nonatomic, retain) ReaderTextView * textViewer; 

- (id) initWithReadOnlyOn:(BOOL)isReadOnly;
- (void) onLookupSelected:(NSString *) textSelection;
- (void) textViewDidBeginEditing:(UITextView *)textView;
- (void) doneButtonPressed;


@end
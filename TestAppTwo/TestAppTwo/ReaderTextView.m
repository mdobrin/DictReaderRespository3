//
//  ReaderTextView.m
//  DictReader
//
//  Created by Mike on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReaderTextView.h"

@implementation ReaderTextView
@synthesize readerDelegate;
@synthesize isReadOnlyModeOn;

- (id)init {
    // XXX: No need to call super since you call an overrided constuctor that calls super
    self = [super init];
    if (self) {
        [self init:NO];
    }
    return self;
}

//  Initializer with read-only flag
- (id)init:(BOOL)isReadOnly {
    // XXX: No need to call super since you call an overrided constuctor that calls super
    self = [super init];
    if (self) {
        [self initWithFrame:CGRectMake(0, 0, 320, 480) ReadOnlyState:isReadOnly];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame ReadOnlyState:(BOOL)isReadOnly {
    
    self = [super initWithFrame:frame];
    if (self) {
        //  Disable auto-correction and auto-capitalization
        self.frame = frame;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;  
        self.isReadOnlyModeOn = isReadOnly;
        self.font = [UIFont fontWithName:@"Georgia" size:16.0];
    }
    return self;
}

// XXX: You should probably group these calls with pragma marks i.e.
//----------------------------------------------------------------------------
#pragma mark -
#pragma mark UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

//  Overwrite to simulate standard UITextView while in read mode.
//  This is necessary because editing is disabled and blocks the user
//  from hiding the UIMenuController when he touches down outside the menu.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.isReadOnlyModeOn) {
        UIMenuController * menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible: NO animated: YES];
    }
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}



//  Override of setter to allow for background color change and the UITextView editable property
//  to be changed.
- (void) setIsReadOnlyModeOn:(BOOL)value {
    
    if (value) {
        //  Set to light green if read mode is on
        self.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:244.0f/255.0f blue:233.0f/255.0f alpha:1.0f];

    } else {
        //  Set to off-white if read mode is off
        self.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:236.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
    }
    
    self.editable = !value;
    isReadOnlyModeOn = value;
}


//  Override to determine what editing options the user has in both edit and read modes
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {    
    NSString * selectedText = [self.text substringWithRange:[self selectedRange]];

    if ((!isReadOnlyModeOn) && (action == @selector(copy:) || action == @selector(paste:) || 
                                action == @selector(select:) || action == @selector(selectAll:))) {
        return [super canPerformAction:action withSender:sender];
    } 
    else if ((isReadOnlyModeOn) && (action == @selector(lookup:) && [selectedText length] > 0) ||
             (action == @selector(select:) && [selectedText length] == 0)) {
        return YES;
        
    } else {
        return NO;
    }
}

// XXX: You should probably group these calls with pragma marks like below and also declare this as a private method
//----------------------------------------------------------------------------
#pragma mark -
#pragma mark Unknown? methods

//  If lookup is called, get the currently selected text and pass responsibility on
//  to the delegate to handle.
- (void)lookup:(id)sender {
    
    if ( [self.readerDelegate respondsToSelector:@selector(onLookupSelected:)]) {
        NSString * selectedText = [self.text substringWithRange:[self selectedRange]];   
        [self.readerDelegate onLookupSelected:selectedText];
    }
}




@end

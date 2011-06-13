//
//  ReaderTextView.h
//  DictReader
//
//  Created by Mike on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderTextViewDelegate.h"

//  The view for reading/editing text
@interface ReaderTextView : UITextView {
    
    id <ReaderTextViewDelegate> readerDelegate;
    // XXX: variable names with is is not standard objective c naming
    BOOL isReadOnlyModeOn;
}

@property (nonatomic, assign) BOOL isReadOnlyModeOn;
@property (nonatomic, assign) id <ReaderTextViewDelegate> readerDelegate;

- (id)init:(BOOL)isReadOnly;
// XXX: named parameters should not start with a capital letter
- (id)initWithFrame:(CGRect)frame readOnlyState:(BOOL)isReadOnly;

@end

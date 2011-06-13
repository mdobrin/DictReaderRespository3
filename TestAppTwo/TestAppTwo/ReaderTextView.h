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
    BOOL isReadOnlyModeOn;
}

@property (nonatomic, assign) BOOL isReadOnlyModeOn;
@property (nonatomic, assign) id <ReaderTextViewDelegate> readerDelegate;

- (id)init:(BOOL)isReadOnly;
- (id)initWithFrame:(CGRect)frame ReadOnlyState:(BOOL)isReadOnly;

@end

//
//  ReaderTextViewDelegate.h
//  DictReader
//
//  Created by Mike on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//  Delegate which requires implementation of onLookupSelected to handle text lookup.
@protocol ReaderTextViewDelegate <NSObject>

@required

- (void)onLookupSelected:(NSString *) textSelection;

@end

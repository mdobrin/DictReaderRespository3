//
//  DefinitionTextViewController.h
//  DictReader
//
//  Created by Mike on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderTextViewDelegate.h"
#import "DefinitionsViewModel.h"


//  View controller for handling display of word definitions
@interface DefinitionsViewController : UITableViewController <ReaderTextViewDelegate>  {
    
    DefinitionsViewModel * data;

}

@property (nonatomic, retain) DefinitionsViewModel * data;


- (id)initWithTerm:(NSString*)term;
- (void)onLookupSelected:(NSString *) textSelection;


@end

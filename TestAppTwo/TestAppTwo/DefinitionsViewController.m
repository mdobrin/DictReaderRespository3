//
//  DefinitionTextViewController.m
//  DictReader
//
//  Created by Mike on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DefinitionsViewController.h"
#import "ReaderTextView.h"


@implementation DefinitionsViewController

@synthesize data;


- (id)init {
    self = [super init];
    if (self) {
        [self initWithTerm:nil];
    }
    return self;
}

//  custom intializer to allow initialization with a search term.
- (id)initWithTerm:(NSString*)term {
    self = [super init];
    if (self) {
        data = [[DefinitionsViewModel alloc] initWithTerm:term];
    }
    return self;
}

//  called when view is loaded from code (not .nib)
- (void) loadView {
    
    self.title = [self.data.theTerm uppercaseString];
    [super loadView];
}


- (void)dealloc {
    [data release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait); /* ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);*/
}

//  Return number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //  Each section will display rows containing one definition and all of the associated sample sentences.
    //  We calculate the number of rows by counting the number of sentence entries in the sub array of
    //  the NSDictionary member, definitionsAndSampleSentences.  The keys are each definition, and the 
    //  objects are each group of sample sentences which coorespond to a definition.
    //
    //  Note:  sample sentences not yet supported.
    
    if (self.data.definitionsAndSampleSentences && section < [self.data.definitionsAndSampleSentences count]) {
        
        return [self.data.definitionsAndSampleSentences count];
        
    } else {
        return 1;
    }
}

//  Display header in table to show gutenberg rank
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)] autorelease];
    CGRect labelFrame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelFrame];
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.text = [NSString stringWithFormat:@"Gutenberg Rank: %d", self.data.gutenbergRating];
    headerLabel.alpha = 0.6f;
    [headerView addSubview:headerLabel];
    
    return headerView;

}

//  Implement later to include for sample sentences divided by definition.
/* - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
} */


//  Determine height of cell based on the text it is displaying
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    NSInteger count = [self.data.definitionsAndSampleSentences count];
    id keys[count];
    id objects[count];
    CGSize textSize = CGSizeMake(320, 0);
    [self.data.definitionsAndSampleSentences getObjects:objects andKeys:keys];
        
   if (self.data.definitionsAndSampleSentences && indexPath.section < [self.data.definitionsAndSampleSentences count]) {
        
       //  Get definition based on the section number.  i.e. section 0 is the first defintion, etc...
        NSString * thisGroupsDefinition = (NSString *)keys[indexPath.row];
        textSize = [thisGroupsDefinition sizeWithFont:[UIFont fontWithName:@"Georgia" size:16.0] constrainedToSize:CGSizeMake(320, 9999) lineBreakMode:UILineBreakModeWordWrap];
    }  
    return textSize.height + 30;
     
}

//  Display each cell's content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    //  Temporary workaround due to unsolved update issue with currentCellTextView's text.
    UITableViewCell * cell = [[[UITableViewCell alloc] init] autorelease];
    
    /*static NSString *kCustomCellID = @"CustomCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID] autorelease];
    }*/
    
    NSInteger count = [self.data.definitionsAndSampleSentences count];
    id keys[count];
    [self.data.definitionsAndSampleSentences getObjects:nil andKeys:keys];

    
    ReaderTextView *currentCellTextView = [[ReaderTextView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    currentCellTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    currentCellTextView.font = [UIFont fontWithName:@"Georgia" size:16.0];
    currentCellTextView.isReadOnlyModeOn = YES;
    currentCellTextView.readerDelegate = self;
    currentCellTextView.scrollEnabled = NO;
    
    if (indexPath.row >= count) {
        
        currentCellTextView.text = @"No results found.";
        
    } else {
        
        currentCellTextView.text = (NSString *) keys[indexPath.row];
    }

    [cell.contentView addSubview:currentCellTextView];
    
    [currentCellTextView release];
     
    return cell;

}

//  Allow dictionary use of dictionary terms.
- (void)onLookupSelected:(NSString *) textSelection {
    
    //  If word is looked up, push a new view controller onto the nav controller to display definition.
    DefinitionsViewController * next = [[[DefinitionsViewController alloc] initWithTerm:textSelection] autorelease];
    [self.navigationController pushViewController:next animated:YES];
    
}




@end

    //
//  TCListViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 9/12/10.
//  Copyright 2010 UberGames. All rights reserved.
//

#import "TCRefinableListViewController.h"

@implementation TCRefinableListViewController

@synthesize		isSortable,  
				sortTitles,
				sortRows,
				sortSavedRows;


- (void)viewDidUnload
{
    [super viewDidUnload];    
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
	[sortSavedRows release];
	[sortRows release];
    [sortTitles release];
    
    [super dealloc];
}

#pragma mark Accessor Methods
- (void) setIsSortable:(BOOL)sortable
{
	if( isSortable == sortable )
		return;
	
	isSortable = sortable;
	
	if( isSortable == YES )
	{
		//create a sorting button
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Sort", @"") style: UIBarButtonItemStyleBordered target: self action: @selector(showFilterDialog)];
		self.navigationItem.rightBarButtonItem = button;
		[button release];	
	}
	else
	{
		self.navigationItem.rightBarButtonItem = nil;
	}
}

-(void) setSortIndex: (NSInteger)index forRow: (NSInteger) row
{
    if( sortSavedRows == nil )
        sortSavedRows = [[NSMutableDictionary alloc] init];
    
    [sortSavedRows setObject: [NSNumber numberWithInt: index] forKey: [NSNumber numberWithInt: row]];
}

#pragma mark UIActionSheet Methods
- (void) showFilterDialog
{
	//each view added to the sheet will add its height here
	NSInteger viewHeight = 0;
	
	//create the action sheet
	UIActionSheet *sortSheet = [[UIActionSheet alloc] initWithTitle: nil delegate:self cancelButtonTitle: NSLocalizedString( @"Cancel", nil ) destructiveButtonTitle: nil otherButtonTitles: NSLocalizedString( @"Sort", nil) ,nil];
	sortSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	sortSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	//create the picker object
	UIPickerView *sortPicker = [[UIPickerView alloc] initWithFrame: CGRectZero ];
	sortPicker.delegate = self;
	sortPicker.dataSource = self;
	sortPicker.showsSelectionIndicator = YES;
	sortPicker.frame = CGRectMake( 0, 0, sortPicker.frame.size.width, sortPicker.frame.size.height );
	[sortSheet addSubview: sortPicker];

	//init the selected rows store
	sortRows = [[NSMutableDictionary alloc] init];	
	
	//if the saved order isn't nil, restore it
	if( sortSavedRows != nil )
	{
		for (int i = 0; i < sortPicker.numberOfComponents; i++ )
		{
			NSNumber *selectedRow = (NSNumber *)[sortSavedRows objectForKey: [NSNumber numberWithInt: i]];
			if( selectedRow )
			{
				//update the scroll wheel to match
				[sortPicker selectRow: [selectedRow intValue] inComponent: i animated: NO];
			
				//add the order to the main tracker array
				[sortRows setObject: selectedRow forKey: [NSNumber numberWithInt: i] ];
			}
		}
	}
	
	viewHeight += sortPicker.frame.size.height;
	[sortPicker release];
	
	//create a bar to display the names of each column
	UIView *titleBar = [[UIView alloc] initWithFrame: CGRectMake( 0, viewHeight, sortPicker.frame.size.width, 25 )];
	titleBar.backgroundColor = [UIColor colorWithRed: 39.0f/255.0f green: 43.0f/255.0f blue: 57.0f/255.0f alpha: 1.0f ]; 
	[sortSheet addSubview: titleBar];
	
	//add a label under each component
	if( self.sortTitles )
	{
		NSInteger rowOffset = 0;
		NSInteger pickerPadding = 10; //padding between the actual scroll view of the picker and the edge of the screen
		UILabel *label;
		
		//add a label to each component
		for( int i = 0; i < sortPicker.numberOfComponents; i++ )
		{
			if ( i >= [sortTitles count] )
				break;
			
			CGSize rowSize = [sortPicker rowSizeForComponent: i];
			
			label = [[UILabel alloc] initWithFrame: CGRectMake( pickerPadding + rowOffset, 0, rowSize.width, 23 )];
			label.backgroundColor = [UIColor clearColor];
			label.clipsToBounds = NO;
			label.textColor = [UIColor colorWithHue: 1.0f saturation: 0.0f brightness: 0.85f alpha: 1.0f];
			label.shadowColor =	[UIColor blackColor];
			label.textAlignment = UITextAlignmentCenter;
			label.shadowOffset = CGSizeMake( 0.0f, -1.0f );
			label.font = [UIFont boldSystemFontOfSize: 14.0f];
			label.text = (NSString *)[sortTitles objectAtIndex: i];
			[titleBar addSubview: label];
			[label release];
			label = nil;
			
			rowOffset += rowSize.width;
		}
	}
	
	viewHeight += titleBar.frame.size.height;
	[titleBar release];
	
	//add a dark line under the picker to give the illusion of a bar bevel
	UIView *darklight = [[UIView alloc] initWithFrame: CGRectMake(0, viewHeight-1, 0, 1.0f)];
	darklight.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	darklight.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5f];
	[sortSheet addSubview: darklight];
	[darklight release];
	
	//add a bright line under the picker to give the illusion of a bar highlight
	UIView *highlight = [[UIView alloc] initWithFrame: CGRectMake(0, viewHeight, 0, 1.0f)];
	highlight.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	highlight.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
	[sortSheet addSubview: highlight];
	[highlight release];
	
	//add 55 to account for the buttons at the bottom of the page
	viewHeight += 55;	

	//show the sheet in the target
	UIView *targetView;
	if ( self.parentViewController )
		targetView = self.parentViewController.view;
	else 
		targetView = self.view;

	[sortSheet showInView: targetView];
	
	//override the animation-generated frame to our own calculated one
	CGRect parentFrame = targetView.bounds;
	sortSheet.frame = CGRectMake( 0, parentFrame.size.height-viewHeight, sortSheet.frame.size.width, viewHeight );
	
	//this is a bit hacky. Grab the two buttons generated by the action sheet and manually resize/position them so they appear
	//next to each other, and underneath the picker
	NSInteger buttonPadding = 5;
	NSInteger buttonWidth = (sortSheet.frame.size.width / 2) - buttonPadding * 2;
	NSInteger i = 0;
	
	//account for the gap at the bottom
	viewHeight -= 55;

	//trying to determine the button by [subview title] could technically count as a private API
	//since it reeeally doesn't matter which order the buttons appear in, just loop through
	//each one set their frames on a first come, first serve basis
	for ( UIView *subview in sortSheet.subviews )
	{		
        NSRange range = [NSStringFromClass([subview class]) rangeOfString: @"Button"];
        
		if( range.location != NSNotFound )
		{
			if ( i == 0 )
				subview.frame = CGRectMake( buttonPadding, viewHeight + buttonPadding, buttonWidth, 44 );
			else if (i == 1 )
				subview.frame = CGRectMake( (buttonPadding*3) + buttonWidth, viewHeight + buttonPadding, buttonWidth, 44 );
			else 
				break;
			
			i++;
		}
	}	
	
	[sortSheet release];
}

- (void) performFilter
{
	//the super message should be placed at the end of the method in the child
	
	//reload the table
	[self reloadTableContent];
}

#pragma mark UIPickerViewDelegate methods
- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
	//abstract method
	return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//abstract
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	//save the selected entry
	[sortRows setObject: [NSNumber numberWithInt: row] forKey: [NSNumber numberWithInt: component]];
}

#pragma mark UIActionSheet Delegates
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//hit the filter button
	if( buttonIndex == 0 )
	{
		//perform the filter
		[self performFilter];
		
		//save the new order of the rows
        self.sortSavedRows = nil;
		sortSavedRows = [sortRows copy];
		
		//dealloc the rows object for next time
		self.sortRows = nil;
	}
}

@end

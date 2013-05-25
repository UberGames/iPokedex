//
//  PokemonBaseStatsView.m
//  iPokedex
//
//  Created by Timothy Oliver on 25/01/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "PokemonBaseStatsView.h"
#import "TCQuartzFunctions.h"
#import "UIColor+CustomColors.h"

#define CELL_HP		0
#define CELL_ATK	1
#define CELL_DEF	2
#define CELL_SPATK	3
#define CELL_SPDEF	4
#define CELL_SPEED	5
#define CELL_TOTAL  6

#define STAT_NUM_CELLS	7

#define BASE_STAT_BAR_HEIGHT 21
#define BASE_STAT_PADDING 2
#define BASE_STAT_LVL_CELL_WIDTH 50

@interface PokemonBaseStatsView()

-(NSInteger) statValueForIndex: (NSInteger) index;
-(UIColor *)boxColorForCellIndex: (NSInteger) index;
-(UIColor *)boxStrokeColorForCellIndex: (NSInteger) index;
-(NSInteger)widthOfStatBarWithStat: (NSInteger)stat;
-(NSInteger)widthOfTotalStatBarWithStat:(NSInteger)stat;
-(NSInteger) hpStatMinimumWithStat: (NSInteger) stat atLevel: (NSInteger) level;
-(NSInteger) hpStatMaximumWithStat: (NSInteger) stat atLevel: (NSInteger) level;
-(NSInteger) statMinimumWithStat: (NSInteger) stat atLevel: (NSInteger) level;
-(NSInteger) statMaximumWithStat: (NSInteger) stat atLevel: (NSInteger) level;

@end

@implementation PokemonBaseStatsView

@synthesize stats, statLvl50Stats, statLvl100Stats;
@synthesize hp, atk, def, spAtk, spDef, speed, total;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.contentMode = UIViewContentModeRedraw;
		
		NSMutableArray *_stats = [[NSMutableArray alloc] init];
		NSMutableArray *_statLvl50Stats = [[NSMutableArray alloc] init];
		NSMutableArray *_statLvl100Stats = [[NSMutableArray alloc] init];
		
		for( int i = 0; i < STAT_NUM_CELLS; i++ )
		{
			[_stats insertObject: [[[NSMutableString alloc] initWithString: @"0"] autorelease] atIndex: i];
			[_statLvl50Stats insertObject: [[[NSMutableString alloc] initWithString: @"0-0"] autorelease] atIndex: i];
			[_statLvl100Stats insertObject: [[[NSMutableString alloc] initWithString: @"0-0"] autorelease] atIndex: i];
		}
		
		self.stats = _stats;
		self.statLvl50Stats = _statLvl50Stats;
		self.statLvl100Stats = _statLvl100Stats;
		
		[_stats release];
		[_statLvl50Stats release];
		[_statLvl100Stats release];
		
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
	UIFont *font;
	CGSize size;
	CGRect boxFrame;
	NSInteger y = 0;
	NSInteger cellWidth = self.bounds.size.width;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//init and add the titles for each stat
	NSArray *titleText = [NSArray arrayWithObjects: NSLocalizedString( @"HP", nil ), 
                                                    NSLocalizedString( @"Atk", nil ), 
                                                    NSLocalizedString( @"Def", nil ), 
                                                    NSLocalizedString( @"Sp. Atk", nil ), 
                                                    NSLocalizedString( @"Sp. Def", nil ), 
                                                    NSLocalizedString( @"Speed", nil ), 
                                                    NSLocalizedString( @"Total", nil ), 
                                                    nil];	
	
	//Base Stats text
	NSString *baseStatsText = NSLocalizedString( @"Base Stats", nil);
	[[UIColor tableCellCaptionColor] set];
	[baseStatsText drawInRect:	CGRectMake( 50, y, 145, 20)	withFont: [UIFont boldSystemFontOfSize: 13.0f]	lineBreakMode:	UILineBreakModeClip	alignment: UITextAlignmentLeft ];
	
	//Level 50 Text
	NSString *level50Text = NSLocalizedString( @"Lvl. 50", nil);
	font = [UIFont boldSystemFontOfSize: 13.0f];
	size = [level50Text sizeWithFont: font];
	CGRect level50Frame = CGRectMake( floor((cellWidth - (BASE_STAT_LVL_CELL_WIDTH*2+BASE_STAT_PADDING)) + ((BASE_STAT_LVL_CELL_WIDTH - size.width)/2)), y, size.width, size.height);
	[[UIColor tableCellCaptionColor] set];
	[level50Text drawInRect: level50Frame withFont: font lineBreakMode:	UILineBreakModeClip	alignment: UITextAlignmentCenter ];	
	
	//Level 100 Text
	NSString *level100Text = NSLocalizedString( @"Lvl. 100", nil );
	font = [UIFont boldSystemFontOfSize: 13.0f];
	size = [level100Text sizeWithFont: font];
	CGRect level100Frame = CGRectMake( floor((cellWidth - (BASE_STAT_LVL_CELL_WIDTH)) + ((BASE_STAT_LVL_CELL_WIDTH - size.width)/2)), y, size.width, size.height);
	[[UIColor tableCellCaptionColor] set];
	[level100Text drawInRect: level100Frame withFont: font	lineBreakMode:	UILineBreakModeClip	alignment: UITextAlignmentCenter ];	
	
	//move to the next line
	y += size.height + BASE_STAT_PADDING;
	
	//loop through and render each stat
	for( NSInteger i = 0; i < STAT_NUM_CELLS; i++ )
	{
		NSInteger stat = [self statValueForIndex: i];
		UIColor *boxColor = [self boxColorForCellIndex: i];
		UIColor *boxStrokeColor = [self boxStrokeColorForCellIndex: i];	
		
         //draw a line to separate
        if( i == CELL_TOTAL )
        {
            y+= BASE_STAT_PADDING;
            
            CGRect lineRect = CGRectMake( 0, y, self.bounds.size.width, 1.0f );
            CGContextSetFillColorWithColor( context, [[UIColor colorWithRed: 0.8f green: 0.8f blue: 0.8f alpha: 1.0f] CGColor] );
            CGContextFillRect( context, lineRect );
            
            y+= BASE_STAT_PADDING+4;
        }
        
		//Draw Stat Name
		NSString *statTitle = [titleText objectAtIndex: i];
		[[UIColor tableCellCaptionColor] set];
		[statTitle drawInRect: CGRectMake( 0, y+3, 43, 20 ) withFont: [UIFont boldSystemFontOfSize: 12.0f] lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentRight];
		
		//draw the box
		
        if( i < CELL_TOTAL )
            boxFrame = CGRectMake( 50, y, [self widthOfStatBarWithStat: stat], BASE_STAT_BAR_HEIGHT);
		else
            boxFrame = CGRectMake( 50, y, [self widthOfTotalStatBarWithStat: stat], BASE_STAT_BAR_HEIGHT);
            
        TCDrawRoundedRectWithStroke( context, boxFrame, 3.0f, 1, boxColor, boxStrokeColor);
		
		//draw the base stat text in the box
		NSString *baseStatValue = [stats objectAtIndex: i];
		font = [UIFont boldSystemFontOfSize: 15.0f];
		boxFrame = CGRectMake(boxFrame.origin.x+5, y, 40, BASE_STAT_BAR_HEIGHT-1);
		[[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
		[baseStatValue drawInRect: CGRectOffset(boxFrame, 0, 1) withFont: font];
		[[UIColor blackColor] set];
		[baseStatValue drawInRect: boxFrame withFont: font];

        if( i < CELL_TOTAL )
        {
            //add the lvl 50 stat box
            boxFrame = CGRectMake( (cellWidth - (BASE_STAT_LVL_CELL_WIDTH*2+BASE_STAT_PADDING)), y, BASE_STAT_LVL_CELL_WIDTH, BASE_STAT_BAR_HEIGHT);
            TCDrawRoundedRectWithStroke( context, boxFrame, 3.0f, 1, boxColor, boxStrokeColor);	

            NSString *lvl50Stats = [statLvl50Stats objectAtIndex: i];
            font = [UIFont boldSystemFontOfSize: 12.0f];
            boxFrame = CGRectMake( boxFrame.origin.x, boxFrame.origin.y+2, BASE_STAT_LVL_CELL_WIDTH, BASE_STAT_BAR_HEIGHT-2);
            [[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
            [lvl50Stats drawInRect: CGRectOffset(boxFrame, 0, 1) withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];		
            [[UIColor blackColor] set];
            [lvl50Stats drawInRect: boxFrame withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];		
            
            //add the lvl 100 stat boxes
            boxFrame = CGRectMake( (cellWidth - (BASE_STAT_LVL_CELL_WIDTH)), y, BASE_STAT_LVL_CELL_WIDTH, BASE_STAT_BAR_HEIGHT);
            TCDrawRoundedRectWithStroke( context, boxFrame, 3.0f, 1, boxColor, boxStrokeColor);		
            
            NSString *lvl100Stats = [statLvl100Stats objectAtIndex: i];
            font = [UIFont boldSystemFontOfSize: 12.0f];
            boxFrame = CGRectMake( boxFrame.origin.x, boxFrame.origin.y+2
                                  , BASE_STAT_LVL_CELL_WIDTH, BASE_STAT_BAR_HEIGHT-2);
            [[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
            [lvl100Stats drawInRect: CGRectOffset(boxFrame, 0, 1) withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];	
            [[UIColor blackColor] set];
            [lvl100Stats drawInRect: boxFrame withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];            
        }
        
		y += BASE_STAT_BAR_HEIGHT + BASE_STAT_PADDING;
	}
}

-(NSInteger) statValueForIndex: (NSInteger) index
{
	switch (index) {
		case CELL_HP:
			return hp;
		case CELL_ATK:
			return atk;
		case CELL_DEF:
			return def;
		case CELL_SPATK:
			return spAtk;
		case CELL_SPDEF:
			return spDef;
		case CELL_SPEED:
			return speed;
        case CELL_TOTAL:
            return total;
		default: 
			break;	
	}
	
	return 0;
}

-(UIColor *)boxColorForCellIndex: (NSInteger) index
{
	switch (index) {
		case CELL_HP:
			return [UIColor colorWithRed: 255.0f/255.0f green: 89.0f/255.0f blue: 89.0f/255.0f alpha: 1.0f];
		case CELL_ATK:
			return [UIColor colorWithRed: 255.0f/255.0f green: 167.0f/255.0f blue: 89/255.0f alpha: 1.0f];
		case CELL_DEF:
			return [UIColor colorWithRed: 255.0f/255.0f green: 226.0f/255.0f blue: 89/255.0f alpha: 1.0f];
		case CELL_SPATK:
			return [UIColor colorWithRed: 89.0f/255.0f green: 191.0f/255.0f blue: 255.0f/255.0f alpha: 1.0f];
		case CELL_SPDEF:
			return [UIColor colorWithRed: 140.0f/255.0f green: 221.0f/255.0f blue: 119.0f/255.0f alpha: 1.0f];
		case CELL_SPEED:
			return [UIColor colorWithRed: 255.0f/255.0f green: 138.0f/255.0f blue: 196/255.0f alpha: 1.0f];
		case CELL_TOTAL:
            return [UIColor colorWithRed: 0.9f green: 0.9f blue: 0.9f alpha: 1.0f];
        default: 
			break;
	}
	
	return [UIColor blackColor];
}

-(UIColor *)boxStrokeColorForCellIndex: (NSInteger) index
{
	switch (index) {
		case CELL_HP:
			return [UIColor colorWithRed: 159.0f/255.0f green: 0.0f blue: 0.0f alpha: 1.0f];
		case CELL_ATK:
			return [UIColor colorWithRed: 159.0f/255.0f green: 97.0f/255.0f blue: 0.0f alpha: 1.0f];
		case CELL_DEF:
			return [UIColor colorWithRed: 159.0f/255.0f green: 142.0f/255.0f blue: 0.0f alpha: 1.0f];
		case CELL_SPATK:
			return [UIColor colorWithRed: 0.0f/255.0f green: 97.0f/255.0f blue: 159.0f/255.0f alpha: 1.0f];
		case CELL_SPDEF:
			return [UIColor colorWithRed: 19.0f/255.0f green: 159.0f/255.0f blue: 0.0f alpha: 1.0f];
		case CELL_SPEED:
			return [UIColor colorWithRed: 188.0f/255.0f green: 39.0f/255.0f blue: 193.0f/255.0f alpha: 1.0f];
		case CELL_TOTAL:
            return [UIColor colorWithRed: 0.7f green: 0.7f blue: 0.7f alpha: 1.0f];
        default: 
			break;
	}
	
	return [UIColor blackColor];
}

-(NSInteger)widthOfStatBarWithStat: (NSInteger)stat
{	
	NSInteger xEndPoint = self.bounds.size.width - ((BASE_STAT_LVL_CELL_WIDTH+BASE_STAT_PADDING)*2);
	NSInteger maxBarWidth = xEndPoint - 50;
	
	return (NSInteger)floor(((CGFloat)stat/255.0f)*maxBarWidth);
}

-(NSInteger)widthOfTotalStatBarWithStat:(NSInteger)stat
{
    NSInteger maxBarWidth = self.bounds.size.width - 50;
    return (NSInteger)floor(((CGFloat)stat/720.0f)*maxBarWidth);
}

-(NSInteger) hpStatMinimumWithStat: (NSInteger) stat atLevel: (NSInteger) level
{
	return ((2 * stat) * level/100) + 10 + level;
}


-(NSInteger) hpStatMaximumWithStat: (NSInteger) stat atLevel: (NSInteger) level
{
	return ((31 + 2 * stat + (252/4)) * level/100) + 10 + level;
}

-(NSInteger) statMinimumWithStat: (NSInteger) stat atLevel: (NSInteger) level
{
	return floor((((0 + 2 * (CGFloat)stat) * (CGFloat)level/100.0f) + 5) * 0.9f);
}

				 
-(NSInteger) statMaximumWithStat: (NSInteger) stat atLevel: (NSInteger) level
{
	return floor((((31 + 2 * (CGFloat)stat + (252.0f/4.0f)) * (CGFloat)level/100.0f) + 5) * 1.1f);
}				 

-(void) setHp:(NSInteger)_hp
{
	if( hp == _hp )
		return;
	
	hp = _hp;
	
	NSInteger min50 = [self hpStatMinimumWithStat: hp atLevel: 50];
	NSInteger max50 = [self hpStatMaximumWithStat: hp atLevel: 50];
	NSInteger min100 = [self hpStatMinimumWithStat: hp atLevel: 100];
	NSInteger max100 = [self hpStatMaximumWithStat: hp atLevel: 100];
	
	NSMutableString *stat		= [self.stats objectAtIndex: CELL_HP];
	NSMutableString *stat50	= [self.statLvl50Stats objectAtIndex: CELL_HP];
	NSMutableString *stat100	= [self.statLvl100Stats objectAtIndex: CELL_HP];
	 
	[stat setString: [NSString stringWithFormat: @"%d", hp] ];
	[stat50 setString: [NSString stringWithFormat: @"%d-%d", min50, max50] ];
	[stat100 setString:  [NSString stringWithFormat: @"%d-%d", min100, max100] ];
}

-(void) setAtk:(NSInteger)_atk
{
	if( atk == _atk )
		return;
	
	atk = _atk;
	
	NSInteger min50 = [self statMinimumWithStat: atk atLevel: 50];
	NSInteger max50 = [self statMaximumWithStat: atk atLevel: 50];
	NSInteger min100 = [self statMinimumWithStat: atk atLevel: 100];
	NSInteger max100 = [self statMaximumWithStat: atk atLevel: 100];
	
	NSMutableString *stat = [self.stats objectAtIndex: CELL_ATK];
	NSMutableString *stat50 = [self.statLvl50Stats objectAtIndex: CELL_ATK];
	NSMutableString *stat100 = [self.statLvl100Stats objectAtIndex: CELL_ATK];
	
	[stat setString:  [NSString stringWithFormat: @"%d", atk] ];
	[stat50 setString:  [NSString stringWithFormat: @"%d-%d", min50, max50] ];
	[stat100 setString:  [NSString stringWithFormat: @"%d-%d", min100, max100] ];
}

-(void) setDef:(NSInteger)_def
{
	if( def == _def )
		return;
	
	def = _def;
	
	NSInteger min50 = [self statMinimumWithStat: def atLevel: 50];
	NSInteger max50 = [self statMaximumWithStat: def atLevel: 50];
	NSInteger min100 = [self statMinimumWithStat: def atLevel: 100];
	NSInteger max100 = [self statMaximumWithStat: def atLevel: 100];
	
	NSMutableString *stat = [self.stats objectAtIndex: CELL_DEF];
	NSMutableString *stat50 = [self.statLvl50Stats objectAtIndex: CELL_DEF];
	NSMutableString *stat100 = [self.statLvl100Stats objectAtIndex: CELL_DEF];
	
	[stat setString:  [NSString stringWithFormat: @"%d", def] ];
	[stat50 setString: [NSString stringWithFormat: @"%d-%d", min50, max50] ];
	[stat100 setString: [NSString stringWithFormat: @"%d-%d", min100, max100] ];
}

-(void) setSpAtk:(NSInteger)_spAtk
{
	if( spAtk == _spAtk )
		return;
	
	spAtk = _spAtk;
	
	NSInteger min50 = [self statMinimumWithStat: spAtk atLevel: 50];
	NSInteger max50 = [self statMaximumWithStat: spAtk atLevel: 50];
	NSInteger min100 = [self statMinimumWithStat: spAtk atLevel: 100];
	NSInteger max100 = [self statMaximumWithStat: spAtk atLevel: 100];
	
	NSMutableString *stat = [self.stats objectAtIndex: CELL_SPATK];
	NSMutableString *stat50 = [self.statLvl50Stats objectAtIndex: CELL_SPATK];
	NSMutableString *stat100 = [self.statLvl100Stats objectAtIndex: CELL_SPATK];
	
	[stat setString: [NSString stringWithFormat: @"%d", spAtk] ];
	[stat50 setString: [NSString stringWithFormat: @"%d-%d", min50, max50] ];
	[stat100 setString: [NSString stringWithFormat: @"%d-%d", min100, max100] ];
}

-(void) setSpDef:(NSInteger)_spDef
{
	if( spDef == _spDef )
		return;
	
	spDef = _spDef;
	
	NSInteger min50 = [self statMinimumWithStat: spDef atLevel: 50];
	NSInteger max50 = [self statMaximumWithStat: spDef atLevel: 50];
	NSInteger min100 = [self statMinimumWithStat: spDef atLevel: 100];
	NSInteger max100 = [self statMaximumWithStat: spDef atLevel: 100];
	
	NSMutableString *stat = [self.stats objectAtIndex: CELL_SPDEF];
	NSMutableString *stat50 = [self.statLvl50Stats objectAtIndex: CELL_SPDEF];
	NSMutableString *stat100 = [self.statLvl100Stats objectAtIndex: CELL_SPDEF];
	
	[stat setString: [NSString stringWithFormat: @"%d", spDef] ];
	[stat50 setString: [NSString stringWithFormat: @"%d-%d", min50, max50] ];
	[stat100 setString: [NSString stringWithFormat: @"%d-%d", min100, max100] ];
}

-(void) setSpeed:(NSInteger)_speed
{
	if( speed == _speed )
		return;
	
	speed = _speed;
	
	NSInteger min50 = [self statMinimumWithStat: speed atLevel: 50];
	NSInteger max50 = [self statMaximumWithStat: speed atLevel: 50];
	NSInteger min100 = [self statMinimumWithStat: speed atLevel: 100];
	NSInteger max100 = [self statMaximumWithStat: speed atLevel: 100];
	
	NSMutableString *stat = [self.stats objectAtIndex: CELL_SPEED];
	NSMutableString *stat50 = [self.statLvl50Stats objectAtIndex: CELL_SPEED];
	NSMutableString *stat100 = [self.statLvl100Stats objectAtIndex: CELL_SPEED];
	
	[stat setString: [NSString stringWithFormat: @"%d", speed] ];
	[stat50 setString: [NSString stringWithFormat: @"%d-%d", min50, max50] ];
	[stat100 setString: [NSString stringWithFormat: @"%d-%d", min100, max100] ];
}

-(void) setTotal:(NSInteger)_total
{
    if( total == _total )
        return;

    total = _total;
    
    NSMutableString *stat = [self.stats objectAtIndex: CELL_TOTAL];
    [stat setString: [NSString stringWithFormat: @"%d", total]];
}

- (void)dealloc {

	[statLvl50Stats release];
	[statLvl100Stats release];	
	
    [super dealloc];
}


@end

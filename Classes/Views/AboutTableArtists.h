//
//  AboutTableArtists.h
//  iPokedex
//
//  Created by Timothy Oliver on 26/04/11.
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

#import <UIKit/UIKit.h>
#import "TCFloatedBoxesView.h"

@interface AboutTableArtists : UIView {
    NSArray *names;
    NSArray *artPieces;

    BOOL highlighted;
}

@property (nonatomic, retain) NSArray *names;
@property (nonatomic, retain) NSArray *artPieces;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, readonly) NSInteger frameHeight;

@end

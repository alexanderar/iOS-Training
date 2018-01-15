//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCardView.h"
NS_ASSUME_NONNULL_BEGIN

@class LTPlayingCard;

@interface LTPlayingCardView : LTCardView

@property (readonly, nonatomic) LTPlayingCard *playingCard;

@end

NS_ASSUME_NONNULL_END

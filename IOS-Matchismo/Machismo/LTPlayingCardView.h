//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCardView.h"
#import "LTCardObserverProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@class LTPlayingCard;

/// View that displays playing cards
@interface LTPlayingCardView : LTCardView <LTCardObserverProtocol>

/// Playing card that serves as a model for this view
@property (readonly, nonatomic) LTPlayingCard *playingCard;

@property (nonatomic) BOOL drawWithAnimation;

@end

NS_ASSUME_NONNULL_END

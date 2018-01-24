// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "UIKit/UIKit.h"
#import "LTCardView.h"
#import "LTCardObserverProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class LTSetCard;

/// View that displays set card
@interface LTSetCardView : LTCardView <LTCardObserverProtocol>

/// Set card that is used as a model for this view
@property (readonly, nonatomic) LTSetCard *gameCard;

@end

NS_ASSUME_NONNULL_END

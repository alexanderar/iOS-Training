// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@class LTCard, LTCardView;

/// Factory for creating card views.
@interface LTCardViewFactory : NSObject

/// Creates /c LTSetCardView or /c LTPlayingCardView based on type of given /c card and sets it's
/// frame to given /c frame
+ (LTCardView *) createViewForCard:(LTCard *)card withFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

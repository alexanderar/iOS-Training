// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCardViewFactory.h"
#import "LTCard.h"
#import "LTPlayingCardView.h"
#import "LTSetCardView.h"
#import "LTPlayingCard.h"
#import "LTSetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTCardViewFactory

+ (LTCardView *)createViewForCard:(LTCard *)card  withFrame:(CGRect)frame{
  
  LTCardView *cardView = nil;
  if([card isKindOfClass:LTPlayingCard.class])
  {
    cardView = [[LTPlayingCardView alloc] initWithFrame:frame];
  }
  if([card isKindOfClass:LTSetCard.class])
  {
    cardView = [[LTSetCardView alloc] initWithFrame:frame];
  }
  cardView.card = card;
  return cardView;
  
}

@end

NS_ASSUME_NONNULL_END

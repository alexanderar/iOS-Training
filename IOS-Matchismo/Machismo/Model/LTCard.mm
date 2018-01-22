// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTCard

static NSSet* _keyPathsForValuesAffectingCard = nil;

+ (NSSet *)keyPathsForValuesAffectingCard {
  if(!_keyPathsForValuesAffectingCard)
  {
     _keyPathsForValuesAffectingCard = [NSSet setWithObjects:@"chosen", @"matched", nil];
  }
  return _keyPathsForValuesAffectingCard;
}

@end

NS_ASSUME_NONNULL_END

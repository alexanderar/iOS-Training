// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTGameIterationResult.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTGameIterationResult

- (instancetype)initWithCards:(NSArray *)cards withScore:(NSInteger)score {
  if(self = [super init]) {
    _cards = cards;
    _score = score;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END

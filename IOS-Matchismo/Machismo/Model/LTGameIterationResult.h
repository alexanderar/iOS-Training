// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard;
@interface LTGameIterationResult : NSObject

-(instancetype)init NS_UNAVAILABLE;

- (instancetype) initWithCards:(NSArray *)cards withScore:(NSInteger) score
  NS_DESIGNATED_INITIALIZER;

@property(readonly, nonatomic) NSArray<LTCard *> *cards;

@property(nonatomic) NSInteger score;

@end

NS_ASSUME_NONNULL_END

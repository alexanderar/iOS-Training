// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@interface LTCard : NSObject

- (int)match:(NSArray *)otherCards;

@property (strong, nonatomic) NSAttributedString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

@end

NS_ASSUME_NONNULL_END

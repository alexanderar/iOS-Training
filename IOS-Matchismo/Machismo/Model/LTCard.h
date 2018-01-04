// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

@interface LTCard : NSObject
@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int) match:(NSArray *) otherCards;
@end


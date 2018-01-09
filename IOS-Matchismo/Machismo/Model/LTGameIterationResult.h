// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard;

///Object that represent a result of single action in card matching game.
///Action is choosin/unchoosing a card which chould trigger matching logic.
@interface LTGameIterationResult : NSObject

-(instancetype)init NS_UNAVAILABLE;

///Initializes a new result with \c cards and \c score.
- (instancetype) initWithCards:(NSArray *)cards withScore:(NSInteger)score
    NS_DESIGNATED_INITIALIZER;

///Collection of chosen cards that were used in this action.
@property(readonly, nonatomic) NSArray<LTCard *> *cards;

///Action score which is non zero in case that matching was triggered and resulted in either a
///penalty or a reward score.
@property(nonatomic) NSInteger score;

@end

NS_ASSUME_NONNULL_END

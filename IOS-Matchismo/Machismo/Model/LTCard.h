// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

/// Base object that represents a generic card in any card matching game.
@interface LTCard : NSObject

+ (NSSet *)keyPathsForValuesAffectingCard;

/// Card content.
@property (strong, nonatomic) NSString *contents;

/// Property that indicates whether the card is chosen or not.
@property (nonatomic, getter=isChosen) BOOL chosen;

/// Property that indicates whether the card is already matched or not.
@property (nonatomic, getter=isMatched) BOOL matched;

@end

NS_ASSUME_NONNULL_END

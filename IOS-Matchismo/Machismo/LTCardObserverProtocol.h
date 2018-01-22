// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.


#import "LTCard.h"

/// Protocol for handling /c LTCard change events such as /c changed and /c matched flags changes.
@protocol LTCardObserverProtocol

/// Method that should be executed when /c card chosen flag value chanes.
- (void)onCardChosenStatusChanged:(LTCard *)card;

/// Method that should be executed when /c card matched flag value chanes.
- (void)onCardMtchedStatusChanged:(LTCard *)card;

@end



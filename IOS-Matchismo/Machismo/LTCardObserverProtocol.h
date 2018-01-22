// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.


#import "LTCard.h"

@protocol LTCardObserverProtocol

- (void)onCardChosenStatusChanged:(LTCard *)card;

- (void)onCardMtchedStatusChanged:(LTCard *)card;

@end



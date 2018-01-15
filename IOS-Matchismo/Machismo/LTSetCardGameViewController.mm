// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardGameViewController.h"
#import "LTSetCardMatchingGame.h"
#import "LTSetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardGameViewController

//- (UIImage *)backgroundImageForCard:(LTCard *)card {
//  return [UIImage imageNamed:card.isChosen ? @"setCardCardfront" : @"cardfront"];
//}
//
//- (NSAttributedString *)titleForCard:(LTCard *)card {
//  return [self cardContent:card];
//}

//- (NSAttributedString *)cardContent:(LTSetCard *)setCard {
//  auto stringContent = [[NSMutableString alloc] initWithCapacity:setCard.number];
//  for (int i = 0; i < setCard.number; ++i) {
//    [stringContent appendString:setCard.shape];
//  }
//  auto color = [LTSetCardGameViewController colorFromHexString:setCard.colorHexString];
//  auto attributes = [[NSMutableDictionary alloc] init];
//  attributes[NSStrokeWidthAttributeName] = @-5;
//  attributes[NSStrokeColorAttributeName] = color;
//  attributes[NSForegroundColorAttributeName] =
//      [color colorWithAlphaComponent:pow((double)setCard.shade / 2,2)];
//  auto attrContent = [[NSAttributedString alloc] initWithString:stringContent
//                                                     attributes:attributes];
//  return attrContent;
//}

- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger)count{
  return [[LTSetCardMatchingGame alloc] initWithCardCount:count];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                         green:((rgbValue & 0xFF00) >> 8) / 255.0
                          blue:(rgbValue & 0xFF) / 255.0 alpha:1.0];
}


@end

NS_ASSUME_NONNULL_END

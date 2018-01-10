// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCard.h"
#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCard

static NSSet<NSString *> *_validShapes = nil;
static NSSet<UIColor *> *_validColors = nil;


- (instancetype)initWithShape:(NSString *)shape color:(NSString *)colorHexString
                        shade:(LTSetCardShade)shade number:(NSUInteger) number {
  if (self=[super init]) {
    if ([[LTSetCard validShapes] containsObject:shape] &&
       [[LTSetCard validColors] containsObject:colorHexString] &&
       number >=1  && number <= 3) {
      _shape = shape;
      _colorHexString = colorHexString;
      _number = number;
      _shade = shade;
    } else {
      self = nil;
    }
  }
  return self;
}

- (NSString *)contents {
  return nil;
}

+ (NSSet<NSString *> *)validShapes {
  if (!_validShapes) {
    _validShapes = [[NSSet alloc] initWithArray: @[@"◼︎",@"▶︎",@"●"]];
  }
  return _validShapes;
}

+ (NSSet<UIColor *> *)validColors {
  if (!_validColors) {
    _validColors = [[NSSet alloc] initWithArray: @[@"#FF0000", @"#00FF00", @"#0000FF"]];
  }
  return _validColors;
}

+ (NSUInteger) maxNumber {
  return 3;
}

@end

NS_ASSUME_NONNULL_END

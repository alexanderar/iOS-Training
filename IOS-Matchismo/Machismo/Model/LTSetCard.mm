// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCard.h"
#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCard

static NSSet<NSString *> *_validShapes = nil;
static NSSet<UIColor *> *_validColors = nil;


- (instancetype)initWithShape:(NSString *)shape color:(UIColor *)color shade:(LTSetCardShade)shade
    number:(NSUInteger) number {
  if(self=[super init])
  {
    if([[LTSetCard validShapes] containsObject:shape] &&
       [[LTSetCard validColors] containsObject:color] &&
       number >=1  && number <= 3) {
      _shape = shape;
      _color = color;
      _number = number;
      _shade = shade;
    } else {
      self = nil;
    }
  }
  return self;
}

- (NSAttributedString *)contents {
  NSMutableString *stringContent = [[NSMutableString alloc] initWithCapacity:self.number];
  for (int i =0; i<self.number; i++) {
    [stringContent appendString:self.shape];
  }
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  attributes[NSStrokeWidthAttributeName] = @-5;
  attributes[NSStrokeColorAttributeName] = self.color;
  attributes[NSForegroundColorAttributeName] =
      [self.color colorWithAlphaComponent:(float)self.shade / 2];
  NSAttributedString *attrContent = [[NSAttributedString alloc] initWithString:stringContent
    attributes:attributes];
  return attrContent;
}

+ (NSSet<NSString *> *)validShapes {
  if(!_validShapes) {
    _validShapes = [[NSSet alloc] initWithArray: @[@"◼︎",@"▶︎",@"●"]];
  }
  return _validShapes;
}

+ (NSSet<UIColor *> *)validColors {
  if(!_validColors) {
    _validColors = [[NSSet alloc] initWithArray: @[[UIColor redColor], [UIColor greenColor],
       [UIColor purpleColor]]];
  }
  return _validColors;
}

+ (NSUInteger) maxNumber {
  return 3;
}

@end

NS_ASSUME_NONNULL_END

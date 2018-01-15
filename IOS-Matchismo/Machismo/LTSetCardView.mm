// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardView.h"
#import "LTSetCardView.h"
#import "LTSetCard.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardView

@synthesize card = _card;

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect{
  // Drawing code
  auto *roundedRect =
  [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  
  [roundedRect addClip];
  
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
  
  if (self.card.isChosen) {
    self.alpha = 0.6f;
  }
  if (self.card.isMatched) {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                      self.alpha = 0.0;
                    } completion:^(BOOL finished) {
                      [self removeFromSuperview];
                    }];
    
  }
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

#define SHAPE_VOFFSET1_PERCENTAGE 0.090
#define SHAPE_VOFFSET2_PERCENTAGE 0.175
#define SHAPE_VOFFSET3_PERCENTAGE 0.270
- (void)drawShapes {
  CGFloat shapeHeight = self.bounds.size.height * self.cardContentScaleFactor /
      self.setGameCard.number;
  CGFloat shapeWidth = self.bounds.size.width * self.cardContentScaleFactor;
  CGFloat shapeOriginX = (self.bounds.size.width - shapeWidth) / 2;
  CGFloat shapeOriginY = (self.bounds.size.height -
                          (self.bounds.size.height * self.cardContentScaleFactor)) / 2;
  for (int i = 1; i <= self.setGameCard.number; ++i) {
    CGRect shapeContainer = CGRectMake(shapeOriginX, shapeOriginY + (i - 1) * shapeHeight,
                                       shapeWidth, shapeHeight);
    [self drawShapeInRectangle:shapeContainer];
  }
}



- (void)drawShapeInRectangle:(CGRect)rectangle {
  
}

- (LTSetCard *)setGameCard {
  return (LTSetCard *)self.card;
}

-(void)setCard:(LTCard *)card{
  if ([card isKindOfClass:LTSetCard.class])
  {
    _card = card;
    [self setNeedsDisplay];
  }
}

@end

NS_ASSUME_NONNULL_END

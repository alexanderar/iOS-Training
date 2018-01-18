// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardView.h"
#import "LTSetCardView.h"
#import "LTSetCard.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardView

# pragma mark -
# pragma mark - Draw
# pragma mark -

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define SHAPE_LINE_WIDTH_RATIO 0.02

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
  
  [self drawShapes];
  if (self.card.isMatched)
  {
    return;
  }
  if (self.card.isChosen) {
    self.alpha = 0.6f;
    [[UIColor blueColor] setStroke];
    roundedRect.lineWidth = roundedRect.lineWidth * 2;
    [roundedRect stroke];
  } else {
    self.alpha = 1;
    [[UIColor blackColor] setStroke];
    roundedRect.lineWidth = roundedRect.lineWidth;
    [roundedRect stroke];
  }
}

- (void)drawShapes {
  CGFloat singleShapeHeight = self.bounds.size.height * self.cardContentScaleFactor / 3;
  CGFloat allShapesHeight = self.gameCard.number * singleShapeHeight;
  CGFloat shapeWidth = self.bounds.size.width * self.cardContentScaleFactor;
  CGFloat shapeOriginX = (self.bounds.size.width - shapeWidth) / 2;
  CGFloat topShapeOriginY = (self.bounds.size.height - allShapesHeight) / 2;

  for (int i = 1; i <= self.gameCard.number; ++i) {
    CGRect shapeContainer = CGRectMake(shapeOriginX, topShapeOriginY + (i - 1) *
                                       singleShapeHeight, shapeWidth, singleShapeHeight);
    
    [self drawShapeInFrame:shapeContainer];
  }
}


- (void)drawShapeInFrame:(CGRect)frame {
  UIColor *shapeColor = [LTSetCardView colorFromHexString:self.gameCard.colorHexString];
  [shapeColor setStroke];
  UIBezierPath *path = nil;
  if ([self.gameCard.shape isEqualToString:@"oval"]) {
    path = [self getOvalPathInFrame:frame];
  }
  if ([self.gameCard.shape isEqualToString:@"squiggle"]) {
    path = [self getSquigglePathInFrame:frame];
  }
  if ([self.gameCard.shape isEqualToString:@"diamond"]) {
    path = [self getDiamondPathInFrame:frame];
  }
  path.lineWidth = frame.size.width * SHAPE_LINE_WIDTH_RATIO;
  [path stroke];
  [self fillPath:path inFrame:frame withColor:shapeColor];
}

# pragma mark -
# pragma mark - Shape
# pragma mark -


#define OVAL_WIDTH_RATIO 	0.12
#define OVAL_HEIGTH_RATIO 0.4

- (UIBezierPath *)getOvalPathInFrame:(CGRect)frame {
  auto ovalFrame = CGRectInset(frame, frame.size.width * 0.1f	, frame.size.height * 0.1f);
  return [UIBezierPath bezierPathWithOvalInRect:ovalFrame];
}

- (UIBezierPath* )getDiamondPathInFrame:(CGRect)frame {
  auto *path = [[UIBezierPath alloc] init];
  auto innerFrame = CGRectInset(frame, frame.size.width * 0.1f, frame.size.height * 0.1f);
  [path moveToPoint:CGPointMake(innerFrame.origin.x,
                                innerFrame.origin.y + innerFrame.size.height / 2)];
  [path addLineToPoint:CGPointMake(innerFrame.origin.x + innerFrame.size.width / 2,
                                   innerFrame.origin.y)];
  [path addLineToPoint:CGPointMake(innerFrame.origin.x + innerFrame.size.width,
                                   innerFrame.origin.y + innerFrame.size.height /2)];
  [path addLineToPoint:CGPointMake(innerFrame.origin.x + innerFrame.size.width / 2,
                                   innerFrame.origin.y + innerFrame.size.height)];
  [path closePath];
  return path;
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.5

- (UIBezierPath *)getSquigglePathInFrame:(CGRect)frame {
  auto innerFrame = CGRectInset(frame, frame.size.width * 0.1f, frame.size.height * 0.1f);
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(innerFrame.origin.x, innerFrame.origin.y)];
  [path addCurveToPoint:CGPointMake(innerFrame.origin.x + innerFrame.size.width,
                                    innerFrame.origin.y + innerFrame.size.height)
          controlPoint1:CGPointMake(innerFrame.origin.x + innerFrame.size.width / 4,
                                    innerFrame.origin.y + innerFrame.size.height / 2)
          controlPoint2:CGPointMake(innerFrame.origin.x + innerFrame.size.width * 3 / 4,
                                    innerFrame.origin.y - innerFrame.size.height * SQUIGGLE_FACTOR)];
  [path addCurveToPoint:CGPointMake(innerFrame.origin.x, innerFrame.origin.y)
          controlPoint1:CGPointMake(innerFrame.origin.x + innerFrame.size.width * 3 / 4,
                                    innerFrame.origin.y + innerFrame.size.height / 2)
          controlPoint2:CGPointMake(innerFrame.origin.x + innerFrame.size.width / 4,
                                    innerFrame.origin.y + innerFrame.size.height *
                                    ( 1 + SQUIGGLE_FACTOR))];
  return path;
}

# pragma mark -
# pragma mark - Shade
# pragma mark -

#define STRIPE_FREEQUENCY_FACTOR 12
#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5
- (void)fillPath:(UIBezierPath *)path inFrame:(CGRect)frame withColor:(UIColor *)color {
  [color setFill];
  [color setStroke];
  if (self.gameCard.shade == LTSetCardShadeUnfilled) {
    return;
  }
  if (self.gameCard.shade == LTSetCardShadeSolid) {
    [path fill];
    return;
  }
  if (self.gameCard.shade == LTSetCardShadeStriped)
  {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [path addClip];
    UIBezierPath *stripes = [[UIBezierPath alloc] init];
    CGPoint start = frame.origin;
    CGPoint end = start;
    CGFloat dx = self.bounds.size.width * STRIPES_OFFSET;
    end.y += frame.size.height;
    //start.y += dy * STRIPES_ANGLE;
    for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
      [stripes moveToPoint:start];
      [stripes addLineToPoint:end];
      start.x += dx;
      end.x += dx;
    }
    stripes.lineWidth = self.bounds.size.width / 2 * SHAPE_LINE_WIDTH_RATIO;
    [stripes stroke];
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
  }
}

# pragma mark -
# pragma mark - Class methods
# pragma mark -

+ (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                         green:((rgbValue & 0xFF00) >> 8) / 255.0
                          blue:(rgbValue & 0xFF) / 255.0 alpha:1.0];
}

# pragma mark -
# pragma mark - Properties
# pragma mark -

@synthesize card = _card;

- (LTSetCard *)gameCard {
  return (LTSetCard *)self.card;
}

- (void)setCard:(LTCard *)card{
  if ([card isKindOfClass:LTSetCard.class])
  {
    _card = card;
    [self setNeedsDisplay];
  }
}

# pragma mark -
# pragma mark - Initialization
# pragma mark -


- (void)setup {
  [super setup];
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

@end

NS_ASSUME_NONNULL_END

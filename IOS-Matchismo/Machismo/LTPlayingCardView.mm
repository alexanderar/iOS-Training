//
//  PlayingCardView.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "LTPlayingCardView.h"
#import "LTPlayingCard.h"

@implementation LTPlayingCardView

# pragma mark -
# pragma mark - Properties
# pragma mark -

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize card = _card;

- (LTPlayingCard *)playingCard {
  return (LTPlayingCard *)self.card;
}

- (void)setCard:(LTCard *)card {
  if ([card isKindOfClass:LTPlayingCard.class])
  {
    _card = card;
    [self setNeedsDisplay];
  }
}

- (NSString *)rankAsString {
  if (!self.playingCard.rank) {
    return @"?";
  }
  return @[@"?", @"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"]
      [self.playingCard.rank];
}

# pragma mark -
# pragma mark - LTCardObserverProtocol implementation
# pragma mark -

- (void) onCardChosenStatusChanged:(LTCard *)card {
  self.drawWithAnimation = YES;
  [self setNeedsDisplay];
}

- (void) onCardMtchedStatusChanged:(LTCard *)card {
  self.drawWithAnimation = YES;
   [self setNeedsDisplay];
}

# pragma mark -
# pragma mark - Drawing
# pragma mark -

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect {
  
  auto *roundedRect =
  [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  
  [roundedRect addClip];
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
   __weak LTPlayingCardView *weakSelf = self;
  if (self.card.chosen) {
    void (^drawFront)(void) = ^{
      auto faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",
                                            [weakSelf rankAsString], weakSelf.playingCard.suit]];
      if (faceImage) {
        CGRect imageRect = CGRectInset(weakSelf.bounds,
            weakSelf.bounds.size.width * (1.0-weakSelf.cardContentScaleFactor),
            weakSelf.bounds.size.height * (1.0-weakSelf.cardContentScaleFactor));
        [faceImage drawInRect:imageRect];
      } else {
        [self drawPips];
      }
      [self drawCorners];
    };
    if(self.drawWithAnimation) {
      [UIView transitionWithView:self duration:0.5
          options:UIViewAnimationOptionTransitionFlipFromRight animations:drawFront completion:nil];
      self.drawWithAnimation = NO;
    }
    else {
      drawFront();
    }
  } else {
    void (^drawBack)(void) = ^{
      [[UIImage imageNamed:@"cardback"] drawInRect:weakSelf.bounds];
    };
    if(self.drawWithAnimation) {
      [UIView transitionWithView:self duration:0.5
          options:UIViewAnimationOptionTransitionFlipFromLeft animations:drawBack completion:nil];
      self.drawWithAnimation = NO;
    }
    else {
      drawBack();
    }
  }
  if (self.card.matched) {
    self.userInteractionEnabled = NO;
    self.alpha = 0.6f;
  }
}


- (void)pushContextAndRotateUpsideDown {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

# pragma mark -
# pragma mark - Corners
# pragma mark -

- (void)drawCorners {
  auto paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  auto cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
  
  auto cornerText =
  [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",
                                              [self rankAsString], self.playingCard.suit]
                                  attributes:@{ NSFontAttributeName : cornerFont,
                                                NSParagraphStyleAttributeName : paragraphStyle
                                                }];
  
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];
  
  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
}

# pragma mark -
# pragma mark - Pips
# pragma mark -

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips {
  if ((self.playingCard.rank == 1) || (self.playingCard.rank == 5) || (self.playingCard.rank == 9)
      || (self.playingCard.rank == 3)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.playingCard.rank == 6) || (self.playingCard.rank == 7)
      || (self.playingCard.rank == 8)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.playingCard.rank == 2) || (self.playingCard.rank == 3) || (self.playingCard.rank == 7)
      || (self.playingCard.rank == 8) || (self.playingCard.rank == 10)) {
    [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(self.playingCard.rank != 7)];
  }
  if ((self.playingCard.rank == 4) || (self.playingCard.rank == 5) || (self.playingCard.rank == 6)
      || (self.playingCard.rank == 7) || (self.playingCard.rank == 8)
      || (self.playingCard.rank == 9) || (self.playingCard.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET3_PERCENTAGE
                    mirroredVertically:YES];
  }
  if ((self.playingCard.rank == 9) || (self.playingCard.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];
  }
}

#define PIP_FONT_SCALE_FACTOR 0.009

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown {
  if (upsideDown) [self pushContextAndRotateUpsideDown];
  auto middle = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
  auto pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width *
             PIP_FONT_SCALE_FACTOR];
  auto attributedSuit = [[NSAttributedString alloc] initWithString:self.playingCard.suit
                                                        attributes:@{
                                                                     NSFontAttributeName : pipFont
                                                                     }];
  CGSize pipSize = [attributedSuit size];
  auto pipOrigin = CGPointMake(middle.x - pipSize.width /2.0 -hoffset * self.bounds.size.width,
                               middle.y - pipSize.height /2.0 -voffset * self.bounds.size.height
                               );
  [attributedSuit drawAtPoint:pipOrigin];
  
  if (hoffset) {
    pipOrigin.x += hoffset * 2.0 * self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  
  if (upsideDown) {
    [self popContext];
  }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically {
  [self drawPipsWithHorizontalOffset:hoffset
                      verticalOffset:voffset
                          upsideDown:NO];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
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

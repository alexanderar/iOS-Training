//
//  ViewController.m
//  Machismo
//
//  Created by Alex Artyomov on 01/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "LTCard.h"
#import "LTCardGameViewController.h"
#import "LTCardMatchingGame.h"
#import "LTDeck.h"
#import "LTGrid.h"
#import "LTCardView.h"
#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@interface LTCardGameViewController ()

/// Game model.
@property (readwrite, nonatomic) LTCardMatchingGame *game;

@end

@implementation LTCardGameViewController

/// Abstract
- (LTCardMatchingGame *)createGame{
  [NSException raise:@"NSGenericException" format:@"Method not implemented"];
  return [[LTCardMatchingGame alloc] initWithCardCount:0 usingDeck: [[LTDeck alloc] init]];
}
- (UIView *)createViewFor:(LTCard *)card withFrame:(CGRect)frame {
  return  nil;
}

- (void)updateScore{
  self.navigationItem.title = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)touchCard:(UITapGestureRecognizer *) card {
  LTCardView *cardView = (LTCardView *)card.view;
  [self.game chooseCard:cardView.card];
  [self updateScore];
  [self refreshCardsGridAnimated:YES withCompletion:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.cardsDisplayGridHelper = [[LTGrid alloc] init];
  [self initGame];
  [self updateScore];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(nullable void *)context {
  if ([keyPath isEqualToString:@"cards"]){
    NSNumber *kind = change[NSKeyValueChangeKindKey];
    if([kind integerValue] == (int)NSKeyValueChangeInsertion)
    {
      LTCard *newcard = [change objectForKey:NSKeyValueChangeNewKey][0];
      [self refreshCardsGridAnimated:YES withCompletion:^{
         [self dialCard:newcard withAnimationDelay:0.1];
      }];
    }
  }
}

- (void)initGame {
  if (self.game) {
    [self.game removeObserverForGameCards:self];
  }
  self.game = [self createGame];
  self.cardsContainerView.backgroundColor = nil;
  self.cardsContainerView.opaque = NO;
  self.cardsDisplayGridHelper.size = self.cardsContainerView.bounds.size;
  self.cardsDisplayGridHelper.cellAspectRatio = (CGFloat)0.66;
  self.cardsDisplayGridHelper.minimumNumberOfCells = self.game.cardCount;
  self.gameBoardView.backgroundColor = nil;
  self.gameBoardView.opaque = NO;
  [self setCardDeckView];
  [self updateScore];
  for (int i = 0; i< self.game.cardCount; ++i) {
    LTCard *card = [self.game cardAtIndex:i];
    [self dialCard:card withAnimationDelay:i * 0.1];
  }
  [self.game registerObserverForGameCards:self];
}

- (void)dialCard:(LTCard *)card withAnimationDelay:(float)delay {
  NSUInteger index = [self.cardsContainerView.subviews count];
  UIView *cardView = [self createViewFor:card withFrame:self.cardDeckView.frame];
  [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
      action:@selector(touchCard:)]];
  [self.cardsContainerView addSubview:cardView];
  CGRect frame = [self.cardsDisplayGridHelper
                  frameOfCellAtRow:(index / self.cardsDisplayGridHelper.columnCount)
                  inColumn:(index % self.cardsDisplayGridHelper.columnCount)];

    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5
        curve:UIViewAnimationCurveEaseInOut animations:^{
          cardView.frame = frame;
        }];
    [animator startAnimationAfterDelay:delay];
    [animator startAnimation];
}

- (IBAction)resetGame {
  __weak LTCardGameViewController *weakSelf = self;
  CABasicAnimation *rotationAnimation = [LTCardGameViewController rotationAnimationBy:360];
  CGFloat radius = MAX(self.cardsContainerView.bounds.size.width,
                       self.cardsContainerView.bounds.size.height);
  UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:1
    curve:UIViewAnimationCurveEaseInOut animations:^{
      for (int i = 0; i < weakSelf.cardsContainerView.subviews.count; ++i) {
        UIView *cardView = weakSelf.cardsContainerView.subviews[i];
        [cardView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        int randomAngleInDeg = 180 + arc4random()%180;
        double randomAngleInRad = [LTCardGameViewController degreeToRadConvert:randomAngleInDeg];
        [cardView setFrame:CGRectMake(radius/cos(randomAngleInRad), radius/sin(randomAngleInRad),
                                      cardView.frame.size.width, cardView.frame.size.height)];
      }
    }];
  [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
    [weakSelf.cardsContainerView.subviews
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [weakSelf initGame];
  }];
  [animator startAnimation];
}

+ (CGFloat)degreeToRadConvert:(CGFloat)degree {
  return M_PI * degree / 180;
}

+ (CABasicAnimation *)rotationAnimationBy:(CGFloat)degrees {
  CABasicAnimation *rotationAnimation;
  rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  rotationAnimation.toValue = [NSNumber numberWithFloat:
                               [LTCardGameViewController degreeToRadConvert:degrees]];
  rotationAnimation.duration = 0.5;
  rotationAnimation.cumulative = YES;
  rotationAnimation.repeatCount = 1.0;
  rotationAnimation.timingFunction = [CAMediaTimingFunction
                                      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  return rotationAnimation;
}

- (void)refreshCardsGridAnimated:(BOOL)animated withCompletion:(nullable void (^)())callback {
}

#define CARD_DECK_HEIGHT 96.0
#define CARD_DECK_WIDTH 64.0
#define GAME_BOARD_BOTTOM_MARGIN 5.0


- (void) setCardDeckView {
  if (self.cardDeckView) {
    return;
  }
  CGFloat cardDeckOriginX = self.gameBoardView.bounds.size.width / 2 - CARD_DECK_WIDTH / 2;
  CGFloat cardDeckOriginY = self.gameBoardView.bounds.size.height - CARD_DECK_HEIGHT - 5;
  auto cardDeckFrame = CGRectMake(cardDeckOriginX, cardDeckOriginY, CARD_DECK_WIDTH,
                                  CARD_DECK_HEIGHT);
  self.cardDeckView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardback"]];
  [self.cardDeckView setFrame:cardDeckFrame];
  [self.gameBoardView addSubview:self.cardDeckView];
}

@end

NS_ASSUME_NONNULL_END

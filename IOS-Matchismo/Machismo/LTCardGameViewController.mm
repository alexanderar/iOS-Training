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


NS_ASSUME_NONNULL_BEGIN

@interface LTCardGameViewController ()

@property (nonatomic) LTGrid *gridHelper;

@property (readwrite, nonatomic) LTCardMatchingGame *game;

@property (nonatomic) UIImageView *cardDeckView;

@end

@implementation LTCardGameViewController

#define DEFAULT_CARD_COUNT 30

/// Abstract
- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count {
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
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.gridHelper = [[LTGrid alloc] init];
  [self initGame];
  [self refreshGameBoardAnimated:YES];
}

- (void)refreshGameBoardAnimated:(BOOL)animated {
  [self updateScore];
}

- (void)initGame {
  self.game = [self createGameWithCardCount: DEFAULT_CARD_COUNT];
  [self updateScore];
  self.cardsContainerView.backgroundColor = nil;
  self.cardsContainerView.opaque = NO;
  self.gridHelper.size = self.cardsContainerView.bounds.size;
  self.gridHelper.cellAspectRatio = (CGFloat)0.66;
  self.gridHelper.minimumNumberOfCells = self.game.cardCount;
  self.gameBoardView.backgroundColor = nil;
  self.gameBoardView.opaque = NO;
  [self setCardDeckView];
  for (int i = 0; i< self.game.cardCount; ++i) {
    LTCard *card = [self.game cardAtIndex:i];
    UIView *cardView = [self createViewFor:card withFrame:self.cardDeckView.frame];
    [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
        action:@selector(touchCard:)]];
    [self.cardsContainerView addSubview:cardView];
    CGRect frame = [self.gridHelper frameOfCellAtRow:(i / self.gridHelper.columnCount)
                                            inColumn:(i % self.gridHelper.columnCount)];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5
    curve:UIViewAnimationCurveEaseInOut animations:^{
      cardView.frame = frame;
    }];
    [animator startAnimationAfterDelay:i * 0.1f];
    [animator startAnimation];
  }
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

+ (CABasicAnimation *) rotationAnimationBy:(CGFloat) degrees {
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


#define CARD_DECK_HEIGHT 96.0
#define CARD_DECK_WIDTH 64.0
#define GAME_BOARD_BOTTOM_MARGIN 5.0
- (void) setCardDeckView {
  CGFloat cardDeckOriginX = self.gameBoardView.bounds.size.width / 2 - CARD_DECK_WIDTH /2;
  CGFloat cardDeckOriginY = self.gameBoardView.bounds.size.height - CARD_DECK_HEIGHT - 5;
  auto cardDeckFrame = CGRectMake(cardDeckOriginX, cardDeckOriginY,
                                  CARD_DECK_WIDTH,
                                  CARD_DECK_HEIGHT);
  self.cardDeckView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardback"]];
  [self.cardDeckView setFrame:cardDeckFrame];
  [self.gameBoardView addSubview:self.cardDeckView];
}


@end
NS_ASSUME_NONNULL_END

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

- (IBAction)resetGame {
  [[self.cardsContainerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self setup];
  [self refreshGameBoardAnimated:YES];
}

- (void)updateScore{
  self.navigationItem.title = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)touchCard:(UITapGestureRecognizer *) card {
  LTCardView *cardView = (LTCardView *)card.view;
  [self.game chooseCard:cardView.card];
  [self updateScore];
}

- (void)updateUI {

}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setup];
  [self refreshGameBoardAnimated:YES];
}

- (void)refreshGameBoardAnimated:(BOOL)animated {
  self.gridHelper.size = self.cardsContainerView.bounds.size;
  self.gridHelper.cellAspectRatio = (CGFloat)0.66;
  self.gridHelper.minimumNumberOfCells = self.game.cardCount;
  for (int i = 0; i < self.cardsContainerView.subviews.count; ++i) {
    UIView *cardView = self.cardsContainerView.subviews[i];
    CGRect frame = [self.gridHelper frameOfCellAtRow:(i / self.gridHelper.columnCount)
                                            inColumn:(i % self.gridHelper.columnCount)];
    if (animated) {
      UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5
        curve:UIViewAnimationCurveEaseInOut animations:^{
           cardView.frame = frame;
        }];
      [animator startAnimationAfterDelay:i * 0.1f];
      [animator startAnimation];
    } else {
      [cardView setFrame:frame];
    }
  }
  [self updateScore];
}

- (void)setup {
  self.game = [self createGameWithCardCount: DEFAULT_CARD_COUNT];
  self.cardsContainerView.backgroundColor = nil;
  self.cardsContainerView.opaque = NO;
  self.gridHelper = [[LTGrid alloc] init];
  self.gameBoardView.backgroundColor = nil;
  self.gameBoardView.opaque = NO;
  [self setCardDeckView];
  for (int i = 0; i< self.game.cardCount; ++i) {
    LTCard *card = [self.game cardAtIndex:i];
    CGRect frame = self.cardDeckView.frame;
    UIView *cardView = [self createViewFor:card withFrame:frame];
    [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
      action:@selector(touchCard:)]];
    [self.cardsContainerView addSubview:cardView];
  }
  [self updateScore];
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

- (void)clearGameBoard {
  [[self.cardsContainerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


@end
NS_ASSUME_NONNULL_END

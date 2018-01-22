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
#import "LTCardViewFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCardGameViewController ()

/// Game model.
@property (readwrite, nonatomic) LTCardMatchingGame *game;

@property (nonatomic) BOOL viewAppeared;

@property (nonatomic) BOOL cardsGathered;

@property (nonatomic) CGPoint cardsPileCenterLocation;
@end

@implementation LTCardGameViewController

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(nullable void *)context {
  if ([keyPath isEqualToString:@"cards"]){
    NSNumber *kind = change[NSKeyValueChangeKindKey];
    if([kind integerValue] == (int)NSKeyValueChangeInsertion)
    {
      LTCard *newcard = [change objectForKey:NSKeyValueChangeNewKey][0];
      [self dialCard:newcard withAnimationDelay:0.1];
      [self refreshCardsGridAnimated:YES];
    }
  }
}

# pragma mark -
# pragma mark - Gestures
# pragma mark -

- (void)touchCard:(UITapGestureRecognizer *) card {
  if(!self.cardsGathered)
  {
    LTCardView *cardView = (LTCardView *)card.view;
    [self.game chooseCard:cardView.card];
    [self updateScore];
    [self refreshCardsGridAnimated:YES];
  } else {
    [self rearangeCardsFromPile];

  }
}

- (void)moveCardsPileViaPanGesture:(UIPanGestureRecognizer *)panGesture {
  if (!self.cardsGathered) {
    return;
  }
  if(panGesture.state ==
     UIGestureRecognizerStateChanged) {
    [self moveCardsPileToPoint:[panGesture translationInView:self.cardsContainerView.superview]];
  }
}

- (void)rearangeCardsFromPile {
  self.cardsGathered = NO;
  [self resetCardsPileCenter];
  [self refreshCardsGridAnimated:YES];
}

- (void)resetCardsPileCenter {
  self.cardsPileCenterLocation = CGPointMake(self.cardsContainerView.bounds.size.width / 2,
                                             self.cardsContainerView.bounds.size.height / 2);
}

- (void)moveCardsPileToPoint:(CGPoint)point {
  for (LTCardView *cardView in self.cardsContainerView.subviews){
//    CGFloat xDistanceFormPileCenter = self.cardsPileCenterLocation.x - cardView.frame.origin.x;
//    CGFloat yDistanceFormPileCenter = self.cardsPileCenterLocation.y - cardView.frame.origin.y;
//    [cardView setFrame:CGRectMake(point.x + xDistanceFormPileCenter, point.y +
//        yDistanceFormPileCenter, cardView.frame.size.width, cardView.frame.size.height)];
    cardView.center	 = CGPointMake(cardView.center.x + point.x, cardView.center.y + point.y);
  }
  self.cardsPileCenterLocation = point;
}

- (void)gatherCardsViaPinchGesture:(UIPinchGestureRecognizer *)pinchGesture {
  if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state
      == UIGestureRecognizerStateChanged) {
    CGFloat scale = [pinchGesture scale];
    if(scale < 1) {
      self.cardsGathered = YES;
      for (LTCardView *cardView in self.cardsContainerView.subviews) {
        CGFloat cardsContainerViewCenterX = self.cardsContainerView.bounds.size.width / 2 -
            cardView.bounds.size.width / 2;
        CGFloat cardsContainerViewCenterY = self.cardsContainerView.bounds.size.height / 2 -
            cardView.bounds.size.height / 2;
        CGFloat cardOriginX = cardView.frame.origin.x;
        CGFloat cardOriginY = cardView.frame.origin.y;
        CGFloat transformX, transformY;
        if(abs(cardsContainerViewCenterX - cardOriginX) < 0.0000001) {
          transformX = 0;
          transformY = (cardsContainerViewCenterY - cardOriginY) * (1 - scale);
        } else {
          CGFloat pathIncline = (cardsContainerViewCenterY - cardOriginY) /
              (cardsContainerViewCenterX - cardOriginX);
          CGFloat offset = cardOriginY - pathIncline * cardOriginX;
          transformX = (cardsContainerViewCenterX - cardOriginX) * (1 - scale);
          CGFloat newCardOriginY = pathIncline * (cardOriginX + transformX) + offset;
          transformY = newCardOriginY - cardOriginY;
        }
        auto transform = CGAffineTransformTranslate(cardView.transform, transformX, transformY);
        cardView.transform = transform;
        pinchGesture.scale = 1;
      }
    }
  }
}

# pragma mark -
# pragma mark - View Controller Lifecycle
# pragma mark -

-(void)viewDidLoad {
  [self.cardDeckView setImage:[UIImage imageNamed:@"cardback"]];
  [self.cardsContainerView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
      initWithTarget:self action:@selector(gatherCardsViaPinchGesture:)]];
  auto panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
      action:@selector(moveCardsPileViaPanGesture:)];
  panRecognizer.minimumNumberOfTouches = 1;
  panRecognizer.maximumNumberOfTouches = 1;
  [self resetCardsPileCenter];
  [self.cardsContainerView addGestureRecognizer:panRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (!self.viewAppeared) {
    self.cardsDisplayGridHelper = [[LTGrid alloc] init];
    [self initGame];
    [self updateScore];
    self.viewAppeared = YES;
  }
}

- (void)viewDidLayoutSubviews {
  [self refreshCardsGridAnimated:YES];
}

# pragma mark -
# pragma mark - Game commands
# pragma mark -

/// Abstract
- (LTCardMatchingGame *)createGame{
  [NSException raise:@"NSGenericException" format:@"Method not implemented"];
  return [[LTCardMatchingGame alloc] initWithCardCount:0 usingDeck: [[LTDeck alloc] init]];
}

- (void)updateScore{
  self.navigationItem.title = [NSString stringWithFormat:@"Score: %ld", self.game.score];
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
  [self updateScore];
  for (int i = 0; i< self.game.cardCount; ++i) {
    LTCard *card = [self.game cardAtIndex:i];
    [self dialCard:card withAnimationDelay:i * 0.1];
  }
  [self.game registerObserverForGameCards:self];
}

- (void)dialCard:(LTCard *)card withAnimationDelay:(float)delay {
  NSUInteger index = [self.cardsContainerView.subviews count];
  CGFloat originX = self.cardDeckView.frame.origin.x + self.cardDeckView.frame.size.width / 2;
  CGFloat originY = self.cardDeckView.frame.origin.y;
  UIView *cardView = [LTCardViewFactory createViewForCard:card
                                                withFrame: CGRectMake(originX, originY, 0, 0)];
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
  [self rearangeCardsFromPile];
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
                                        cardView.bounds.size.width, cardView.bounds.size.height)];
        }
      }];
  [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
    [weakSelf.cardsContainerView.subviews
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [weakSelf initGame];
  }];
  [animator startAnimation];
}

- (void)refreshCardsGridAnimated:(BOOL)animated {
  self.cardsDisplayGridHelper.size = self.cardsContainerView.bounds.size;
  self.cardsDisplayGridHelper.minimumNumberOfCells = [self.cardsContainerView.subviews count];
  __weak LTCardGameViewController *weakSelf = self;
  void (^refreshCardsBlock)(void) = ^{
    for (int i = 0; i < weakSelf.cardsContainerView.subviews.count; ++i) {
      LTCardView *cardView = (LTCardView *)weakSelf.cardsContainerView.subviews[i];
      CGRect frame = [weakSelf.cardsDisplayGridHelper
                      frameOfCellAtRow:(i / weakSelf.cardsDisplayGridHelper.columnCount)
                      inColumn:(i % weakSelf.cardsDisplayGridHelper.columnCount)];
      if (![LTCardGameViewController viewPositionAndSizeAreTheSame:cardView asFrame:frame]) {
        [cardView setFrame:frame];
        [cardView setNeedsDisplay];
      }
    }
  };
  if (animated) {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.2f
        curve:UIViewAnimationCurveEaseInOut animations:refreshCardsBlock];
    [animator startAnimation];
  }
  else {
    refreshCardsBlock();
  }
}

# pragma mark -
# pragma mark - Class methods
# pragma mark -

+ (BOOL)viewPositionAndSizeAreTheSame:(UIView *)view asFrame:(CGRect)frame {
  float sigma = 0.000001;
  return abs(view.bounds.size.width - frame.size.width) <= sigma
      && abs(view.bounds.size.height - frame.size.height) <= sigma
      && abs(view.frame.origin.x - frame.origin.x) <= sigma
      && abs(view.frame.origin.y - frame.origin.y) <= sigma;
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

@end

NS_ASSUME_NONNULL_END

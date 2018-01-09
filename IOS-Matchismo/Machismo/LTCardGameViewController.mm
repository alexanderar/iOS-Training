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
#import "LTGameIterationResult.h"

NS_ASSUME_NONNULL_BEGIN
@interface LTCardGameViewController ()

///Collection of all cards displayed on the screen
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

///Game model
@property (strong, nonatomic) LTCardMatchingGame *game;

///Label that displays a last consideration result.
@property (weak, nonatomic) IBOutlet UILabel *lastConsiderationLabel;

///Label the shows a score.
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation LTCardGameViewController

///Abstract
- (UIImage *)backgroundImageForCard:(LTCard *)card {
  return nil;
}

///Abstract
- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count {
  return nil;
}

- (IBAction)resetGame {
  self.game = [self createGameWithCardCount: self.cardButtons.count];
  [self updateUI];
}

- (void)setLastConsiderationLabelText {
  LTGameIterationResult *lastResult = [self.game.history lastObject];
  if(!lastResult) {
    self.lastConsiderationLabel.attributedText = [[NSAttributedString alloc]initWithString:@""];
    return;
  }
  NSMutableAttributedString *chosenCardsText = [[NSMutableAttributedString alloc] init];
  for(LTCard *card in lastResult.cards) {
    [chosenCardsText appendAttributedString:card.contents];
    [chosenCardsText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@" "]];
  }
  if(lastResult.score == 0) {
    self.lastConsiderationLabel.attributedText = chosenCardsText;
    return;
  }
  NSMutableAttributedString *labelText;
  if(lastResult.score > 0) {
    labelText = [[NSMutableAttributedString alloc] initWithString: @"Matched "];
    [labelText appendAttributedString:chosenCardsText];
    [labelText appendAttributedString:[[NSAttributedString alloc] initWithString:
        [NSString stringWithFormat:@"for %ld points", lastResult.score]]];
  } else {
    labelText = [[NSMutableAttributedString alloc] initWithAttributedString:chosenCardsText];
    [labelText appendAttributedString:[[NSAttributedString alloc] initWithString:
      [NSString stringWithFormat:@"don't match! %ld point penalty",
       lastResult.score]]];
  }
  self.lastConsiderationLabel.attributedText = labelText;
}

//abstract
- (NSAttributedString *)titleForCard:(LTCard *)card {
  return nil;
}

- (IBAction)touchCardButton:(UIButton *)button {
  NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:button];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardButtons) {
    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    LTCard *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setAttributedTitle:[self titleForCard:card]
      forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                          forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    [self setLastConsiderationLabelText];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self resetGame];
}

@end
NS_ASSUME_NONNULL_END

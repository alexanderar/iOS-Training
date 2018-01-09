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
#import "LTGameHistoryController.h"

NS_ASSUME_NONNULL_BEGIN
@interface LTCardGameViewController ()

///Collection of all cards displayed on the screen
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

///Game model
@property (strong, nonatomic) LTCardMatchingGame *game;

///Label that displays a last consideration result.
@property (weak, nonatomic) IBOutlet UILabel *lastConsiderationLabel;

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

- (NSAttributedString *) createGameStatusTextFor:(LTGameIterationResult *)iterationResult {
  if(!iterationResult) {
    return [[NSAttributedString alloc]initWithString:@""];
  }
  NSMutableAttributedString *chosenCardsText = [[NSMutableAttributedString alloc] init];
  for(LTCard *card in iterationResult.cards) {
    [chosenCardsText appendAttributedString:[self cardContent:card]];
    [chosenCardsText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@" "]];
  }
  if(iterationResult.score == 0) {
    return chosenCardsText;
  }
  NSMutableAttributedString *text;
  if(iterationResult.score > 0) {
    text = [[NSMutableAttributedString alloc] initWithString: @"Matched "];
    [text appendAttributedString:chosenCardsText];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:
        [NSString stringWithFormat:@"for %ld points", iterationResult.score]]];
  } else {
    text = [[NSMutableAttributedString alloc] initWithAttributedString:chosenCardsText];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:
        [NSString stringWithFormat:@"don't match! %ld point penalty", iterationResult.score]]];
  }
  return text;
}

- (void)setLastConsiderationLabelText {
  self.lastConsiderationLabel.attributedText = [self createGameStatusTextFor:
      [self.game.history lastObject]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if([segue.identifier isEqualToString:@"ShowHistory"]) {
    if([segue.destinationViewController isKindOfClass:[LTGameHistoryController class]]) {
      auto historyController = (LTGameHistoryController *)segue.destinationViewController;
      NSMutableArray *gameHistory = [[NSMutableArray alloc]init];
      for (int i = 0; i < self.game.history.count; i++) {
        LTGameIterationResult *result = self.game.history[i];
        if(result && result.score != 0) {
          [gameHistory addObject:[self createGameStatusTextFor:result]];
        }
      }
      historyController.history = gameHistory;
    }
  }
}

//Abstract
- (NSAttributedString *)titleForCard:(LTCard *)card {
  return nil;
}

//Abstract
- (NSAttributedString *)cardContent:(LTCard *)card {
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
    self.title = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  }
  [self setLastConsiderationLabelText];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self resetGame];
}

@end
NS_ASSUME_NONNULL_END

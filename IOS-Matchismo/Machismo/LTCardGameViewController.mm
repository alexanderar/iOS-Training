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
#import "LTPlayingCardDeck.h"
NS_ASSUME_NONNULL_BEGIN
@interface LTCardGameViewController ()

@property (nonatomic, readonly) NSUInteger allowedNumberOfCheckedCards;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *cardButtons;
@property (strong, nonatomic) LTCardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lastConsiderationLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation LTCardGameViewController

- (NSUInteger)allowedNumberOfCheckedCards{
  return self.gameModeSwitch.selectedSegmentIndex + 2;
}

- (UIImage *)backgroundImageForCard:(LTCard *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (LTDeck *)createDeck {
  return [[LTPlayingCardDeck alloc] init];
}

- (IBAction)gameModeChanged {
  self.game.allowedNumberOfChosenCards = self.allowedNumberOfCheckedCards;
  [self resetGame];
}

- (void)initGame {
  _game = [[LTCardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck:[self createDeck]
                         withAllowedNumberOfChosenCards:self.allowedNumberOfCheckedCards];
}

- (IBAction)resetGame {
  [self initGame];
  [self updateUI];
  self.gameModeSwitch.enabled = YES;
}

- (void)setLastConsiderationLabelText {
  NSMutableArray *chosenCardsContents = [[NSMutableArray alloc]
                                         initWithCapacity:[self.game.lastConsiderationCards count]];
  for(LTCard *card in self.game.lastConsiderationCards) {
    [chosenCardsContents addObject:card.contents.string];
  }
  
  NSString *chosenCardsText = [chosenCardsContents componentsJoinedByString:@" "];
  
  if(self.game.lastConsiderationResult == 0) {
    self.lastConsiderationLabel.text = chosenCardsText;
    return;
  }
  if(self.game.lastConsiderationResult > 0) {
    self.lastConsiderationLabel.text =
    [NSString stringWithFormat:@"Matched %@ for %ld points", chosenCardsText,
     self.game.lastConsiderationResult];
  } else {
    self.lastConsiderationLabel.text =
    [NSString stringWithFormat:@"%@ don't match! %ld point penalty", chosenCardsText,
     -self.game.lastConsiderationResult];
  }
}

- (NSString *)titleForCard:(LTCard *)card {
  return card.isChosen ? card.contents.string : @"";
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
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                          forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    [self setLastConsiderationLabelText];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initGame];
}

@end
NS_ASSUME_NONNULL_END

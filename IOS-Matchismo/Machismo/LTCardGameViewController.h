//
//  ViewController.h
//  Machismo
//
//  Created by Alex Artyomov on 01/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTDeck.h"
#import "LTCardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

///Object that represnts a base card game view controller. Any particular card game view controller
///should derive from it.
@interface LTCardGameViewController : UIViewController

///Returns a background image for a \c card.
///Abstract.
- (UIImage *)backgroundImageForCard:(LTCard *)card;

///Creates a new game with number of cards specified by \c count.
// abstract
- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count;

///Returns a title for a \c card. Takes into consideration wether card is chosen or not
///Abstract.
- (NSAttributedString *)titleForCard:(LTCard *)card;

- (NSAttributedString *)cardContent:(LTCard *)card;

///Target action that is triggered when user tuches a card.
- (IBAction)touchCardButton:(UIButton *) button;

@end
NS_ASSUME_NONNULL_END


//
//  ViewController.h
//  Machismo
//
//  Created by Alex Artyomov on 01/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

@class LTGrid;

/// Object that represnts a base card game view controller. Any particular card game view controller
/// should derive from it.
@interface LTCardGameViewController : UIViewController

/// Creates a new game with number of cards specified by \c count.
/// Abstract.
- (LTCardMatchingGame *)createGame;

/// Initializes a new game. Includes all the logic of initiali positioning of subvieews,
/// subscriptions to KVO and etc.
- (void)initGame;

/// Refreshes cards grid. In set game this method removes matched cards from the display grid and
/// ajusts remaining cards positions. Same ajustment is done when new cards are added to the grid.
/// If \c callback is provided it is involked when repositioning is completed.
- (void)refreshCardsGridAnimated:(BOOL)animated;

///// Target action that is triggered when user tuches a card.
- (void)touchCard:(UITapGestureRecognizer *) card;

/// View that contains all the card views.
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;

/// View that displays a deck of cards.
@property (nonatomic) IBOutlet UIImageView *cardDeckView;

/// Grid helper that is used to allign card views on the screen based on \c cardsContainerView
/// dimentions.
@property (nonatomic, strong) LTGrid *cardsDisplayGridHelper;

/// Game model.
@property (readonly, nonatomic ) LTCardMatchingGame *game;

@end
NS_ASSUME_NONNULL_END


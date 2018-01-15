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

/// View that contains all the card views
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;

/// Game board view that serves as a master view for all the nested views used in the game
@property (weak, nonatomic) IBOutlet UIView *gameBoardView;

/// Grid helper that is used to allign card views on the screen based on /c cardsContainerView
/// dimentions
@property (nonatomic, strong) LTGrid *cardsDisplayGridHelper;

/// Game model
@property (readonly, nonatomic ) LTCardMatchingGame *game;

/// Creates a new game with number of cards specified by \c count.
/// Abstract
- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count;

- (UIView *)createViewFor:(LTCard *)card withFrame:(CGRect)frame;

- (void)refreshGameBoardAnimated:(BOOL)animated;

///// Target action that is triggered when user tuches a card.
- (void)touchCard:(UITapGestureRecognizer *) card;

@end
NS_ASSUME_NONNULL_END


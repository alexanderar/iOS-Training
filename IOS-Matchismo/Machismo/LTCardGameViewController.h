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
@interface LTCardGameViewController : UIViewController

- (IBAction)touchCardButton:(UIButton *) button;

// abstract
- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count;
// abstract
- (NSAttributedString *)titleForCard:(LTCard *)card;
// abstract
- (UIImage *)backgroundImageForCard:(LTCard *)card;

@end
NS_ASSUME_NONNULL_END


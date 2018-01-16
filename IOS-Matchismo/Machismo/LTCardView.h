//
//  Header.h
//  Machismo
//
//  Created by Alex Artyomov on 14/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@class LTCard;

///Generic view that is used to display a card
@interface LTCardView : UIView

/// Performs all the setup opreations that are needed on view initailzation. This is method will be
/// called in /c initWithFrame and /c awaikeFromNib methods
- (void)setup;

/// Card model
@property (nonatomic) LTCard *card;

/// Property that defines the ratio between size of the card view and its content.
@property (nonatomic) CGFloat cardContentScaleFactor;

@end

NS_ASSUME_NONNULL_END

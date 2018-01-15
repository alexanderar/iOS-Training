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

/// Card model
@property (nonatomic) LTCard *card;

@end

NS_ASSUME_NONNULL_END

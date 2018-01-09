// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import <UIKit/UIKit.h>
#import "LTGameIterationResult.h"
NS_ASSUME_NONNULL_BEGIN

///View controller that displays game history
@interface LTGameHistoryController : UIViewController

///Game history represented as a collection of text messages
@property(nonatomic) NSArray<NSAttributedString *> *history;

///History text view
@property (weak, nonatomic) IBOutlet UITextView *historyView;

@end

NS_ASSUME_NONNULL_END

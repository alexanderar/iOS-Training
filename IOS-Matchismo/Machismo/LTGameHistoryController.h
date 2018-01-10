// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import <UIKit/UIKit.h>
#import "LTGameIterationResult.h"
NS_ASSUME_NONNULL_BEGIN

/// View controller that displays game's history. It receives an array of \c NSAttributedString
/// where each element in the array displayed in a new row on the \c historyView.
@interface LTGameHistoryController : UIViewController

/// Game history represented as a collection of text messages.
@property(nonatomic) NSArray<NSAttributedString *> *history;

/// History text view.
@property (weak, nonatomic) IBOutlet UITextView *historyView;

@end

NS_ASSUME_NONNULL_END

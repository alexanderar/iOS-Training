// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTGameHistoryController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTGameHistoryController


-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSAttributedString *joinElement = [[NSAttributedString alloc] initWithString:@"\n\n"];
  NSMutableAttributedString *historyText = [[NSMutableAttributedString alloc] init];
  for (int i = 0; i< self.history.count; i++) {
    [historyText appendAttributedString:self.history[i]];
    [historyText appendAttributedString:joinElement];
  }
  [historyText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15]
      range:NSMakeRange(0, historyText.length)];
  self.historyView.attributedText = historyText;
}



@end

NS_ASSUME_NONNULL_END

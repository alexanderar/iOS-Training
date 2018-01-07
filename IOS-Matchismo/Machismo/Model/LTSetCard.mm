// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCard.h"
#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN
@interface LTSetCard()

@property (nonatomic, strong) NSPredicate *shapeMatchPredicate;
@property (nonatomic, strong) NSPredicate *shadeMatchPredicate;
@property (nonatomic, strong) NSPredicate *numberMatchPredicate;
@property (nonatomic, strong) NSPredicate *colorMatchPredicate;
@end

@implementation LTSetCard

static NSSet<NSString *> *_validShapes = nil;
static NSSet<UIColor *> *_validColors = nil;


- (instancetype)initWithShape:(NSString *)shape color:(UIColor *)color shade:(LTSetCardShade)shade
    number:(NSUInteger) number {
  if(self=[super init])
  {
    if([[LTSetCard validShapes] containsObject:shape] &&
       [[LTSetCard validColors] containsObject:color] &&
       number >=1  && number <= 3) {
      _shape = shape;
      _color = color;
      _number = number;
      _shade = shade;
    } else {
      self = nil;
    }
  }
  return self;
}

- (NSAttributedString *)contents {
  NSMutableString *stringContent = [[NSMutableString alloc] initWithCapacity:self.number];
  for (int i =0; i<self.number; i++) {
    [stringContent appendString:self.shape];
  }
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  attributes[NSForegroundColorAttributeName] = self.shade == LTSetCardShadeOpen ?
      [UIColor whiteColor] : self.color;
  attributes[NSStrokeWidthAttributeName] = @-3;
  attributes[NSStrokeColorAttributeName] = self.color;
  if(self.shade != LTSetCardShadeOpen) {
    attributes[NSForegroundColorAttributeName] = [self.color colorWithAlphaComponent:
                                                  (NSInteger)self.shade / 2];
  } else {
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
  }
  
  NSAttributedString *attrContent = [[NSAttributedString alloc] initWithString:stringContent
                                                                    attributes:attributes];
  return attrContent;
}

+ (NSSet<NSString *> *)validShapes {
  if(!_validShapes) {
    _validShapes = [[NSSet alloc] initWithArray: @[@"◼︎",@"▶︎",@"●"]];
  }
  return _validShapes;
}

+ (NSSet<UIColor *> *)validColors {
  if(!_validColors) {
    _validColors = [[NSSet alloc] initWithArray: @[[UIColor redColor], [UIColor greenColor],
       [UIColor purpleColor]]];
  }
  return _validColors;
}

- (int)match:(NSArray *)otherCards {
   return [self matchCards:otherCards byPredicate:self.shapeMatchPredicate] &&
     [self matchCards:otherCards byPredicate:self.shadeMatchPredicate] &&
     [self matchCards:otherCards byPredicate:self.numberMatchPredicate] &&
     [self matchCards:otherCards byPredicate:self.colorMatchPredicate] ? 1 :0;
}

-(NSPredicate *)shapeMatchPredicate {
  if(!_shapeMatchPredicate)
  {
    _shapeMatchPredicate = [NSPredicate predicateWithFormat:@"shape matches '%@'", self.shape];
  }
  return _shadeMatchPredicate;
}

-(NSPredicate *)shadeMatchPredicate {
  if(!_shadeMatchPredicate)
  {
    _shadeMatchPredicate = [NSPredicate predicateWithFormat:@"shade == %ld", (NSInteger)self.shade];
  }
  return  _shadeMatchPredicate;
}

-(NSPredicate *)numberMatchPredicate {
  if(!_numberMatchPredicate)
  {
    _numberMatchPredicate = [NSPredicate predicateWithFormat:@"number == %ld",
        (NSInteger)self.number];
  }
  return  _numberMatchPredicate;
}

-(NSPredicate *)colorMatchPredicate {
  if(!_colorMatchPredicate)
  {
    _colorMatchPredicate = [NSPredicate predicateWithFormat:@"color == %@", self.color];
  }
  return  _shadeMatchPredicate;
}
    
- (BOOL)matchCards:(NSArray *)cards byPredicate:(NSPredicate *) predicate{
  NSArray *filteredArray = [cards filteredArrayUsingPredicate:predicate];
  return filteredArray.count == 0 || filteredArray.count == cards.count;
}

@end

NS_ASSUME_NONNULL_END

//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Temp User on 05/12/2017.
//  Copyright © 2017 Temp User. All rights reserved.
//

#import "CalculatorBrain.h"
@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (class, nonatomic, strong, readonly) NSSet *twoOperandOperations;
@property (class, nonatomic, strong, readonly) NSSet *oneOperandOperations;
@property (class, nonatomic, strong, readonly) NSSet *noOperandOperations;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

+ (NSSet *) twoOperandOperations
{
    static NSSet *_twoOperandOperations = nil;
    if(_twoOperandOperations == nil)
    {
        _twoOperandOperations = [[NSSet alloc] initWithObjects:@"+", @"-", @"/", @"*", nil];
    }
    return _twoOperandOperations;
}

+ (NSSet *) oneOperandOperations
{
    static NSSet *_oneOperandOperations = nil;
    if(_oneOperandOperations == nil)
    {
        _oneOperandOperations = [[NSSet alloc] initWithObjects:@"sin", @"cos", @"sqrt", nil];
    }
    return _oneOperandOperations;
}

+ (NSSet *) noOperandOperations
{
    static NSSet *_noOperandOperations = nil;
    if(_noOperandOperations == nil)
    {
        _noOperandOperations = [[NSSet alloc] initWithObjects:@"𝞹", nil];
    }
    return _noOperandOperations;
}

+ (BOOL) isOperation:(NSString *)operation
{
    return [CalculatorBrain.noOperandOperations containsObject:operation]
    || [CalculatorBrain.oneOperandOperations containsObject:operation]
    || [CalculatorBrain.twoOperandOperations containsObject:operation];
}

+ (NSSet *) variablesUsedInProgram:(id) program{
    NSMutableSet *variablesSet = [[NSMutableSet alloc] init];
    for (id var in program) {
        if([var isKindOfClass:[NSString class]] && ![CalculatorBrain isOperation:var])
        {
            [variablesSet addObject:var];
        }
    }
    return [variablesSet copy];
}

- (NSMutableArray *) programStack {
    if(_programStack == nil)
    {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id) program{
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject: [NSNumber numberWithDouble: operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject: variable];
}

+ (double) popOperandOffStack:(NSMutableArray*) stack usingVariableValues:(NSDictionary *) variableValues {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] + [self popOperandOffStack:stack usingVariableValues:variableValues];
        } else if ([@"*" isEqualToString:operation])
        {
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] * [self popOperandOffStack:stack usingVariableValues:variableValues];
        } else if ([@"-" isEqualToString:operation])
        {
            result = - [self popOperandOffStack:stack usingVariableValues:variableValues] + [self popOperandOffStack:stack usingVariableValues:variableValues];
        } else if ([@"/" isEqualToString:operation])
        {
            double firstOperand = [self popOperandOffStack:stack usingVariableValues:variableValues];
            double secondOperand = [self popOperandOffStack:stack usingVariableValues:variableValues];
            if(secondOperand)
            {
                result = secondOperand / firstOperand;
            } else {
                result = 0;
            }
        } else if ([@"sin" isEqualToString:operation]) {
            result = sin([self popOperandOffStack:stack usingVariableValues:variableValues]);
        } else if ([@"cos" isEqualToString:operation]) {
            result = cos([self popOperandOffStack:stack usingVariableValues:variableValues]);
        } else if ([@"sqrt" isEqualToString:operation]) {
            result = sqrt([self popOperandOffStack:stack usingVariableValues:variableValues]);
        } else if ([@"𝞹" isEqualToString:operation]) {
            result = M_PI;
        } else { //handle variables
            NSNumber *variableValue = [variableValues valueForKey: operation];
            if (variableValue) {
                result = [variableValue doubleValue];
            } else {
                result = 0;
            }
        }
    }
    return result;
}

+ (double) runProgram:(id) program{
    return [CalculatorBrain runProgram:program usingVariableValues: nil];
}

+ (double) runProgram:(id) program usingVariableValues:(NSDictionary *) variableValues
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack usingVariableValues:variableValues];
}

+ (NSString *) descriptionOfProgram:(id) program{
    NSMutableArray *currentProgram;
    if([program isKindOfClass:[NSArray class]])
    {
        currentProgram = [program mutableCopy];
    }
    NSMutableArray *descriptionParts = [[NSMutableArray alloc] init];
    while ([currentProgram count] > 0) {
        NSString *result = [CalculatorBrain describeProgram:currentProgram];
        if([result characterAtIndex:0] == '(')
        {
            result = [result substringWithRange:NSMakeRange(1, result.length - 2)];
        }
        [descriptionParts addObject:result];
    }
    
    return [descriptionParts componentsJoinedByString:@", " ];
}
    

+ (NSString *) describeProgram:(NSMutableArray *) program
{
    NSString *result = @"0";
    id topOfStack = [program lastObject];
    if(topOfStack) [program removeLastObject];
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [NSString stringWithFormat:@"%g", [topOfStack doubleValue]];
    } else if ([topOfStack isKindOfClass:[NSString class]])
    {
        if([CalculatorBrain isOperation:topOfStack] == NO)
        {
            result = topOfStack;
        } else if([CalculatorBrain.oneOperandOperations containsObject:topOfStack])
        {
            NSString *currentProgram = [self describeProgram:program];
            if([currentProgram characterAtIndex:0] != '(')
            {
                currentProgram = [NSString stringWithFormat:@"(%@)", currentProgram];
            }
            result = [NSString stringWithFormat:@"%@%@", topOfStack, currentProgram];
        } else if ([CalculatorBrain.noOperandOperations containsObject:topOfStack])
        {
            result = topOfStack;
        } else {
            NSString *secondArg = [self describeProgram:program];
            NSString *firstArg = [self describeProgram:program];
            result = [NSString stringWithFormat:@"(%@ %@ %@)", firstArg, topOfStack, secondArg];
        }
    }
    return result;
}

- (void) clearProgram {
    [self.programStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation usingVariableValues:(NSDictionary *) variableValues{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram: self.program usingVariableValues:variableValues];
}

- (double) recalculateProgramUsingVariableValues:(NSDictionary *) variableValues {
     return [CalculatorBrain runProgram: self.program usingVariableValues:variableValues];
}

@end

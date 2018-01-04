//
//  ViewController.m
//  Calculator
//
//  Created by Temp User on 04/12/2017.
//  Copyright © 2017 Temp User. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *calculatorBrain;
@property (nonatomic, strong) NSMutableDictionary *testVariableValues;
@end

@implementation ViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize calculatorBrain = _calculatorBrain;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize testVariableValues = _testVariableValues;

- (NSMutableDictionary *) testVariableValues{
    if(!_testVariableValues)
    {
        _testVariableValues = [[NSMutableDictionary alloc] init];
    }
    return _testVariableValues;
}
- (CalculatorBrain *) calculatorBrain {
    if(!_calculatorBrain)
    {
        _calculatorBrain = [[CalculatorBrain alloc] init];
    }
    return _calculatorBrain;
}

-(void) updateHistory {
    NSString *newHistory = [CalculatorBrain descriptionOfProgram:self.calculatorBrain.program];
    if(newHistory.length > 50)
    {
        newHistory = [newHistory substringFromIndex:newHistory.length - 50];
    }
    self.history.text = newHistory;
}



- (IBAction)digPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if ([self.display.text isEqualToString:(@"0")] || !self.userIsInTheMiddleOfEnteringANumber) {
        if([digit isEqualToString:@"."]){
            self.display.text = @"0.";
        } else{
            self.display.text =  digit;
        }
        
        self.userIsInTheMiddleOfEnteringANumber = YES;
    } else {
        NSString *currentString = self.display.text;
        if([digit isEqualToString:@"."] == NO || [currentString rangeOfString:@"."].location == NSNotFound) {
            self.display.text =  [self.display.text stringByAppendingString:(digit)];
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.calculatorBrain performOperation: sender.currentTitle usingVariableValues: self.testVariableValues];
    NSString * stringResult = [NSString stringWithFormat:@"%g", result];
    [self updateHistory];
    self.display.text = stringResult;
}

- (IBAction)enterPressed {
    [self.calculatorBrain pushOperand: [self.display.text doubleValue]];
    [self updateHistory];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self.calculatorBrain pushVariable: sender.currentTitle];
    [self updateHistory];
    [self setVariblesDisplay];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)setTestVariablesPressed:(UIButton *) sender {
    [self.testVariableValues removeAllObjects];
    if([sender.currentTitle isEqualToString:@"Test1"])
    {
        [self.testVariableValues setObject:[NSNumber numberWithDouble:1] forKey:@"x"];
        [self.testVariableValues  setObject:[NSNumber numberWithDouble:0.5] forKey:@"a"];
    }
    if([sender.currentTitle isEqualToString:@"Test2"])
    {
        [self.testVariableValues  setObject:[NSNumber numberWithDouble:6] forKey:@"x"];
        [self.testVariableValues  setObject:[NSNumber numberWithDouble:50] forKey:@"a"];
        [self.testVariableValues  setObject:[NSNumber numberWithDouble:1.8] forKey:@"b"];
    }
    if([sender.currentTitle isEqualToString:@"Test3"])
    {
        [self.testVariableValues  setObject:[NSNumber numberWithDouble:3] forKey:@"x"];
        [self.testVariableValues  setObject:[NSNumber numberWithDouble:0] forKey:@"a"];
        [self.testVariableValues  setObject:[NSNumber numberWithDouble:-5] forKey:@"b"];
    }
    [self setVariblesDisplay];
    self.display.text = [NSString stringWithFormat:@"%g", [self.calculatorBrain recalculateProgramUsingVariableValues:[self.testVariableValues copy]]];
}

- (void) setVariblesDisplay{
    NSString *newDisplayValue = @"";
    NSNumber *varValue;
    for (id key in [CalculatorBrain variablesUsedInProgram:self.calculatorBrain.program]) {
        varValue = [self.testVariableValues objectForKey:key];
        if(!varValue) varValue = [NSNumber numberWithDouble:0];
        newDisplayValue = [NSString stringWithFormat:@"%@ %@=%@", newDisplayValue, key, varValue];
    }
    self.variblesDisplay.text = newDisplayValue;
}

- (IBAction)clearPressed {
    [self.calculatorBrain clearProgram];
    self.display.text = @"0";
    self.history.text = @"";
}

@end

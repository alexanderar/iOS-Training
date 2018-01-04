//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Temp User on 05/12/2017.
//  Copyright © 2017 Temp User. All rights reserved.
//

@interface CalculatorBrain : NSObject
-(void) pushOperand:(double) operand;
-(void) pushVariable:(NSString *) variable;
-(double) performOperation:(NSString *) operation usingVariableValues:(NSDictionary *) variableValues;
-(double) recalculateProgramUsingVariableValues:(NSDictionary *) variableValues;
-(void) clearProgram;

@property (readonly) id program;
+ (double) runProgram:(id) program;
+ (double) runProgram:(id) program usingVariableValues:(NSDictionary *) variableValues;
+ (NSString *) descriptionOfProgram:(id) program;
+ (NSSet *) variablesUsedInProgram:(id) program;
@end

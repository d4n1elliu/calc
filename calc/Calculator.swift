//
//  Calculator.swift
//  calc
//
//  Created by Daniel Liu on 09/03/2026
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

enum CalculatorError: Error {
    case invalidOperator
    case invalidInteger
    case divisionByZero
    case invalidExpression
    case integerOverflow
}

class Calculator {
    
    /// Storing immediate results after evaluating a certain expression
    /// E.g: for "3 + 2 - 5"
    /// Current result will become final
    ///    start --> 3
    ///    after +5 --> 8
    ///    after -2 --> 6
    /// For multi-step calculation, it's helpful to persist existing result
    var currentResult = 0;
    
    /// Perform Addition
    ///
    /// - Author: Jacktator
    /// - Parameters:
    ///   - no1: First number
    ///   - no2: Second number
    /// - Returns: The addition result
    ///
    /// - Warning: The result may yield Int overflow.
    /// - SeeAlso: https://developer.apple.com/documentation/swift/int/2884663-addingreportingoverflow
    
    /// Basic Arithmetic Functions - Helper function
    /// TODO
    /// Add addingReportingOverflow(...) to maintain overflow safe versions
    func add(no1: Int, no2: Int) -> Int {
        return no1 + no2;
    }
    
    /// MAIN FUNCTION for calc
    /// Role:
    /// 1. Validate command line parsing
    /// 2. Parse numbers and operators
    /// 3. Apply precedence rules
    /// 4. Perform arithmetic safely
    /// 5. Return the final result as a string
    ///
    /// MAIN FUNCTION
    func calculate(args: [String]) -> String {
        
        /// Main function
        
        if args.isEmpty {
            return "ERROR: No expression provided."
        }
        
        if args.count % 2 == 0 {
            return "ERROR: Expression must contain an odd number of tokens."
        }
        
        do {
            let result = try evaluate(args)
            return String(result)
        } catch CalculatorError.invalidOperator {
            return "ERROR: Invalid operator."
        } catch CalculatorError.invalidInteger {
            return "ERROR: Invalid integer."
        } catch CalculatorError.divisionByZero {
            return "ERROR: Division by zero."
        } catch CalculatorError.integerOverflow {
            return "ERROR: Integer overflow."
        } catch {
            return "ERROR: Invalid expression."
        }
    }
    
    // Parsing Integer checks
    
    func parsingInteger(_ token: String) throws -> Int {
        guard let number = Int(token) else {
            throw CalculatorError.invalidInteger
        }
        return number
    }
    
    /// FUNCTION TWO EVALUATE
    /// Parsing expressions into numbers & operators
    func evaluate(_ args: [String]) throws -> Int {
        let firstNumber = try parsingInteger(args[0])
        
        let checkfirstNumber = try outOfBoundsCheck(firstNumber)
        
        var numbers : [Int] = [checkfirstNumber]
        var operators : [String] = []
        
        for i in stride(from:1, to: args.count, by: 2) {
            let ops = args[i]
            let numberToken = args[i + 1]
            
            guard isOperator(ops) else {
                throw CalculatorError.invalidOperator
            }
            
            let number = try parsingInteger(numberToken)
            
            operators.append(ops)
            numbers.append(number)
        }
        return try evaluatePrecendene(numbers, operators)
    }
    
    
    /// EVALUATE WITH PRECEDECE
    ///
    /// First check from left to right to scan for multiplication *, division /, modulus %
    func evaluatePrecendene(_ numbers: [Int], _ operators: [String]) throws -> Int {
        var num = numbers
        var ops = operators
        var i = 0
        
        while i < ops.count {
            if ops[i] == "x" || ops[i] == "/" || ops[i] == "%" {
                let scanPrecendence = try operatorHandling(ops[i], left: num[i], right: num[i + 1])
                let checkResults = try outOfBoundsCheck(scanPrecendence)
                
                num[i] = checkResults
                num.remove(at: i + 1)
                ops.remove(at: i)
            } else {
                i += 1
            }
        }
            /// Second check for +, -
        var finalResult = num[0]
        for  i in 0..<ops.count {
            let result = try operatorHandling(ops[i], left: finalResult, right: num[i + 1])
            finalResult = try outOfBoundsCheck(result)
        }
        return finalResult
    }
        
    /// Returning token for the matching operator
    
    func isOperator(_ token: String) -> Bool {
        return token == "+" || token == "-" || token == "x" || token == "/" || token == "%"
    }
        
    ///  Operator Precedence handling logic
    func operatorHandling(_ operatorSymbol: String, left: Int, right: Int) throws -> Int {
        switch operatorSymbol {
        case "+":
            let (result, overflow) = left.addingReportingOverflow(right)
            if overflow { throw CalculatorError.integerOverflow }
            return result
        case "-":
            let (result, overflow) = left.subtractingReportingOverflow(right)
            if overflow { throw CalculatorError.integerOverflow }
            return result
        case "x":
            let (result, overflow) = left.multipliedReportingOverflow(by: right)
            if overflow { throw CalculatorError.integerOverflow }
            return result
        case "/":
            guard right != 0 else { throw CalculatorError.divisionByZero }
            if left == Int.min && right == -1 {
                throw CalculatorError.integerOverflow
            }
            return left / right
        case "%":
            guard right != 0 else { throw CalculatorError.divisionByZero }
            return left % right
        default:
            throw CalculatorError.invalidOperator
        }
    }
        
    /// Out of bounds checks
    func outOfBoundsCheck(_ value : Int) throws -> Int {
            
        let minInteger = Int.min
        let maxInteger = Int.max
        if value < minInteger || value > maxInteger {
            throw CalculatorError.integerOverflow
        }
        return value
    }
}

//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program

// Retrieve User Input
//let no1 = args[0]; // Sample Code Only! Update Required!
//let operator = args[1]; // Sample Code Only! Update Required!
//let no2 = args[2]; // Sample Code Only! Update Required!

// Initialize a Calculator object
let calculator = Calculator();

// Calculate the result
let result = calculator.add(no1: 1, no2: 1);

// BODMAS (Multiplication first, then add and sub)


//print(result)
//print(1 - 2)
//print(4 + -10)
//print(20 / 3)
//print(5 + 20 * 3)
print(-5 / +2)
print(+2 - -2)
print(2 + 4 * 3 - 6)

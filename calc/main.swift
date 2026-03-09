//
//  main.swift
//  calc
//
//  Created by Daniel Liu on 08/03/2026.
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
let result = calculator.calculate(args: args);

if result.hasPrefix("ERROR:") {
    fputs(result + "\n", stderr)
    exit(1)
} else {
    print(result)
    exit(0)
}

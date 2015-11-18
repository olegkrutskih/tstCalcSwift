//
//  CalculatorBrain.swift
//  tstCalc
//
//  Created by Круцких Олег on 13.11.15.
//  Copyright © 2015 Круцких Олег. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    // Variables
    
    enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    var opStack = [Op] ()
    
    var knownOps = [String : Op] ()
    
    // initialize
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        //knownOps["×"] = Op.BinaryOperation("×") {$0 * $1}
    }
    
    // methods
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
    
    
    
    
}
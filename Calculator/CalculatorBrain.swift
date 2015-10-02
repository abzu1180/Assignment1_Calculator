//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by MARITZA ABZUN on 10/1/15.
//  Copyright © 2015 MARITZA ABZUN. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    var opStack = [Op]()
    var knownOps = [String:Op]()
    
    init() { // constructor of this class
        knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+") { $0 + $1 }
        knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin",  
        // make the rest for the other operations pi, sin, cos, tan
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops // makes a copy and since var its mutable
            let op = remainingOps.removeLast() // arrays are structs in swift, structs are pass by value, classes are pass by reference
            switch op {
            case .Operand(let operand):
                return  (operand, remainingOps)
            case .UnaryOperation(_, let operation):// _ is "idc about this"
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return(nil, ops)
    }
    
    func evaluate() -> Double? { //the question mark allows us not to return double, nil is returned
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    func clearStack() {
        opStack.removeAll()
    }
}

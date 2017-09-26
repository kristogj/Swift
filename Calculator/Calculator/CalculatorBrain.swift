//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kristoffer  Gjerde on 11.09.2017.
//  Copyright © 2017 Kristoffer Gjerde. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double{
    return op1*op2
}

class CalculatorBrain {
    typealias PropertyList = AnyObject
    private var accumulator = 0.0
    private var internalProgram = [PropertyList]()
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand as PropertyList)
    }
    
    //Dictionary for å vise hva vi skal gjøre med de forskjellige operandene.
    private var operations: Dictionary<String,Operation> = [
    "π": Operation.Constant(Double.pi), //Double.pi,
    "e": Operation.Constant(M_E),//M_E
    "±": Operation.UnaryOperation({-$0}), //Endrer fortegn
    "√": Operation.UnaryOperation(sqrt), //sqrt
    "cos": Operation.UnaryOperation(cos), //cos
    "×": Operation.BinaryOperation({$0*$1}), //$0 ser på første input
    "÷": Operation.BinaryOperation({$0/$1}),
    "+": Operation.BinaryOperation({$0 + $1}),
    "-": Operation.BinaryOperation({$0 - $1}),
    "=": Operation.Equals
    ]
    
   
    //Dette gjør at vi faktisk kan bruke de forkortelsene ovenfor
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as PropertyList)
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executinPendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals: executinPendingBinaryOperation()
                
            }
        }
        
    }
    private func executinPendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    //Er optional med "?"
    private var pending: PendingBinaryOperationInfo?
    
    //En type klasse, er som enum. Variabler trenger ikke initialiserers
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var program: PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }
                    else if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
            
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
}

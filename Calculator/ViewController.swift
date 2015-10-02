//
//  ViewController.swift
//  Calculator
//
//  Created by MARITZA ABZUN on 9/14/15.
//  Copyright (c) 2015 MARITZA ABZUN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var display: UILabel! // variable declaration UILAbel! is the type
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    var historyStack = ""
    
    //
    @IBAction func appendDigit(sender: UIButton) /* -> return type*/ {  //method declaration
        
        let digit =  sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
            
        }
        //println("digit = \(digit)")
    }

    //
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clearStack() // FIX
        display.text = "0"
        enter()
    }
    
    var decimalIsPressed = false;
    @IBAction func decimal() {
        userIsInTheMiddleOfTypingANumber = true
        if decimalIsPressed == false {
            display.text = display.text! + "."
            decimalIsPressed = true
        }
    }
    //
    @IBAction func enter() {
        
        userIsInTheMiddleOfTypingANumber = false
        decimalIsPressed = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
        history.text = "\(displayValue)"
        
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}


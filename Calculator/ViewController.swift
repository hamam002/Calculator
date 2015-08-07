//
//  ViewController.swift
//  Calculator
//
//  Created by Evan Hamamoto on 7/5/15.
//  Copyright (c) 2015 Evan Hamamoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        display.text = "0"
        //sets the display text to 0 when the app opens
    }
    
    var isInMiddleOfTyping = false
    //boolean that is used to determine if the user is currently still typing a number into the calculator

    @IBOutlet weak var display: UILabel!
    //label at the top of the app that shows the numbers and results of calculations
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(isInMiddleOfTyping){
            display.text = display.text! + "\(digit)"
            //adds the string of the button pressed to the display if the user is in the middle of typing
        }
        
        else{
            display.text = digit
            isInMiddleOfTyping = true
            //sets the display to the string of the button pressed if the user is not in the middle of typing
        }
    }
    
    @IBAction func addPiToOperandStack(sender: UIButton) {
        let pi: String = "\(M_PI)"
        //creates a string to represent the double pi
        let digit = pi.substringToIndex(advance(pi.startIndex, 5))
        //sets digit to pi, but trims it to 5 characters
        display.text = digit
        //sets the display to pi trimmed to 5 characters
        isInMiddleOfTyping = false
    }
    
    var operandStack = Array<Double>()
    //array of doubles that holds the values of the numbers entered into the calculator
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            //takes the string and converts it to a double
        }
        
        set{
            display.text = "\(newValue)"
            isInMiddleOfTyping = false
        }
    }
    
    @IBAction func enter() {
        isInMiddleOfTyping = false
        //sets isInMiddleOfTyping to false
        operandStack.append(displayValue)
        //adds the value of the number in the display to operandStack
        println("Operand Stack = \(operandStack)")
        //prints the operandStack to the console
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        //determines which button was pressed to identify which operation to use
        if(isInMiddleOfTyping){
            enter()
            //if the user is in the middle of typing, then run the enter() function
        }
        
        switch operation{
        case "×":
            performOperation {$0 * $1}
            //multiplies the last two numbers in operandStack
        case "÷":
            performOperation {$1 / $0}
            //divides the second to last number by the last number in operandStack
        case "+":
            performOperation {$0 + $1}
            //adds the last two numbers in operandStack
        case "−":
            performOperation {$1 - $0}
            //subtracts the last number from the second to last number in operandStack
        case "√":
            performOperation {sqrt($0)}
            //takes the squareroot of the last number in operandStack
        case "x²":
            performOperation {pow($0, 2)}
            //takes the second to last number in operandStack to the second power
        case "^":
            performOperation {pow($1, $0)}
            //takes the second to last number in operandStack to the power of the last number
        case "sin()":
            performOperation {sin($0)}
            //takes the sin of the last number in operandStack
        case "cos()":
            performOperation {cos($0)}
            //takes the sin of the last number in operandStack
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double){
        if(operandStack.count >= 2){
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            //takes the last two numbers off operandStack to use in an operation function that uses two numbers
            enter()
            //after the operation is complete, run the enter() function
        }
    }
    
    private func performOperation(operation: Double -> Double){
        if(operandStack.count >= 1){
            displayValue = operation(operandStack.removeLast())
            //takes the last number off operandStack to use in an operation function that uses one number
            enter()
            //after the operation is complete, run the enter() function
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        operandStack.removeAll(keepCapacity: false)
        //removes all of the doubles from operandStack
        isInMiddleOfTyping = false
        display.text = "0"
        //resets the display to 0 and sets isInMiddleOfTyping to false
        println("Operand Stack = \(operandStack)")
        //prints the operandStack to the console
    }
    
}


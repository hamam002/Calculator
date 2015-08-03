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
    }
    
    var isInMiddleOfTyping = false

    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(isInMiddleOfTyping == true){
            display.text = display.text! + "\(digit)"
        }
        
        else{
            display.text = digit
            isInMiddleOfTyping = true
        }
    }
    
    var operandStack = Array<Double>()
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set{
            display.text = "\(newValue)"
            isInMiddleOfTyping = false
        }
    }
    
    @IBAction func enter() {
        isInMiddleOfTyping = false
        operandStack.append(displayValue)
        println("Operand Stack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if(isInMiddleOfTyping){
            enter()
        }
        
        switch operation{
        case "×":
            performOperation {$0 * $1}
        case "÷":
            performOperation {$1 / $0}
        case "+":
            performOperation {$0 + $1}
        case "−":
            performOperation {$1 - $0}
        case "√":
            performOperation {sqrt($0)}
        case "^":
            performOperation {pow($1, $0)}
        case "sin":
            performOperation {sin($0)}
        case "cos":
            performOperation {cos($0)}
        
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double){
        if(operandStack.count >= 2){
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double){
        if(operandStack.count >= 1){
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        operandStack.removeAll(keepCapacity: false)
        isInMiddleOfTyping = false
        display.text = "0"
        println("Operand Stack = \(operandStack)")
    }
    
}


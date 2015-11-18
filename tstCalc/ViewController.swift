//
//  ViewController.swift
//  tstCalc
//
//  Created by Круцких Олег on 11.11.15.
//  Copyright © 2015 Круцких Олег. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var operandStack = Array <Double>()
    var DisplayValue: Double? {
        get {
            if let displayText = Display.text {
                return numberFormatter().numberFromString(displayText)?.doubleValue
            }
            return nil
        }
        set {
            if (newValue != nil) {
                Display.text = numberFormatter().stringFromNumber(newValue!)
            } else {
                Display.text = " "
                history.text = history.text! + " Error"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    let decimalSeparator = NSNumberFormatter().decimalSeparator ?? "."
    
    @IBOutlet weak var Display: UILabel!
    @IBOutlet weak var Dot: UIButton! {
        didSet {
            Dot.setTitle(decimalSeparator, forState: UIControlState.Normal)
        }
    }
    @IBOutlet weak var history: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            
            // не допускаем лишних точек
            if (digit == decimalSeparator) && (Display.text?.rangeOfString(decimalSeparator) != nil) {
                return
            }
            // не допускаем лидирующих нулей
            if (digit == "0") && ((Display.text == "0") || (Display.text == "-0")) {
                return
            }
            if (digit != decimalSeparator) && ((Display.text == "0") || (Display.text == "-0")) {
                Display.text = digit
                return
            }
            
            Display.text = Display.text! + digit
        }
        else {
            Display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }

        
        
    }

    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            addHistory(Display.text!)
        }
        userIsInTheMiddleOfTypingANumber = false
        if let value = DisplayValue {
            operandStack.append(value)
        }
        else {
            DisplayValue = nil
        }
        print("operandStack = \(operandStack)")
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            addHistory(operation + " =")
            switch operation {
            case "×": performOperation {$0 * $1}
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$0 + $1}
            case "-": performOperation {$1 - $0}
            case "√": performOperation(sqrt)
            case "sin": performOperation(sin)
            case "cos": performOperation(cos)
            case "π": performOperation {M_PI}
            case "±": performOperation {-$0}
            default: break
        }
        }
    }
    
    @IBAction func clearAll(sender: UIButton) {
        history.text = " "
        operandStack.removeAll()
        DisplayValue = nil
    }
    
    @IBAction func back() {
        if userIsInTheMiddleOfTypingANumber {
            if (Display.text!).characters.count > 1 {
                Display.text = String((Display.text!).characters.dropLast())
            } else {
                Display.text = "0"
            }
        }
    }
    
    @IBAction func plusMinus(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if (Display.text!.rangeOfString("-") != nil) {
                Display.text = String((Display.text!).characters.dropFirst())
            } else {
                Display.text = "-" + Display.text!
            }
        } else {
            operate(sender)
        }
    }
    
    @nonobjc func performOperation(operation: () -> Double){
        if operandStack.count >= 1 {
            DisplayValue = operation()
            enter()
        } else {
            DisplayValue = nil
        }
    }
    @nonobjc func performOperation(operation: Double -> Double){
        if operandStack.count >= 1 {
            DisplayValue = operation(operandStack.removeLast())
            enter()
        } else {
            DisplayValue = nil
        }
    }
    @nonobjc func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            DisplayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        } else {
            DisplayValue = nil
        }
    }
    func addHistory(text: String){
        history.text = (history.text?.rangeOfString("=") != nil) ? ((history.text!).stringByReplacingOccurrencesOfString("=", withString: "")) : (history.text)
        history.text = (history.text?.rangeOfString("Error") != nil) ? ((history.text!).stringByReplacingOccurrencesOfString("Error", withString: "")) : (history.text)
        history.text = history.text! + " " + text
    }
   
    func numberFormatter () -> NSNumberFormatter {
        let numberFormatterLoc = NSNumberFormatter()
        numberFormatterLoc.numberStyle = .DecimalStyle
        numberFormatterLoc.maximumFractionDigits = 10
        numberFormatterLoc.notANumberSymbol = "Error"
        numberFormatterLoc.groupingSeparator = " "
        return numberFormatterLoc
    }
}


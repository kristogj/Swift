//
//  ViewController.swift
//  Calculator
//
//  Created by Kristoffer  Gjerde on 11.09.2017.
//  Copyright © 2017 Kristoffer Gjerde. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Displayet
    @IBOutlet private weak var display: UILabel!
    
    //Sjekker om man holder på å skrive et stykke
    private var userInTheMiddleOfTyping = false
    
    
    //Action for å trykke på et tall
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! //Verdien til tallet
        if userInTheMiddleOfTyping{ 
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
        }
        userInTheMiddleOfTyping = true
    }
    
    //En måte å ta imot og sende verdier til Display
    //Get for hvordan man vil ta imot
    //Set for hvordan man sender verdi
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    
    //Filen som gjør selve utregningene
    private var brain = CalculatorBrain() //Snakker med modellen
    
    //Action for knapper som ikke er tall, altså operatorer
    @IBAction func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue) //Setter opp verdiene
            userInTheMiddleOfTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathSymbol) //Setter opp operasjonen
        }
        displayValue = brain.result //Setter Displayet til resultatet
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    
    @IBAction func restore(_ sender: Any) {
        if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    
    
    //Bare for å clear
    @IBAction func clear(_ sender: UIButton) {
        display.text = "0"
        brain.setOperand(operand: 0.0)
    }
    
}


//
//  Bank.swift
//  BlackJack
//
//  Created by James Tyner on 3/4/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation

class Bank {
    var balance = 500
    
    init() {
        
   }
    
    func resetBalance(){
        
        balance = 500
    }
    
    func addMoney(amount: Int){
        balance += amount
    }
    
    func subtractMoney(amount: Int){
        balance -= amount
        if(balance <= 10){
            resetBalance()
        }
    }
    
    func getBalance()->Int{
        return balance
    }
  }

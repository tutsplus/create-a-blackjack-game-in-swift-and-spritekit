//
//  Pot.swift
//  BlackJack
//
//  Created by James Tyner on 3/8/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

class Pot {
    private var pot = 0

    func addMoney(amount: Int){
        pot += amount
    }
    
    func getMoney()->Int{
        return pot
    }
    
    func reset(){
        pot = 0
    }

    
}

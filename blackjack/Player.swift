//
//  Player.swift
//  BlackJack
//
//  Created by James Tyner on 3/8/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation

class Player : GenericPlayer{
   var bank:Bank
   private var yields = false
   private var canBet = false
    
    init(hand: Hand, bank: Bank) {
        self.bank = bank
        super.init(hand: hand)
    }
    
    func setYielding(yields: Bool){
        self.yields = yields
    }
    
    func isYeilding()-> Bool{
        return yields
    }
    
    func setCanBet(canBet: Bool){
        self.canBet = canBet
    }
    
    func getCanBet()-> Bool{
        return canBet
    }
}

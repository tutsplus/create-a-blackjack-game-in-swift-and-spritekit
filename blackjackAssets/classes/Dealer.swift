//
//  Dealer.swift
//  BlackJack
//
//  Created by James Tyner on 3/15/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation

class Dealer: GenericPlayer{
   private var firstCard = Card(suit: "card_front",value: 0)
    
    override init(hand: Hand) {
       super.init(hand: hand)
    }
    
    func setFirstCard(card: Card){
        firstCard = card
    }
    
    func getFirstCard()->Card{
        return firstCard
    }
}

//
//  Deck.swift
//  BlackJack
//
//  Created by James Tyner on 3/4/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation

class Deck {
    private var deck = [Card]()
    private var deckIndex = -1
    init() {
       create()
    }
    
    func create(){
        let suits = ["d","h","s","c"]
        for cardSuit in suits {
            for cardValue in 1...13 {
              let tempCard = Card(suit: cardSuit, value: cardValue)
              deck.append(tempCard)
            }
        }
    }
    
    
    func getTopCard()->Card{
        deckIndex += 1
        return deck[deckIndex]
    }
    
    func shuffle(){
        deck.shuffle()
    }
    
    func new(){
        deckIndex = -1
        shuffle()
    }
    
    
    
 
}

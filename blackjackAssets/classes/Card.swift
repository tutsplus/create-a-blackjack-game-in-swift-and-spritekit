//
//  Card.swift
//  BlackJack
//
//  Created by James Tyner on 3/4/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation
import SpriteKit


class Card:SKSpriteNode {
   private var suit:String = ""
   private var value:Int = 0
    init(suit: String, value: Int) {
        self.suit = suit
        self.value = value
        let texture = SKTexture(imageNamed: suit + String(value))
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    func getValue()->Int{
        return value
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}

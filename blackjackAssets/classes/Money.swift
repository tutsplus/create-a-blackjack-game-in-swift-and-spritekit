//
//  Money.swift
//  BlackJack
//
//  Created by James Tyner on 3/4/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation
import SpriteKit

class Money:SKSpriteNode {
    private var moneyValue = MoneyValue.ten
    init(moneyValue: MoneyValue) {
        var texture:SKTexture
        self.moneyValue = moneyValue
        switch moneyValue {
        case .ten:
            texture = SKTexture(imageNamed: "money10")
        case .twentyFive:
            texture = SKTexture(imageNamed: "money25")
        case .fifty:
            texture = SKTexture(imageNamed: "money50")
        }
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "money"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getValue()->MoneyValue{
        return moneyValue
    }


}

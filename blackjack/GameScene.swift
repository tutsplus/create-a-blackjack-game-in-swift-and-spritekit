//
//  GameScene.swift
//  blackjack
//
//  Created by James Tyner on 3/22/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let moneyContainer = SKSpriteNode(color: .clear, size: CGSize(width:250, height: 150))
    let dealBtn = SKSpriteNode(imageNamed: "deal_btn")
    let hitBtn = SKSpriteNode(imageNamed: "hit_btn")
    let standBtn = SKSpriteNode(imageNamed: "stand_btn")
    let money10 = Money(moneyValue: .ten)
    let money25 = Money(moneyValue: .twentyFive)
    let money50 = Money(moneyValue: .fifty)
    let instructionText = SKLabelNode(text: "Place your bet")
    let pot = Pot()
    let player1 = Player(hand: Hand(),bank: Bank())
    let dealer = Dealer(hand: Hand())
    var allCards = [Card]()
    let dealerCardsY = 930 // Y position of dealer cards
    let playerCardsY = 200 // Y position of player cards
    var currentPlayerType:GenericPlayer = Player(hand: Hand(),bank: Bank())
    var playerYields = false
    let deck = Deck()
    override func didMove(to view: SKView) {
        setupTable()
        setupMoney()
        setupButtons()
        currentPlayerType = player1
    }
    
    
    
    func setupTable(){
        let table = SKSpriteNode(imageNamed: "table")
        addChild(table)
        table.position = CGPoint(x: size.width/2, y: size.height/2)
        table.zPosition = -1
        addChild(moneyContainer)
        moneyContainer.anchorPoint = CGPoint(x:0, y:0)
        moneyContainer.position = CGPoint(x:size.width/2 - 125, y:size.height/2)
        instructionText.fontColor = UIColor.black
        addChild(instructionText)
        instructionText.position = CGPoint(x: size.width/2, y: 400)
        deck.new()
    }
    
    func setupMoney(){
        addChild(money10)
        money10.position = CGPoint(x: 75, y: 40)
        
        addChild(money25)
        money25.position = CGPoint(x:130, y:40)
        
        addChild(money50)
        money50.position = CGPoint(x: 185, y:40)
    }
    
    func setupButtons(){
        dealBtn.name = "dealBtn"
        addChild(dealBtn)
        dealBtn.position = CGPoint(x:300, y:40)
        
        hitBtn.name = "hitBtn"
        addChild(hitBtn)
        hitBtn.position = CGPoint(x:450, y:40)
        hitBtn.isHidden = true
        
        standBtn.name = "standBtn"
        addChild(standBtn)
        standBtn.position = CGPoint(x:600, y:40)
        standBtn.isHidden = true
    }
    
    func bet(betAmount: MoneyValue ){
        if(betAmount.rawValue > player1.bank.getBalance()){
            print("Trying to bet more than have");
            return
        }else{
            pot.addMoney(amount: betAmount.rawValue)
            let tempMoney = Money(moneyValue: betAmount)
            tempMoney.anchorPoint = CGPoint(x:0, y:0)
            moneyContainer.addChild(tempMoney)
            tempMoney.position = CGPoint(x:CGFloat(arc4random_uniform(UInt32(moneyContainer.size.width - tempMoney.size.width))), y:CGFloat(arc4random_uniform(UInt32(moneyContainer.size.height - tempMoney.size.height))))
            dealBtn.isHidden = false;
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
            
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
            
        if(touchedNode.name == "money"){
            let money = touchedNode as! Money
            bet(betAmount: money.getValue())
        }
        
        if(touchedNode.name == "dealBtn"){
            deal()
        }
        
        if(touchedNode.name == "hitBtn"){
            hit()
        }
        
        if(touchedNode.name == "standBtn"){
            stand()
        }
        
     }
    func deal() {
        instructionText.text = ""
        money10.isHidden = true;
        money25.isHidden = true;
        money50.isHidden = true;
        dealBtn.isHidden = true;
        standBtn.isHidden = false
        hitBtn.isHidden = false
        let tempCard = Card(suit: "card_front", value: 0)
        tempCard.position = CGPoint(x:630, y:980)
        addChild(tempCard)
        tempCard.zPosition = 100
        
        let newCard = deck.getTopCard()
        
        var whichPosition = playerCardsY
        var whichHand = player1.hand
        if(self.currentPlayerType is Player){
            whichHand = player1.hand
            whichPosition = playerCardsY;
        } else {
            whichHand = dealer.hand
            whichPosition = dealerCardsY;
        }
        
        whichHand.addCard(card: newCard)
        let xPos = 50 + (whichHand.getLength()*35)
        let moveCard = SKAction.move(to: CGPoint(x:xPos, y: whichPosition),duration: 1.0)
        tempCard.run(moveCard, completion: { [unowned self] in
            self.player1.setCanBet(canBet: true)
            if(self.currentPlayerType is Dealer && self.dealer.hand.getLength() == 1){
                self.dealer.setFirstCard(card: newCard)
                self.allCards.append(tempCard)
                tempCard.zPosition = 0
            } else {
                tempCard.removeFromParent()
                self.allCards.append(newCard)
                self.addChild(newCard)
                newCard.position = CGPoint( x: xPos, y: whichPosition)
                newCard.zPosition = 100
            }
            if(self.dealer.hand.getLength() < 2){
                if(self.currentPlayerType is Player){
                    self.currentPlayerType = self.dealer
                }else{
                    self.currentPlayerType = self.player1
                }
                self.deal()
            }else if (self.dealer.hand.getLength() == 2 && self.player1.hand.getLength() == 2) {
                if(self.player1.hand.getValue() == 21 || self.dealer.hand.getValue() == 21){
                    self.doGameOver(hasBlackJack: true)
                } else {
                    self.standBtn.isHidden = false;
                    self.hitBtn.isHidden = false;
                }
            }
            
            if(self.dealer.hand.getLength() >= 3 && self.dealer.hand.getValue() < 17){
                self.deal();
            } else if(self.player1.isYeilding() && self.dealer.hand.getValue() >= 17){
                self.standBtn.isHidden = true
                self.hitBtn.isHidden = true
                self.doGameOver(hasBlackJack: false)
            }
            if(self.player1.hand.getValue() > 21){
                self.standBtn.isHidden = true;
                self.hitBtn.isHidden = true;
                self.doGameOver(hasBlackJack: false);
            }
            
            
            
        })
        
    }
    
    func doGameOver(hasBlackJack: Bool){
        hitBtn.isHidden = true
        standBtn.isHidden = true
        let tempCardX = allCards[1].position.x
        let tempCardY = allCards[1].position.y
        let tempCard = dealer.getFirstCard()
        addChild(tempCard)
        allCards.append(tempCard)
        tempCard.position = CGPoint(x:tempCardX,y:tempCardY)
        tempCard.zPosition = 0
        
        var winner:GenericPlayer = player1
        
        if(hasBlackJack){
            if(player1.hand.getValue() > dealer.hand.getValue()){
                //Add to players Bank Here (pot value * 1.5)
                instructionText.text = "You Got BlackJack!";
                moveMoneyContainer(position: playerCardsY)
            }else{
                //Subtract from players bank here
                instructionText.text = "Dealer got BlackJack!";
                moveMoneyContainer(position: dealerCardsY)
            }
            
            return
            
        }
        
        
        if (player1.hand.getValue() > 21){
            instructionText.text = "You Busted!"
            //Subtract from players bank
            winner = dealer
        }else if (dealer.hand.getValue() > 21){
            //Add to players bank
            instructionText.text = "Dealer Busts. You Win!"
            winner = player1
        }else if (dealer.hand.getValue() > player1.hand.getValue()){
            //Subtract from players bank
            instructionText.text = "You Lose!"
            winner = dealer
        } else if (dealer.hand.getValue() == player1.hand.getValue()){
            //Subtract from players bank
            instructionText.text = "Tie - Dealer Wins!"
            winner = dealer
        }else if (dealer.hand.getValue() < player1.hand.getValue()){
            //Add to players bank
            instructionText.text="You Win!";
            winner = player1
        }
        
        if(winner is Player){
            moveMoneyContainer(position: playerCardsY)
        }else{
            moveMoneyContainer(position: dealerCardsY)
        }
        
    }
    
    func moveMoneyContainer(position: Int){
        let moveMoneyContainer = SKAction.moveTo(y: CGFloat(position), duration: 3.0)
        moneyContainer.run(moveMoneyContainer, completion: { [unowned self] in
            self.resetMoneyContainer()
        });
    }
    
    func resetMoneyContainer(){
        //Remove all card from coin container
        moneyContainer.removeAllChildren()
        moneyContainer.position.y = size.height/2
        newGame()
        
    }
    
    func newGame(){
        currentPlayerType = player1
        deck.new()
        instructionText.text = "PLACE YOUR BET";
        money10.isHidden = false;
        money25.isHidden = false;
        money50.isHidden = false;
        dealBtn.isHidden = false
        player1.hand.reset()
        dealer.hand.reset()
        player1.setYielding(yields: false)
        
        for card in allCards{
            card.removeFromParent()
        }
        
        allCards.removeAll()
    }
    
    func hit(){
        if(player1.getCanBet()){
            currentPlayerType = player1
            deal()
            player1.setCanBet(canBet: false)
        }
    }
    
    
    func stand(){
        player1.setYielding(yields: true)
        standBtn.isHidden = true
        hitBtn.isHidden = true
        if(dealer.hand.getValue() < 17){
            currentPlayerType = dealer
            deal();
        }else{
            doGameOver(hasBlackJack: false)
        }
    }
}

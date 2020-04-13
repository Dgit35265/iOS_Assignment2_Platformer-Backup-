//
//  UI.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-12.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit

class GameUI{
    static var MoneyLbl = SKLabelNode()
    static var MoneyIcon = SKSpriteNode(imageNamed: "hud_coins")
    //Keys UI
    static var blueKey = SKSpriteNode(imageNamed: "hud_keyBlue_disabled")
    static var greenKey = SKSpriteNode(imageNamed: "hud_keyGreen_disabled")
    static var redKey = SKSpriteNode(imageNamed: "hud_keyRed_disabled")
    static var yellowKey = SKSpriteNode(imageNamed: "hud_keyYellow_disabled")
    //Health UI
    static var heartIcon = SKSpriteNode()
    //GameComplete UI
    static var gameCompleteLbl = SKLabelNode()
    static var gameResultLbl = SKLabelNode()
    //GameOver UI
    static var gameOverLbl = SKLabelNode()
    static var gameOverTip = SKLabelNode()
    static var gameCompleteTip = SKLabelNode()

    static func setGameUI(scene: SKScene){
        //Money UI
        MoneyIcon.size = CGSize(width: 144, height: 144)
        MoneyIcon.position = CGPoint(x: 2*scene.frame.width/5 - MoneyIcon.size.width, y: 3*scene.frame.height/10 + MoneyIcon.size.height/3)
        MoneyIcon.zPosition = 1
        //
        MoneyLbl.text = String(GameManager.money)
        MoneyLbl.position = CGPoint(x: 2*scene.frame.width/5, y: 3*scene.frame.height/10)
        MoneyLbl.zPosition = 1
        MoneyLbl.fontSize = 144
        MoneyLbl.fontName = "HelveticaNeue-Bold"
        MoneyLbl.fontColor = .yellow
        //Keys UI
        //blue
        blueKey.size = CGSize(width: 144, height: 144)
        blueKey.position = CGPoint(x: -2*scene.frame.width/5, y: 3*scene.frame.height/10 + blueKey.size.height/3)
        blueKey.zPosition = 1
        //green
        greenKey.size = CGSize(width: 144, height: 144)
        greenKey.position = CGPoint(x: -2*scene.frame.width/5 + greenKey.size.width, y: 3*scene.frame.height/10 + greenKey.size.height/3)
        greenKey.zPosition = 1
        //red
        redKey.size = CGSize(width: 144, height: 144)
        redKey.position = CGPoint(x: -2*scene.frame.width/5 + 2*redKey.size.width, y: 3*scene.frame.height/10 + redKey.size.height/3)
        redKey.zPosition = 1
        //yellow
        yellowKey.size = CGSize(width: 144, height: 144)
        yellowKey.position = CGPoint(x: -2*scene.frame.width/5 + 3*yellowKey.size.width, y: 3*scene.frame.height/10 + yellowKey.size.height/3)
        yellowKey.zPosition = 1
        //heart UI
        heartIcon.texture = GameManager.getHeartTexture()
        heartIcon.size = CGSize(width: 144, height: 144)
        heartIcon.position = CGPoint(x: 2*scene.frame.width/5 - 3*heartIcon.size.width, y: 3*scene.frame.height/10 + heartIcon.size.height/3)
        heartIcon.zPosition = 1
        print("Create Game UI")
        setGameOverUI(scene: scene)
    }
    
    static func addGameUI(scene: SKScene){
        scene.addChild(MoneyIcon)
        scene.addChild(MoneyLbl)
        scene.addChild(blueKey)
        scene.addChild(greenKey)
        scene.addChild(redKey)
        scene.addChild(yellowKey)
        scene.addChild(heartIcon)
        print("Add Game UI")
        scene.addChild(gameOverLbl)
        scene.addChild(gameOverTip)
        print("Add Game Over UI (alpha = 0)")
    }
    
    static func removeGameUI(){
        MoneyIcon.removeFromParent()
        MoneyLbl.removeFromParent()
        blueKey.removeFromParent()
        greenKey.removeFromParent()
        redKey.removeFromParent()
        yellowKey.removeFromParent()
        heartIcon.removeFromParent()
        print("Remove Game UI")
    }
    
    static func setGameCompleteUI(scene: SKScene){
        gameCompleteLbl.text = "Game Complete"
        gameCompleteLbl.position = CGPoint(x: 0, y: 3*scene.frame.height/10)
        gameCompleteLbl.zPosition = 1
        gameCompleteLbl.fontSize = 144
        gameCompleteLbl.fontName = "HelveticaNeue-Bold"
        gameCompleteLbl.fontColor = .white
        //
        gameResultLbl.text = "You got \(GameManager.money) gold!"
        gameResultLbl.position = CGPoint(x: 0, y: 0)
        gameResultLbl.zPosition = 1
        gameResultLbl.fontSize = 96
        gameResultLbl.fontName = "HelveticaNeue-Bold"
        gameResultLbl.fontColor = .yellow
        //
        gameCompleteTip.text = "Touch to Replay"
        gameCompleteTip.position = CGPoint(x: 0, y: -3*scene.frame.height/10)
        gameCompleteTip.zPosition = 1
        gameCompleteTip.fontSize = 96
        gameCompleteTip.fontName = "HelveticaNeue-Bold"
        gameCompleteTip.fontColor = .white
        print("Create Game Complete UI")
        //add to scene
        scene.addChild(gameCompleteLbl)
        scene.addChild(gameResultLbl)
        scene.addChild(gameCompleteTip)
        print("Add Game Complete UI")
    }
    
    static func removeGameCompleteUI(){
        gameCompleteLbl.removeFromParent()
        gameResultLbl.removeFromParent()
        gameCompleteTip.removeFromParent()
        print("Remove Game Complete UI")
    }
    
    static func setGameOverUI(scene: SKScene){
        gameOverLbl.text = "Game Over"
        gameOverLbl.position = CGPoint(x: 0, y: 3*scene.frame.height/10)
        gameOverLbl.zPosition = 1
        gameOverLbl.fontSize = 144
        gameOverLbl.fontName = "HelveticaNeue-Bold"
        gameOverLbl.fontColor = .black
        gameOverLbl.alpha = 0
        //
        gameOverTip.text = "Touch to Replay"
        gameOverTip.position = CGPoint(x: 0, y: 0)
        gameOverTip.zPosition = 1
        gameOverTip.fontSize = 96
        gameOverTip.fontName = "HelveticaNeue-Bold"
        gameOverTip.fontColor = .black
        gameOverTip.alpha = 0
        print("Create Game Over UI")
    }

    static func showGameOverUI(){
        gameOverLbl.alpha = 1
        gameOverTip.alpha = 1
        print("Show Game Over UI")
    }
    
    static func removeGameOverUI(){
        gameOverLbl.alpha = 0
        gameOverTip.alpha = 0
        gameOverLbl.removeFromParent()
        gameOverTip.removeFromParent()
        print("Remove Game Over UI")
    }

    static func refreshMoney(){
        MoneyLbl.text = String(GameManager.money)
    }
    static func refreshHealth(){
        heartIcon.texture = GameManager.getHeartTexture()
    }
    //Keys
    static func hasBlueKey(){
        blueKey.texture = SKTexture(imageNamed: "hud_keyBlue")
    }
    static func hasGreenKey(){
        greenKey.texture = SKTexture(imageNamed: "hud_keyGreen")
    }
    static func hasRedKey(){
        redKey.texture = SKTexture(imageNamed: "hud_keyRed")
    }
    static func hasYellowKey(){
        yellowKey.texture = SKTexture(imageNamed: "hud_keyYellow")
    }
    
    static func resetKeyUI(){
        blueKey = SKSpriteNode(imageNamed: "hud_keyBlue_disabled")
        greenKey = SKSpriteNode(imageNamed: "hud_keyGreen_disabled")
        redKey = SKSpriteNode(imageNamed: "hud_keyRed_disabled")
        yellowKey = SKSpriteNode(imageNamed: "hud_keyYellow_disabled")
    }
}

//
//  GameManager.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-11.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit

class GameManager: SKScene{
    
    static var nextScene: SKScene?
    
    static var enemies: [Enemy] = []
    
    static var money = 0
    static var health = 10
    static var heartTexture = SKTexture()
    //Auido & SFX
    static let gameBGM = SKAudioNode(fileNamed: "BGM.wav")
    static let coinSFX = SKAction.playSoundFileNamed("Coin.wav", waitForCompletion: false)
    static let keySFX = SKAction.playSoundFileNamed("Key.wav", waitForCompletion: false)
    static let hurtSFX = SKAction.playSoundFileNamed("Hurt.wav", waitForCompletion: false)
    static let buttonSFX = SKAction.playSoundFileNamed("Button.wav", waitForCompletion: false)
    static let doorSFX = SKAction.playSoundFileNamed("Door.wav", waitForCompletion: false)
    static let slimeDeathSFX = SKAction.playSoundFileNamed("SlimeDeath.wav", waitForCompletion: false)
    
    static var hasBlueKey: Bool = false
    static var hasGreenKey: Bool = false
    static var hasRedKey: Bool = false
    static var hasYellowKey: Bool = false
    
    static var gameStart: Bool = false
    static var gameEnd: Bool = false
    static var gameFailed: Bool = false
    static var nextLevel: Bool = false
    static var waitForTransition: Bool = true
    
    //door and button
    static var upperDoor = SKSpriteNode()
    static var door = SKSpriteNode()
    static var button = SKSpriteNode()
    
    static func resetGameData(){
        money = 0
        health = 10
        hasBlueKey = false
        hasGreenKey = false
        hasRedKey = false
        hasYellowKey = false
        gameStart = false
        gameEnd = false
        gameFailed = false
        waitForTransition = true
    }
    
    static func getCoin(amount: Int, scene: SKScene){
        money += amount
        GameUI.refreshMoney()
        scene.run(coinSFX)
    }
    
    static func getKey(name: String, scene: SKScene){
        switch name {
        case "Blue":
            hasBlueKey = true
            GameUI.hasBlueKey()
        case "Green":
            hasGreenKey = true
            GameUI.hasGreenKey()
        case "Red":
            hasRedKey = true
            GameUI.hasRedKey()
        case "Yellow":
            hasYellowKey = true
            GameUI.hasYellowKey()
        default:
            print("Unrecognized Key...")
        }
        scene.run(keySFX)
    }
    
    static func getHeartTexture()->SKTexture{
        switch health {
        case 10:
            heartTexture = SKTexture(imageNamed: "hud_heartFull")
        case 5:
            heartTexture = SKTexture(imageNamed: "hud_heartHalf")
        case 0:
            heartTexture = SKTexture(imageNamed: "hud_heartEmpty")
        default:
            print("Other health value...")
        }
        return heartTexture
    }
    
    static func getDamage(amount: Int, scene: SKScene){
        health -= amount
        scene.run(hurtSFX)
        GameUI.refreshHealth()
        Player.damaged = true
        Player.hurt()
        if(health <= 0){
            health = 0
            gameOver()
        }
    }
    
    static func doorButton(node: SKNode, scene: SKScene)
    {
        if(door.name == "close" && upperDoor.name == "close"){
            switch node.name{
            case "R":
                if(hasRedKey){
                    button.texture = SKTexture(imageNamed: "buttonRed_pressed")
                    openDoor(scene: scene)
                }
                else{
                    print("Need Red Key...")
                }
            case "G":
                if(hasGreenKey){
                    button.texture = SKTexture(imageNamed: "buttonGreen_pressed")
                    openDoor(scene: scene)
                }
                else{
                    print("Need Green Key...")
                }
            case "B":
                if(hasBlueKey){
                    button.texture = SKTexture(imageNamed: "buttonBlue_pressed")
                    openDoor(scene: scene)
                }
                else{
                    print("Need Blue Key...")
                }
            case "Y":
                if(hasYellowKey){
                    button.texture = SKTexture(imageNamed: "buttonYellow_pressed")
                    openDoor(scene: scene)
                }
                else{
                    print("Need Yellow Key...")
                }
            default:
                print("Unrecognized Button")
            }
        }
    }
    
    static func openDoor(scene: SKScene){
        upperDoor.texture = SKTexture(imageNamed: "door_openTop")
        upperDoor.name = "open"
        door.texture = SKTexture(imageNamed: "door_openMid")
        door.name = "open"
        scene.run(doorSFX)
        print("Door Opened...")
    }
    
    static func checkTransition(name: String, scene: SKScene)->Bool{
        print(nextScene!.name!)
        switch name {
        case "open":
            if(nextScene!.name! != "end"){
                print("Transport to next map...")
                waitForTransition = false
                cleanForNextLevel()
                nextLevel = true
            }
            else{
                waitForTransition = false
                gameComplete(scene: scene)
                nextLevel = false
            }
        case "close":
            print("Door locked, find the key...")
            nextLevel = false
        default:
            print("Unrecognized Door...")
        }
        return nextLevel
    }
    
    static func gameComplete(scene: SKScene){
        gameEnd = true
        Clock.resetClock()
        Player.sprite.removeFromParent()
        GameUI.removeGameUI()
        GameUI.resetKeyUI()
        PlayerController.removePlayerController()
        GameUI.setGameCompleteUI(scene: scene)
        print("Game Complete")
    }
    
    static func gameOver(){
        gameFailed = true
        Clock.resetClock()
        Player.sprite.removeFromParent()
        GameUI.removeGameUI()
        GameUI.resetKeyUI()
        PlayerController.removePlayerController()
        GameUI.showGameOverUI()
        print("Game Over...")
    }
    
    static func cleanForNextLevel(){
        enemies.removeAll()
        print("Clean Previous Enemies")
        gameBGM.removeFromParent()
        Player.sprite.removeFromParent()
        GameUI.removeGameUI()
        GameUI.removeGameOverUI()
        PlayerController.removePlayerController()
        Clock.clock.removeFromParent()
        print("Clean Stage For Next Level")
    }
    
    static func replay(scene: SKScene){
        resetGameData()
        cleanForNextLevel()
        nextScene = Level1(fileNamed: "Level1")
        nextScene?.scaleMode = .aspectFill
        scene.view?.presentScene(nextScene)
        print("Replay...")
    }
}

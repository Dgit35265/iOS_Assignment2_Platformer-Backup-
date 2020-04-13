//
//  Button.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-11.
//  Copyright © 2020 Alliance Game. All rights reserved.
//
import UIKit
import SpriteKit

class PlayerController{
    static var upBtn = SKShapeNode()
    static var leftBtn = SKShapeNode()
    static var rightBtn = SKShapeNode()

    static func setPlayerController(scene: SKScene){
        upBtn = SKShapeNode(circleOfRadius: 80)
        upBtn.fillColor = .cyan
        upBtn.alpha = 0.7
        upBtn.position = CGPoint(x: -scene.frame.width/3, y: -scene.frame.height/6)
        upBtn.zPosition = 1
        
        leftBtn = SKShapeNode(circleOfRadius: 80)
        leftBtn.fillColor = .green
        leftBtn.alpha = 0.7
        leftBtn.position = CGPoint(x: -scene.frame.width/3-150, y: -scene.frame.height/6-150)
        leftBtn.zPosition = 1
        
        rightBtn = SKShapeNode(circleOfRadius: 80)
        rightBtn.fillColor = .green
        rightBtn.alpha = 0.7
        rightBtn.position = CGPoint(x: -scene.frame.width/3+150, y: -scene.frame.height/6-150)
        rightBtn.zPosition = 1
        print("Set Player Controller")
    }
    
    static func addPlayerController(scene: SKScene){
        scene.addChild(upBtn)
        scene.addChild(leftBtn)
        scene.addChild(rightBtn)
        print("Add Player Controller")
    }
    
    static func removePlayerController(){
        upBtn.removeFromParent()
        leftBtn.removeFromParent()
        rightBtn.removeFromParent()
        print("Remove Player Controller")
    }
}



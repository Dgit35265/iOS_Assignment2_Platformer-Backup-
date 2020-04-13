//
//  Timer.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-11.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit

class Clock{
    static var clock = SKLabelNode()
    static var maxTime = 180
    static var time = 0
    static var timer = Timer()

    static func createClock(scene: SKScene){
        time = maxTime
        clock.position = CGPoint(x: 0, y: 3*scene.frame.height/10)
        clock.text = "\(time)"
        clock.zPosition = 1
        clock.fontSize = 120
        clock.fontName = "HelveticaNeue-Bold"
        clock.fontColor = .white
        scene.addChild(clock)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        GameManager.gameStart = true
    }
    @objc static func updateTimer(){
        time -= 1
        clock.text = "\(time)"
        if time <= 0{
            GameManager.gameOver()
        }
    }
    
    static func resetClock(){
        timer.invalidate()
        clock.removeFromParent()
        time = maxTime
        print("Reset Clock")
    }
}




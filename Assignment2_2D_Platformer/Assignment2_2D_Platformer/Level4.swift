//
//  Level4.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-13.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit

class Level4: SKScene, SKPhysicsContactDelegate{
    
    func initGame(){
        print("Level-4")
        Player.sprite = setPlayer(scene: self)
        GameUI.addGameUI(scene: self)
        PlayerController.addPlayerController(scene: self)
        setBoundPhyscis(scene: self)
        self.physicsWorld.contactDelegate = self
        setTileMapPhysics(scene: self)
        if(GameManager.gameStart)
        {
            addChild(GameManager.gameBGM)
            addChild(Clock.clock)
            print("Previous Clock && BGM Spawned...")
        }
    }
    
    override func didMove(to view: SKView) {
        GameManager.nextScene = Level5(fileNamed: "Level5")
        GameManager.nextScene?.name = "5"
        GameManager.nextScene?.scaleMode = .aspectFill
        initGame()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if(!GameManager.gameStart)
        {
            Clock.createClock(scene: self)
            addChild(GameManager.gameBGM)
        }
        //Replay
        if(GameManager.gameFailed){
            GameManager.replay(scene: self)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    @objc func moveRight(sender : UIButton){
        print("Move Right...")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            let location = t.location(in: self)
            if PlayerController.upBtn.contains(location)
            {
                Player.jump()
                //print("Jump")
            }
            if PlayerController.leftBtn.contains(location)
            {
                Player.right = -1
                //print("Move Left")
            }
            if PlayerController.rightBtn.contains(location)
            {
                Player.right = 1
                Player.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                //print("Move Right")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Player.right = 0
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Player Update
        Player.update(currentTime: currentTime)
        //Enemies Update
        for e in GameManager.enemies{
            e.update(currentTime: currentTime)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        Player.didBeginContact(contact: contact, scene: self)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        Player.didEndContact(contact: contact, scene: self)
    }
}

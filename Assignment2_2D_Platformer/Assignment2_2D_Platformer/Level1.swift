//
//  GameScene.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-11.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit

class Level1: SKScene, SKPhysicsContactDelegate{
    
    func initGame(){
        print("Level-1")
        Player.sprite = setPlayer(scene: self)
        Player.touchedEnemy = false
        GameUI.setGameUI(scene: self)
        GameUI.addGameUI(scene: self)
        PlayerController.setPlayerController(scene: self)
        PlayerController.addPlayerController(scene: self)
        setBoundPhyscis(scene: self)
        self.physicsWorld.contactDelegate = self
        setTileMapPhysics(scene: self)
        if(GameManager.gameStart)
        {
            addChild(Clock.clock)
            print("Previous Clock Spawned...")
        }
    }
    
    override func didMove(to view: SKView) {
        GameManager.nextScene = Level2(fileNamed: "Level2")
        GameManager.nextScene?.name = "2"
        GameManager.nextScene?.scaleMode = .aspectFill
        initGame()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if(!GameManager.gameStart)
        {
            for node in self.children{
                if(node.name == "Title")
                {
                    node.run(SKAction.fadeOut(withDuration: 0.5))
                }
            }
            Clock.createClock(scene: self)
            GameManager.gameBGM.autoplayLooped = true
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

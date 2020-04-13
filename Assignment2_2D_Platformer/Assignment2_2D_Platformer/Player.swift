//
//  Player.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-11.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit

enum State{
    case None
    case Idle
    case Walking
    case Jump
    case Landing
    case Hurt
}

class Player{
    static var sprite = SKSpriteNode()
    static var isGround: Bool = false
    static var damaged: Bool = false
    static var touchedEnemy: Bool = false
    static var timeBeforeDamage: Double = 0
    static var deltaTime: Double = 0
    static var lastUpdateTime: Double = 0
    static var right: Double = 0 // -1: move left; 0: stand; 1: move right
    static var acceleration: Double = 2000
    static var maxSpeedX: CGFloat = 600
    static var feetPosition: CGFloat = 0
    //Animation
    static var playerAnims: [SKAction] = []
    static var playerIdle: [SKTexture] = [] //0
    static var playerHurt: [SKTexture] = [] //1
    static var playerJump: [SKTexture] = [] //2
    static var playerLand: [SKTexture] = [] //3
    static var playerWalk: [SKTexture] = [] //4
    //Animation State
    static var state: State = State.None
    
    static func bindAnim(){
        playerIdle.append(SKTexture(imageNamed: "p1_idle01"))
        playerIdle.append(SKTexture(imageNamed: "p1_idle02"))
        
        playerHurt.append(SKTexture(imageNamed: "p1_hurt"))
        playerJump.append(SKTexture(imageNamed: "p1_jump"))
        playerLand.append(SKTexture(imageNamed: "p1_land"))
        
        playerWalk.append(SKTexture(imageNamed: "p1_walk01"))
        playerWalk.append(SKTexture(imageNamed: "p1_walk02"))
        playerWalk.append(SKTexture(imageNamed: "p1_walk03"))
        playerWalk.append(SKTexture(imageNamed: "p1_walk04"))
        playerWalk.append(SKTexture(imageNamed: "p1_walk05"))
        playerWalk.append(SKTexture(imageNamed: "p1_walk06"))
        playerWalk.append(SKTexture(imageNamed: "p1_walk07"))
        
        playerAnims.append(SKAction.animate(with: playerIdle, timePerFrame: 1))
        playerAnims.append(SKAction.animate(with: playerHurt, timePerFrame: 0.2))
        playerAnims.append(SKAction.animate(with: playerJump, timePerFrame: 0.2))
        playerAnims.append(SKAction.animate(with: playerLand, timePerFrame: 0.2))
        playerAnims.append(SKAction.animate(with: playerWalk, timePerFrame: 0.1))
        print("Player Animation Binded...")
    }
    
    static func jump(){
        if(isGround){
            Player.sprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 780))
            sprite.removeAction(forKey: "Idling")
            sprite.removeAction(forKey: "Walking")
            sprite.run(playerAnims[2])
            state = State.Jump
            print("Jumping")
        }
    }
    
    static func checkGrounded(){
        if(!isGround && abs((sprite.physicsBody?.velocity.dy)!) < 50){
            isGround = true
            touchedEnemy = false
        }
    }
    
    static func hurt(){
        sprite.physicsBody?.applyImpulse(CGVector(dx: -500, dy: 500))
        sprite.removeAction(forKey: "Idling")
        sprite.removeAction(forKey: "Walking")
        sprite.run(playerAnims[1])
        state = State.Hurt
        print("Player Hurt")
    }
    
    static func kill(){
        sprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 800))
    }
    
    static func update(currentTime: TimeInterval){
        feetPosition = sprite.position.y - sprite.size.height/2
        //damage restore
        if(damaged){ //restore from damaged stage
            //print("Restoring...")
            if(currentTime - timeBeforeDamage >= 2){ //store after 2 secs
                damaged = false
                print("Restored...")
            }
        }
        else{
            timeBeforeDamage = currentTime
        }
        //get deltaTime
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime
        }
        else{
            deltaTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
            //print(deltaTime)
        }
        //filp texture
        if(right == 1){
            sprite.xScale = 1
            if(isGround && state != State.Walking){
                sprite.removeAction(forKey: "Idling")
                sprite.run(SKAction.repeatForever(playerAnims[4]), withKey: "Walking")
                state = State.Walking
                print("Walking")
            }
        }
        if(right == -1){
            sprite.xScale = -1
            if(isGround && state != State.Walking){
                sprite.removeAction(forKey: "Idling")
                sprite.run(SKAction.repeatForever(playerAnims[4]), withKey: "Walking")
                state = State.Walking
                print("Walking")
            }
        }
        if(right == 0){
            if(isGround && (state == State.None || state == State.Landing || state == State.Walking) &&
                abs(sprite.physicsBody!.velocity.dx) < 10){
                sprite.removeAction(forKey: "Walking")
                sprite.run(SKAction.repeatForever(playerAnims[0]), withKey: "Idling")
                state = State.Idle
                print("Idling")
            }
        }
        //movement
        sprite.physicsBody?.velocity.dx += CGFloat(acceleration * right * deltaTime)
        sprite.physicsBody?.velocity.dx = CGFloat.minimum(CGFloat.maximum((sprite.physicsBody?.velocity.dx)!, -maxSpeedX), maxSpeedX) //clamp velocity
        //print(sprite.physicsBody?.velocity)
    }
    
    static func didBeginContact(contact: SKPhysicsContact, scene: SKScene){
        let BodyA = contact.bodyA
        let BodyB = contact.bodyB
        //Player grounded
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.groundCatgory ||
            BodyA.categoryBitMask == CollisionBitMask.groundCatgory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            checkGrounded()
            if(!GameManager.waitForTransition){
                GameManager.waitForTransition = true
                print("Wait For Transition...")
            }
            if(state == State.Hurt){
                state = State.None
            }
            else if(state == State.Jump && sprite.physicsBody!.velocity.dy > 0){
                state = State.Landing
                sprite.run(playerAnims[3])
                print("Landing")
            }
        }
        //collect coin
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.coinCategory{
            GameManager.getCoin(amount: Int(BodyB.node!.name!)!, scene: scene)
            BodyB.node!.removeFromParent()
        }
        else if BodyA.categoryBitMask == CollisionBitMask.coinCategory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            GameManager.getCoin(amount: Int(BodyA.node!.name!)!, scene: scene)
            BodyA.node!.removeFromParent()
        }
        //collect key
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.keyCategory{
            if(BodyB.node?.name != nil)
            {
                GameManager.getKey(name: BodyB.node!.name!, scene: scene)
                BodyB.node!.removeFromParent()
            }
        }
        else if BodyA.categoryBitMask == CollisionBitMask.keyCategory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            if(BodyA.node?.name != nil)
            {
                GameManager.getKey(name: BodyA.node!.name!, scene: scene)
                BodyA.node!.removeFromParent()
            }
        }
        //spike
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.spikeCatgory ||
            BodyA.categoryBitMask == CollisionBitMask.spikeCatgory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            if(!damaged){
                isGround = true
                GameManager.getDamage(amount: 1, scene: scene)
                if(state == State.Hurt){
                    state = State.None
                }
            }
        }
        //door
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.doorCategory{
            if(GameManager.waitForTransition){
                if(GameManager.checkTransition(name: BodyB.node!.name!, scene: scene)){
                    scene.view?.presentScene(GameManager.nextScene)
                }
            }
        }
        else if BodyA.categoryBitMask == CollisionBitMask.doorCategory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            if(GameManager.waitForTransition)
            {
                if(GameManager.checkTransition(name: BodyA.node!.name!, scene: scene)){
                    scene.view?.presentScene(GameManager.nextScene)
                }
            }
        }
        //button
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.buttonCategory{
            GameManager.doorButton(node: BodyB.node!, scene: scene)
        }
        else if BodyA.categoryBitMask == CollisionBitMask.buttonCategory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            GameManager.doorButton(node: BodyA.node!, scene: scene)
        }
        //enemy
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.enemyCategory{
            if(!touchedEnemy){ //prevent contact multiple times which cause null access
                let index: Int? = Int(BodyB.node!.name!)
                let e = GameManager.enemies[index!]
                if(e.alive){
                    if((Player.sprite.physicsBody?.velocity.dy)! < 0 && feetPosition > e.headPosition){
                        e.death()
                        scene.run(GameManager.slimeDeathSFX)
                        kill()
                        print("Enemies left: \(GameManager.enemies.count)")
                        touchedEnemy = true
                    }
                    else{
                        if(!Player.damaged){ //prevent getting damaged multiple times
                            Player.checkGrounded()
                            GameManager.getDamage(amount: e.damage, scene: scene)
                            touchedEnemy = true
                        }
                    }
                }
            }
            else{
                print("Enemy Touched...")
            }
        }
        else if BodyA.categoryBitMask == CollisionBitMask.enemyCategory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            if(!touchedEnemy){ //prevent contact multiple times which cause null access
                let index: Int? = Int(BodyA.node!.name!)
                let e = GameManager.enemies[index!]
                if(e.alive){
                    if((Player.sprite.physicsBody?.velocity.dy)! < 0 && feetPosition > e.headPosition){
                        e.sprite.removeFromParent()
                        e.alive = false
                        kill()
                        print("Kill Enmey")
                        touchedEnemy = true
                    }
                    else{
                        if(!Player.damaged){
                            Player.checkGrounded()
                            GameManager.getDamage(amount: e.damage, scene: scene)
                            touchedEnemy = true
                        }
                    }
                }
                print("Enemies left: \(GameManager.enemies.count)")
            }
        }
    }
    
    static func didEndContact(contact: SKPhysicsContact, scene: SKScene){
        let BodyA = contact.bodyA
        let BodyB = contact.bodyB
        //Player leave ground
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.groundCatgory ||
            BodyA.categoryBitMask == CollisionBitMask.groundCatgory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            if(abs((sprite.physicsBody?.velocity.dy)!) > 50){
                Player.isGround = false
            }
        }
        //Touched Enemy
        if BodyA.categoryBitMask == CollisionBitMask.playerCategory && BodyB.categoryBitMask == CollisionBitMask.enemyCategory ||
            BodyA.categoryBitMask == CollisionBitMask.enemyCategory && BodyB.categoryBitMask == CollisionBitMask.playerCategory{
            Player.touchedEnemy = false
        }
    }
}

func setPlayer(scene: SKScene)->SKSpriteNode{
    var playerSprite = SKSpriteNode()
    playerSprite = SKSpriteNode(imageNamed: "p1_idle01")
    playerSprite.size = CGSize(width: 2*playerSprite.texture!.size().width, height: 2*playerSprite.texture!.size().height)
    playerSprite.position = CGPoint(x: -scene.frame.width/3 - playerSprite.size.width, y: -playerSprite.size.height)
    playerSprite.zPosition = 1
    playerSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1.5*playerSprite.texture!.size().width, height: 2*playerSprite.texture!.size().height))
    playerSprite.physicsBody?.affectedByGravity = true
    playerSprite.physicsBody?.allowsRotation = false
    playerSprite.physicsBody?.linearDamping = 0
    playerSprite.physicsBody?.categoryBitMask = CollisionBitMask.playerCategory
    playerSprite.physicsBody?.collisionBitMask = CollisionBitMask.groundCatgory | CollisionBitMask.boundCategory |
        CollisionBitMask.spikeCatgory
    playerSprite.physicsBody?.contactTestBitMask = CollisionBitMask.doorCategory | CollisionBitMask.enemyCategory |
        CollisionBitMask.keyCategory | CollisionBitMask.groundCatgory | CollisionBitMask.coinCategory |
        CollisionBitMask.spikeCatgory | CollisionBitMask.buttonCategory
    
    Player.bindAnim()
    
    scene.addChild(playerSprite)
    print("Create and Add Player")
    return playerSprite
}




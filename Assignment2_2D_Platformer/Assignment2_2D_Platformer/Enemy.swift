//
//  Enemy.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-12.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit

class Enemy: SKNode{
    var sprite = SKSpriteNode()
    var damage: Int = 0
    var patrolDis: CGFloat = 0
    var headPosition: CGFloat = 0
    var alive: Bool = true
    var moveLeft: Bool = true
    var moving: Bool = false
    //Animation
    var enemyAnims: [SKAction] = []
    var enemyMove: [SKTexture] = [] //0
    var enemyDeath: [SKTexture] = [] //1
    
    init(eDamage: Int, patrolDistance: CGFloat) {
        damage = eDamage
        patrolDis = patrolDistance
        
        super.init()
        bindAnim()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindAnim(){
        enemyMove.append(SKTexture(imageNamed: "slimeWalk1"))
        enemyMove.append(SKTexture(imageNamed: "slimeWalk2"))
        enemyDeath.append(SKTexture(imageNamed: "slimeDead"))
        
        enemyAnims.append(SKAction.animate(with: enemyMove, timePerFrame: 0.2))
        enemyAnims.append(SKAction.animate(with: enemyDeath, timePerFrame: 0.2))
        print("Enemy Animation Binded")
    }
    
    func patrol(){
        if(!moving)
        {
            if(moveLeft)
            {
                moving = true
                sprite.xScale = 4
                sprite.run(SKAction.repeatForever(enemyAnims[0]), withKey: "Moving")
                sprite.run(SKAction.sequence([SKAction.moveBy(x: -patrolDis, y: 0, duration: 1), SKAction.wait(forDuration: 0.5), SKAction.run(readyToMove)]), withKey: "Patrol")
            }
            else{
                moving = true
                sprite.xScale = -4
                sprite.run(SKAction.repeatForever(enemyAnims[0]), withKey: "Moving")
                sprite.run(SKAction.sequence([SKAction.moveBy(x: patrolDis, y: 0, duration: 1), SKAction.wait(forDuration: 0.5), SKAction.run(readyToMove)]), withKey: "Patrol")
            }
        }
    }
    
    func readyToMove(){
        sprite.removeAction(forKey: "Moving")
        sprite.removeAction(forKey: "Patrol")
        moving = false
        moveLeft = !moveLeft //toggle direction
        //print("Ready to move")
    }
    
    func death(){
        sprite.physicsBody = nil
        sprite.size.height /= 2
        sprite.position.y -= sprite.size.height/2
        sprite.run(SKAction.sequence([enemyAnims[1], SKAction.wait(forDuration: 0.5),
            SKAction.run{ self.sprite.removeFromParent()}]))
        alive = false
        sprite.removeAction(forKey: "Moving")
        sprite.removeAction(forKey: "Patrol")
        print("Enmey Killed")
    }
    
    func update(currentTime: TimeInterval){
        headPosition = sprite.position.y //+ sprite.size.height/2
        patrol()
    }
}

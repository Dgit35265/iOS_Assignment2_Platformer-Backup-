//
//  TileMapPhysics.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-11.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

import SpriteKit



func setBoundPhyscis(scene: SKScene){
    let borderBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    scene.physicsBody = borderBody
    scene.physicsBody?.categoryBitMask = CollisionBitMask.boundCategory
    scene.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory | CollisionBitMask.enemyCategory
    scene.physicsBody?.isDynamic = false
    scene.physicsBody?.affectedByGravity = false
}

func setTileMapPhysics(scene: SKScene){
    for node in scene.children{
        if(node.name == "Ground")
        {
            if let tileMap: SKTileMapNode = node as? SKTileMapNode{
                setGroundPhysicsBody(scene: scene, tileMap: tileMap)
                tileMap.removeFromParent()
            }
        }
        else if(node.name == "Coin")
        {
            if let tileMap: SKTileMapNode = node as? SKTileMapNode{
                setCoinPhysicsBody(scene: scene, tileMap: tileMap)
                tileMap.removeFromParent()
            }
        }
        else if(node.name == "Key")
        {
            if let tileMap: SKTileMapNode = node as? SKTileMapNode{
                setKeyPhysicsBody(scene: scene, tileMap: tileMap)
                tileMap.removeFromParent()
            }
        }
        else if(node.name == "Spike")
        {
            if let tileMap: SKTileMapNode = node as? SKTileMapNode{
                setSpikePhysicsBody(scene: scene, tileMap: tileMap)
                tileMap.removeFromParent()
            }
        }
        else if(node.name == "Door")
        {
           if let tileMap: SKTileMapNode = node as? SKTileMapNode{
                setDoorPhysicsBody(scene: scene, tileMap: tileMap)
                tileMap.removeFromParent()
            }
        }
        else if(node.name == "Button")
        {
           if let tileMap: SKTileMapNode = node as? SKTileMapNode{
                setButtonPhysicsBody(scene: scene, tileMap: tileMap)
                tileMap.removeFromParent()
            }
        }
        else if(node.name == "Enemy")
        {
            if let tileMap: SKTileMapNode = node as? SKTileMapNode{
                setEnemyPhysicsBody(scene: scene, tileMap: tileMap)
                tileMap.removeFromParent()
            }
        }
    }
}

func setGroundPhysicsBody(scene: SKScene, tileMap: SKTileMapNode){
    let startLocation:CGPoint = tileMap.position
    let tileSize = CGSize(width: 4*tileMap.tileSize.width, height: 4*tileMap.tileSize.height)
    let halfWidth = CGFloat(tileMap.numberOfColumns)/2 * tileSize.width
    let halfHeight = CGFloat(tileMap.numberOfRows)/2 * tileSize.height
    
    for col in 0..<tileMap.numberOfColumns{
        for row in 0..<tileMap.numberOfRows{
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                
                let tileNode = SKSpriteNode(texture: tileTexture)
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.setScale(4) // scale sprite
                tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: 4*(tileTexture.size().width), height: 4*(tileTexture.size().height)))// scale physicsbody
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = CollisionBitMask.groundCatgory
                tileNode.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory | CollisionBitMask.enemyCategory
                tileNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
                
                scene.addChild(tileNode)
                tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
            }
        }
    }
}

func setCoinPhysicsBody(scene: SKScene, tileMap: SKTileMapNode){
    let startLocation:CGPoint = tileMap.position
    let tileSize = CGSize(width: 4*tileMap.tileSize.width, height: 4*tileMap.tileSize.height)
    let halfWidth = CGFloat(tileMap.numberOfColumns)/2 * tileSize.width
    let halfHeight = CGFloat(tileMap.numberOfRows)/2 * tileSize.height
    
    for col in 0..<tileMap.numberOfColumns{
        for row in 0..<tileMap.numberOfRows{
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                
                let tileNode = SKSpriteNode(texture: tileTexture)
                //assgin coin value based on texture name
                switch String(tileTexture.description[tileTexture.description.index(tileTexture.description.startIndex, offsetBy: 13)...tileTexture.description.index(tileTexture.description.endIndex, offsetBy: -12)]) {
                case "coinGold":
                    tileNode.name = "3"
                case "coinSilver":
                    tileNode.name = "2"
                case "coinBronze":
                    tileNode.name = "1"
                default:
                    tileNode.name = "0"
                }
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.setScale(4) // scale sprite
                tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2*(tileTexture.size().width), height: 2*(tileTexture.size().width)))
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
                tileNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
                
                scene.addChild(tileNode)
                tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
            }
        }
    }
}
func setKeyPhysicsBody(scene: SKScene, tileMap: SKTileMapNode){
    let startLocation:CGPoint = tileMap.position
    let tileSize = CGSize(width: 4*tileMap.tileSize.width, height: 4*tileMap.tileSize.height)
    let halfWidth = CGFloat(tileMap.numberOfColumns)/2 * tileSize.width
    let halfHeight = CGFloat(tileMap.numberOfRows)/2 * tileSize.height
    
    for col in 0..<tileMap.numberOfColumns{
        for row in 0..<tileMap.numberOfRows{
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                
                let tileNode = SKSpriteNode(texture: tileTexture)
                //assgin key name to set key UI
                tileNode.name = String(tileTexture.description[tileTexture.description.index(tileTexture.description.startIndex, offsetBy: 16)...tileTexture.description.index(tileTexture.description.endIndex, offsetBy: -12)])
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.setScale(4) // scale sprite
                tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: 4*(tileTexture.size().width), height: 4*(tileTexture.size().height)))// scale physicsbody
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = CollisionBitMask.keyCategory
                tileNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
                
                scene.addChild(tileNode)
                tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
            }
        }
    }
}

func setSpikePhysicsBody(scene: SKScene, tileMap: SKTileMapNode){
    let startLocation:CGPoint = tileMap.position
    let tileSize = CGSize(width: 4*tileMap.tileSize.width, height: 4*tileMap.tileSize.height)
    let halfWidth = CGFloat(tileMap.numberOfColumns)/2 * tileSize.width
    let halfHeight = CGFloat(tileMap.numberOfRows)/2 * tileSize.height
    
    for col in 0..<tileMap.numberOfColumns{
        for row in 0..<tileMap.numberOfRows{
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                
                let tileNode = SKSpriteNode(texture: tileTexture)
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.setScale(4) // scale sprite
                tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: 4*(tileTexture.size().width), height: 4*(tileTexture.size().height)))// scale physicsbody
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = CollisionBitMask.spikeCatgory
                tileNode.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
                tileNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
                
                scene.addChild(tileNode)
                tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
            }
        }
    }
}

func setDoorPhysicsBody(scene: SKScene, tileMap: SKTileMapNode){
    let startLocation:CGPoint = tileMap.position
    let tileSize = CGSize(width: 4*tileMap.tileSize.width, height: 4*tileMap.tileSize.height)
    let halfWidth = CGFloat(tileMap.numberOfColumns)/2 * tileSize.width
    let halfHeight = CGFloat(tileMap.numberOfRows)/2 * tileSize.height
    
    for col in 0..<tileMap.numberOfColumns{
        for row in 0..<tileMap.numberOfRows{
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                
                let tileNode = SKSpriteNode(texture: tileTexture)
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.setScale(2) // scale sprite
                //print(tileTexture.description[tileTexture.description.index(tileTexture.description.startIndex, offsetBy: 18)...tileTexture.description.index(tileTexture.description.endIndex, offsetBy: -15)])
                tileNode.name = String(tileTexture.description[tileTexture.description.index(tileTexture.description.startIndex, offsetBy: 18)...tileTexture.description.index(tileTexture.description.endIndex, offsetBy: -15)])
                tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: 2*(tileTexture.size().width), height: 2*(tileTexture.size().height)))// scale physicsbody
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = CollisionBitMask.doorCategory
                tileNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
                
                //print(String(tileTexture.description[tileTexture.description.index(tileTexture.description.endIndex, offsetBy: -14)]))
                tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
                switch String(tileTexture.description[tileTexture.description.index(tileTexture.description.endIndex, offsetBy: -14)]){
                case "M":
                    GameManager.door = tileNode
                    scene.addChild(GameManager.door)
                case "T":
                    GameManager.upperDoor = tileNode
                    scene.addChild(GameManager.upperDoor)
                default:
                    print("Unrecognized MorT Door Part")
                }
            }
        }
    }
}

func setButtonPhysicsBody(scene: SKScene, tileMap: SKTileMapNode){
    let startLocation:CGPoint = tileMap.position
    let tileSize = CGSize(width: 4*tileMap.tileSize.width, height: 4*tileMap.tileSize.height)
    let halfWidth = CGFloat(tileMap.numberOfColumns)/2 * tileSize.width
    let halfHeight = CGFloat(tileMap.numberOfRows)/2 * tileSize.height
    
    for col in 0..<tileMap.numberOfColumns{
        for row in 0..<tileMap.numberOfRows{
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                
                let tileNode = SKSpriteNode(texture: tileTexture)
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.setScale(2) // scale sprite
                //print(String(tileTexture.description[tileTexture.description.index(tileTexture.description.startIndex, offsetBy: 19)]))
                tileNode.name = String(tileTexture.description[tileTexture.description.index(tileTexture.description.startIndex, offsetBy: 19)])
                tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: 2*(tileTexture.size().width), height: 2*(tileTexture.size().height)))// scale physicsbody
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = CollisionBitMask.buttonCategory
                tileNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
                
                tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
                GameManager.button = tileNode
                
                scene.addChild(GameManager.button)
            }
        }
    }
}

func setEnemyPhysicsBody(scene: SKScene, tileMap: SKTileMapNode){
    let startLocation:CGPoint = tileMap.position
    let tileSize = CGSize(width: 4*tileMap.tileSize.width, height: 4*tileMap.tileSize.height)
    let halfWidth = CGFloat(tileMap.numberOfColumns)/2 * tileSize.width
    let halfHeight = CGFloat(tileMap.numberOfRows)/2 * tileSize.height
    
    for col in 0..<tileMap.numberOfColumns{
        for row in 0..<tileMap.numberOfRows{
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                
                let tileNode = SKSpriteNode(texture: tileTexture)
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.setScale(4) // scale sprite
                //print(tileNode.description)
                tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: 4*(tileTexture.size().width), height: 4*(tileTexture.size().height)))// scale physicsbody
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
                tileNode.physicsBody?.collisionBitMask = CollisionBitMask.boundCategory | CollisionBitMask.groundCatgory | CollisionBitMask.spikeCatgory
                tileNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory | CollisionBitMask.boundCategory
                
                tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
                
                let e = Enemy(eDamage: 1, patrolDistance: 300)
                e.sprite = tileNode
                GameManager.enemies.append(e)
                tileNode.name = String(GameManager.enemies.count - 1)
                
                scene.addChild(e.sprite)
            }
        }
    }
}

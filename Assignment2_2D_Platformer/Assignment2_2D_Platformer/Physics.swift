//
//  Physics.swift
//  Assignment2_2D_Platformer
//
//  Created by DING ZHANG on 2020-04-11.
//  Copyright © 2020 Alliance Game. All rights reserved.
//

public struct CollisionBitMask {
    static let playerCategory:UInt32 = 0x1 << 0
    static let doorCategory:UInt32 = 0x1 << 1
    static let enemyCategory:UInt32 = 0x1 << 2
    static let keyCategory:UInt32 = 0x1 << 3
    static let groundCatgory:UInt32 = 0x1 << 4
    static let coinCategory:UInt32 = 0x1 << 5
    static let boundCategory:UInt32 = 0x1 << 6
    static let spikeCatgory:UInt32 = 0x1 << 7
    static let buttonCategory:UInt32 = 0x1 << 8
}

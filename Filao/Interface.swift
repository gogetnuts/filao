//
//  Interface.swift
//  Filao
//
//  Created by Ben on 30/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//


import SpriteKit

class filterButton : NSButton  {

    override open func mouseDown(with event: NSEvent) {

        switch(title) {


        case "Humidity" :
            if state == 1 {
                for (_, tile) in newTileTable {
                    tile.text.removeFromParent()
                }
            } else {
                for (_, tile) in newTileTable {
                    tile.addChild(tile.text)
                }
            }

        case "Level 1" :
            if state == 1 {
                for (_, tile) in newTileTable {
                    tile.level1.removeFromParent()
                }
            } else {
                for (_, tile) in newTileTable {
                    tile.addChild(tile.level1)
                }
            }

        case "Physics" :
            if state == 1 {
                scNode?.view?.showsPhysics = false
            } else {
                scNode?.view?.showsPhysics = true
            }
        case "Grid" :
            if state == 1 {
                for (_, tile) in newTileTable {
                    tile.strokeColor = SKColor.clear
                }
            } else {
                for (_, tile) in newTileTable {
                    tile.strokeColor = SKColor.white
                }
            }
        default : break

        }

        //Toggle Button State
        state = state == 0 ? 1 : 0
    }
}


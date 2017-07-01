//
//  newGridClass.swift
//  Filao
//
//  Created by Ben on 30/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit

class newGrid : SKNode {
    var line:Int

    let nbTilePerLine = 8
    let nbLines = 8
    let origin:Point

    init(start:Point, line:Int) {
        self.line = line
        self.origin = start
        super.init()
        generateSprites(true)
        zPosition = CGFloat(line)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func generateSprites(_ fromScratch:Bool) {
        let nbTile = nbTilePerLine * nbLines

        var posX = 0
        var posY = 0

        var column = 0

        /* Draw Grid loop */
        for i:Int in 0 ..< nbTile {

            //Define row and newColumn
            let row = i%nbTilePerLine

            let newColumn = row == 0 ? true : false

            //If newColumn and not firstColumn define origin
            if newColumn && i != 0 {
                column += 1
                posX = column * tileHalfWidth
                posY = -column * tileHalfHeight
            }

            //Define raw point
            posX += tileHalfWidth
            posY += tileHalfHeight

            if fromScratch {

                let newtile = newTile(coo: ( origin.x + row , origin.y + column ))
                newtile.position = CGPoint(x: posX, y: posY)

                addChild(newtile)
                newTileTable[newtile.point] = newtile

                newtile.bitMask = UInt32(1 << column)
                newtile.bound.physicsBody?.categoryBitMask = UInt32(1 << column)
                newtile.zPosition = CGFloat(-row)

                //newTile.level
                /*let tile = Tile(coo: ( origin.x + row , origin.y + column ))

                tile.position = CGPoint(x: posX, y: posY)


                
                
                addChild(tile)*/
                
                //tileTable[tile.point] = tile
            } else {
                //build from database

                //let tile = newTileTable[Point(origin.x + row , origin.y + column)]!
                //addChild(level0)
            }

        }
    }

    //Create a bitmap SKTexture out of self
    //Increasing performance with png texture
    func setTextureMap() {
        if self.childNode(withName: "bitmap") == nil {

            
            let texture:SKTexture? = self.scene?.view?.texture(from: self)
            let node = SKSpriteNode(texture: texture)

            node.position.y += CGFloat(tileHeight/2)
            node.position.x -= 4
            node.anchorPoint = CGPoint(x:0,y:0.5)
            node.zPosition = -100
            node.name = "bitmap"

            let removables = self.children.filter({ $0.isMember(of: newTile.self) }) as! [newTile]

            for child in removables {
                child.level0.removeFromParent()
            }

            self.addChild(node)
        }

    }

    //Delete the bitmapTexture and restore node tree
    func removeTextureMap() {
        if let bitmap = self.childNode(withName: "bitmap") {
            bitmap.removeFromParent()
            for tile in children.filter({ $0.isMember(of: newTile.self) }) as! [newTile] {
                tile.addChild(tile.level0)
            }
        }
    }

}


//
//  newGridClass.swift
//  Filao
//
//  Created by Ben on 30/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
// 

import SpriteKit

class Grid : SKNode {
    var line:Int

    let nbTilePerLine = 3
    let nbLines = 3
    let origin:Point
    var level0:SKSpriteNode?
    var updateBitmap:Bool = false
    var layer0:Layer = Layer()


    var tl:Grid {
        let grid = Grid(start: Point(origin.x,origin.y - nbTilePerLine), line:line - 10)
        grid.position.x = position.x - CGFloat(tileHalfWidth * nbTilePerLine)
        grid.position.y = position.y + CGFloat(tileHalfHeight * nbTilePerLine)
        return grid
    }
    var br:Grid {
        let grid = Grid(start: Point(origin.x, origin.y + nbTilePerLine), line:line + 10)
        grid.position.x = position.x + CGFloat(tileHalfWidth * nbTilePerLine)
        grid.position.y = position.y - CGFloat(tileHalfHeight * nbTilePerLine)
        return grid
    }
    var tr:Grid {
        let grid = Grid(start: Point(origin.x + nbTilePerLine,origin.y), line:line - 10)
        grid.position.x = position.x + CGFloat(tileHalfWidth * nbTilePerLine)
        grid.position.y = position.y + CGFloat(tileHalfHeight * nbTilePerLine)
        return grid
    }
    var bl:Grid {
        let grid = Grid(start: Point(origin.x-nbTilePerLine,origin.y), line:line + 10)
        grid.position.x = position.x - CGFloat(tileHalfWidth * nbTilePerLine)
        grid.position.y = position.y - CGFloat(tileHalfHeight * nbTilePerLine)
        return grid
    }

    init(start:Point, line:Int) {
        self.line = line
        self.origin = start

        super.init()
        self.layer0.grid = self
        layer0.isHidden = false
        addChild(layer0)
        

        generateSprites(true)
        //zPosition = CGFloat(line)
        //setTextureMap()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func generateSprites(_ fromScratch:Bool) {
        let nbTile = nbTilePerLine * nbLines

        var posX = 0
        var posY = 0

        var column = 0

        var zPos = 0
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
                zPos += 1
            }

            //Define raw point
            posX += tileHalfWidth
            posY += tileHalfHeight

            if fromScratch {

                let tile = Tile(coo: ( origin.x + row , origin.y + column ))
                tile.position = CGPoint(x: posX, y: posY)
                

                tile.bitMask = UInt32(1 << column)
                tile.bound.physicsBody?.categoryBitMask = UInt32(1 << column)
                tile.zPosition = CGFloat(-origin.x + origin.y + zPos - row) * 2 + 400

                layer0.addChild(tile)
                tileTable[tile.point] = tile

                //tile.level1.zPosition = tile.zPosition + 1


            }

        }
    }

    //Create a bitmap SKTexture out of self
    //Then remove node tree
    //Increasing performance with png texture
    
    func setTextureMap() {
        if level0 == nil {
            print("new texture for Grid\(self.origin.x,self.origin.y)")
            layer0.isHidden = false
            let squareWidth = nbTilePerLine * tileWidth + 20
            let squareHeight = nbTilePerLine * tileHeight + 200
            let squareSize = CGSize(width: squareWidth, height: squareHeight)
            let squarePoint = CGPoint(x: self.layer0.position.x , y:self.layer0.position.y - CGFloat(squareHeight/2))
            let croppingSquare = CGRect(origin: squarePoint, size: squareSize)

            let texture:SKTexture? = self.scene?.view?.texture(from: self.layer0, crop: croppingSquare)
            //let texture:SKTexture? = self.scene?.view?.texture(from: self.layer0)
            level0 = SKSpriteNode(texture: texture)

            level0?.anchorPoint = CGPoint(x:0,y:0.5)
            level0?.zPosition = CGFloat(self.line)

            layer0.isHidden = true
            //addChild(layer0)

            self.addChild(level0!)
            self.updateBitmap = false
            print("Grid\(self.origin.x,self.origin.y) is now on demand")
        }

    }

    //Delete the bitmapTexture and restore node tree
    func removeTextureMap() {
        if level0 != nil {
            level0?.removeFromParent()

            level0 = nil
            layer0.isHidden = false
            print("Grid\(self.origin.x,self.origin.y) is now live")

        }
    }

}


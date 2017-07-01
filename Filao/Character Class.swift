//
//  Character Class.swift
//  Filao
//
//  Created by Ben on 29/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//
import SpriteKit

class characterMovable : SKSpriteNode {
    var positionInScene: CGPoint {
        return scene!.convert(position, from:firstCam)
    }
    
    init() {

        let texture = SKTexture(image: #imageLiteral(resourceName: "character"))

        super.init(texture: texture, color: NSColor.black, size: texture.size())

        anchorPoint = CGPoint(x:0.5,y:0)

        zPosition = 30000

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeRunTo(tile:newTile) {

        //Get tile character is on
        let characterTile = scNode!.getNewTileAt(point:scNode!.convert(position, from:parent!))!

        if hasActions() {
            removeAction(forKey: "Run")
        }

        if tile != characterTile {
            var path = getPath(start:characterTile.point, goal:tile.point)

            path.removeLast()
            //Run or Walk ?
            let speed = path.count > 3 ? CGFloat(300) : CGFloat(100)

            //Draw pathLine
            let pathLine = CGMutablePath()
            pathLine.move(to: position)
            for point in path {
                if let tile = point.newtile {
                    pathLine.addLine(to: tile.positionInCamera)
                }
            }

            //Execute Action Sequence
            run(SKAction.sequence([
                SKAction.follow(pathLine, asOffset: false, orientToPath : false, speed: speed),
                SKAction.dig(tile: tile, duration: 0.2)
                ]), withKey: "Run")


            //Turn pathLine into Node
            firstCam.childNode(withName: "shape1")?.removeFromParent()
            let shape = SKShapeNode(path: pathLine)
            shape.name = "shape1"
            shape.zPosition = 100
            firstCam.addChild(shape)
            
        }
    }
    func moveTo(tile:newTile) {

        //Get tile character is on
        let characterTile = scNode!.getNewTileAt(point:scNode!.convert(position, from:parent!))!

        if hasActions() {
            removeAction(forKey: "Run")
        }

        if tile != characterTile {
            let path = getPath(start:characterTile.point, goal:tile.point)

            //Run or Walk ?
            let speed:CGFloat = path.count > 3 ? 300 : 100

            //Draw pathLine
            let pathLine = CGMutablePath()
            pathLine.move(to: position)
            for point in path {
                if let tile = point.newtile {
                    pathLine.addLine(to: tile.positionInCamera)
                }
            }

            //Execute Action Sequence
            run(SKAction.sequence([
                SKAction.follow(pathLine, asOffset: false, orientToPath: false, speed: speed)
                ]), withKey: "Run")

            //SKAction.dig(tile: tile, duration: 0.2)

            //Turn pathLine into Node
            firstCam.childNode(withName: "shape")?.removeFromParent()
            let shape = SKShapeNode(path: pathLine)
            shape.name = "shape"
            shape.zPosition = 100
            firstCam.addChild(shape)
            
        }
    }


}

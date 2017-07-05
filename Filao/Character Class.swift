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

    var point:Point {
        return scNode!.getTileAt(point:scNode!.convert(position, from:parent!))!.point
    }

    var tile:Tile? {
        return scNode!.getTileAt(point:scNode!.convert(position, from:parent!))
    }
    
    init() {
        //self.contains

        let texture = SKTexture(image: #imageLiteral(resourceName: "character"))

        super.init(texture: texture, color: NSColor.black, size: texture.size())

        anchorPoint = CGPoint(x:0.5,y:0)

        zPosition = 30000

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func digTo(destination:Tile) {


        if let currentPosition = self.tile {
            if destination != currentPosition  {
                removeAction(forKey: "Run")

                var path = getPath(start:currentPosition.point, goal:destination.point)

                if !path.isEmpty {

                    var sequencedAction = [SKAction]()

                    let pointToDig = path.last!

                    if path.count > 1 {
                        path.removeLast() //Do not walk on last
                        sequencedAction += [runningActionSequence(path:path)]
                    }

                    sequencedAction += [SKAction.dig(tile: pointToDig.tile!, duration: 0)]
                    
                    self.run(SKAction.sequence(sequencedAction), withKey: "Run")
                }
                
            }
        }
    }

    func moveTo(destination:Tile) {
        if let currentPosition = self.tile {
            if destination != currentPosition {
                removeAction(forKey: "Run")

                let path = getPath(start:currentPosition.point, goal:destination.point)

                if !path.isEmpty {
                    self.run(runningActionSequence(path:path), withKey: "Run")
                }
                
            }
        }
    }

    func runningActionSequence(path:[Point]) -> SKAction {

        //Run or Walk ?
        var speed:CGFloat = path.count > 3 ? 300 : 100

        //If not main character
        if(name != "main") {
            speed /= 2
        }

        //Draw GlobalPathLine
        let globalPathLine = CGMutablePath()


        let tshape = CGMutablePath()
        tshape.move(to: CGPoint(x:position.x-CGFloat(tileHalfWidth), y:position.y))
        tshape.addLine(to: CGPoint(x:position.x, y:position.y-CGFloat(tileHalfHeight)))
        tshape.addLine(to: CGPoint(x:position.x+CGFloat(tileHalfWidth), y:position.y))
        tshape.addLine(to: CGPoint(x:position.x, y:position.y+CGFloat(tileHalfHeight)))
        tshape.closeSubpath()
        globalPathLine.addPath(tshape)

        globalPathLine.move(to: position)

        //Points left for each point
        var pathRemaining = path

        var sequencedAction = [SKAction]()

        //lastPoint is actual position
        var lastPoint = position

        for point in pathRemaining {

            let sequencedPathLine = CGMutablePath()
            sequencedPathLine.move(to: lastPoint)

            if let tile = point.tile, let nextPoint = tile.positionInCamera {



                globalPathLine.addLine(to: nextPoint)
                sequencedPathLine.addLine(to: nextPoint)

                pathRemaining.removeFirst()

                let action = SKAction.follow(sequencedPathLine, asOffset: false, orientToPath : false, speed: speed)

                let check = SKAction.checkPath(path: pathRemaining, duration: action.duration)

                sequencedAction += [SKAction.group([action, check])]

                lastPoint = nextPoint
            }
            
        }

        //add ending tileShape to globalPathLine
        let tileShape = CGMutablePath()
        tileShape.move(to: CGPoint(x:lastPoint.x-CGFloat(tileHalfWidth), y:lastPoint.y))
        tileShape.addLine(to: CGPoint(x:lastPoint.x, y:lastPoint.y-CGFloat(tileHalfHeight)))
        tileShape.addLine(to: CGPoint(x:lastPoint.x+CGFloat(tileHalfWidth), y:lastPoint.y))
        tileShape.addLine(to: CGPoint(x:lastPoint.x, y:lastPoint.y+CGFloat(tileHalfHeight)))
        tileShape.closeSubpath()

        globalPathLine.addPath(tileShape)

        //Turn globalPathLine into Node
        let nameShape = "\(self.name!)1"
        firstCam.childNode(withName:nameShape)?.removeFromParent()
        let shape = SKShapeNode(path: globalPathLine)
        shape.name = nameShape
        shape.zPosition = 100
        firstCam.addChild(shape)

        return SKAction.sequence(sequencedAction)
    }

}

//Customized Animation
extension SKAction {

    open class func dig(tile:SKNode, duration:TimeInterval) -> SKAction {

        return SKAction.customAction(withDuration: duration, actionBlock: { (n:SKNode, i:CGFloat) in
            if let t = tile as? Tile {
                if i >= CGFloat(duration) {

                    t.setTo(newType: .water)
                }
            }
        })
    }

    open class func checkPath(path:Any, duration:TimeInterval) -> SKAction {

        let refreshInterval:CGFloat = 0.1

        var lastUpdate:CGFloat = 0
        return SKAction.customAction(withDuration: duration, actionBlock: { (n:SKNode, i:CGFloat) in

            let refreshTime = i - lastUpdate
            if refreshTime > refreshInterval {

                let tiles = path as! [Point]
                let error = tiles.filter({ !($0.tile?.type.walkable)! }) as [Point]
                if !error.isEmpty {
                    let node = n as! characterMovable
                    node.removeAction(forKey: "Run")
                    node.moveTo(destination: tiles.last!.tile!)
                }

                lastUpdate = i

            }

        })
    }
    
}


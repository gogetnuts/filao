//
//  TileClass.swift
//  Filao
//
//  Created by Ben on 30/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit
import GameplayKit


class Tile:SKNode {
    var parentGrid:Grid? {
        if let layer = self.parent as? Layer {
            return layer.grid
        } ; return nil
    }
    var point:Point
    var type:tileType

    let text:SKLabelNode

    let level0:SKSpriteNode
    var level1:Object?

    var bound = SKNode()
    var bitMask:UInt32 = 1 


    var walkable:Bool {
        return type.walkable && level1 == nil
    }
    //var shape:SKShapeNode

    var positionInCamera:CGPoint? {
        if let parent = self.parent {
            return firstCam.convert(self.position, from:parent)
        } else {
            return nil
        }
    }

    init(coo:(x:Int, y:Int)) {
        point = Point(coo.x, coo.y)
        type = tileType()

        text = SKLabelNode(text: "")
        text.fontSize = CGFloat(16)
        text.fontName = "Lucida Grande"
        text.zPosition = 100000

        level0 = SKSpriteNode(texture: type.texture)
        level0.color = NSColor.black
        level0.name = "level0"



        if coo == (2,2) || coo == (4,4) || coo == (0,4) {
            level1 = Object()
            let texture = SKTexture(image: #imageLiteral(resourceName: "Tree_Iso"))
            level1?.texture = texture
            level1?.size = texture.size()
            level1?.color = NSColor.black
            level1?.name = "level1"
            level1?.anchorPoint = CGPoint(x:0.5,y:0)
            level1?.position.y -= CGFloat(tileHalfHeight)
        }


        bound.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:-10, y: -5), to:CGPoint(x: 10, y: -5))
        bound.physicsBody?.restitution = 0.5

        super.init()

        addChild(level0)
        if(level1 != nil) {
            addChild(level1!)
        }

    }

    func addPhysics() {
        if !(children.contains(bound)) && physicsBody == nil {

            physicsBody = SKPhysicsBody(circleOfRadius: 5)
            physicsBody?.isDynamic = true
            physicsBody?.categoryBitMask = UInt32(1 << 31)
            physicsBody?.allowsRotation = false
            physicsBody?.collisionBitMask = bitMask

            addChild(bound)

        }
    }
    func removePhysics() {
        if children.contains(bound) && physicsBody != nil {
            physicsBody = nil
            bound.removeFromParent()
        }
    }

    func riseUp() {
        position.y += 5
        parentGrid?.updateBitmap = true
    }

    func calcHumidity() {

        var hScore = 0

        for points in point.area {
            if let neighbor = points.tile {
                hScore += neighbor.type.humidity
            }
        }
        
        let newHumidity = hScore / 8
        let maxHumidity = 85.0
        let maxcolorBFactorDif = 0.3

        if newHumidity != self.type.humidity && newHumidity >= self.type.humidity + 2  {

            let colorBFac = CGFloat((maxcolorBFactorDif / maxHumidity) * Double(newHumidity))

            //removeAction(forKey: "Humidity")

            //level0.run(SKAction.colorize(withColorBlendFactor: colorBFac, duration: 0), withKey: "Humidity")
            level0.colorBlendFactor = colorBFac

            parentGrid?.updateBitmap = true

            type.humidity = newHumidity

            if newHumidity > 83 {
                //setTo(newType: .water)
            }

        }

    }

    func growGrass() {

    }

    func setTo (newType:Elements) {
        switch(newType) {
        case .water :
            type.age = globalTime

            type.element = .water

            level0.texture = type.texture
            level0.size = type.texture.size()
            level0.colorBlendFactor = 0

            type.humidity = 100
            text.text = "100"


            level1?.texture = nil
            level1?.size = CGSize(width: 0, height: 0)
            level1?.removeFromParent()

            parentGrid?.updateBitmap = true


        default :
            break

        }

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func raiseWater() {
    for (_, tile) in tileTable.filter({ $1.type.element == .earth }) {

        tile.calcHumidity()
        //tile.growGrass()

    }
}

//Customized Animation
extension SKAction {
    open class func changeHumidity(duration:TimeInterval, value:Int) -> SKAction {
        var firstTime:Bool = true
        var humidity:Int = 0
        print("animation for :\(value) for \(self)")
        return SKAction.customAction(withDuration: duration, actionBlock: { (n:SKNode, i:CGFloat) in
            if let tile = n as? Tile {


                if firstTime {
                    humidity = tile.type.humidity
                    firstTime = false
                }

                let ok =  Int(round(CGFloat(humidity) + CGFloat(value-humidity)*(i/CGFloat(duration))))
                tile.text.text = ok.description
                tile.type.humidity = ok

            }

        })
    }

}


enum Elements {
    case earth
    case water
    case air
    case fire
}

struct tileType {
    var element:Elements = Elements.earth
    var humidity:Int = 0
    var growable:Int = 0
    var walkable:Bool {
        return element == .earth ? true : false
    }



    var texture:SKTexture {
        switch element {
        case .water:
            return SKTexture(image: #imageLiteral(resourceName: "Water_Iso_Center"))
        default:
            return SKTexture(image: #imageLiteral(resourceName: "grass-1"))
        }
    }
    var crossable:Bool = false
    var age:TimeInterval = 0

    init () {
        
    }
}

class Object:SKSpriteNode {


    init() {
        super.init(texture: nil, color: NSColor.black, size: CGSize(width: 0, height: 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




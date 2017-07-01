//
//  newTileClass.swift
//  Filao
//
//  Created by Ben on 30/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit
import GameplayKit



class newTile:SKShapeNode {
    var point:Point
    var type:tileType
    let text:SKLabelNode
    let level1 = Object()
    var bound = SKNode()
    var bitMask:UInt32 = 1
    let level0:SKSpriteNode
    var shape:SKShapeNode

    var positionInCamera:CGPoint {
        return firstCam.convert(self.position, from:self.parent!)
    }

    init(coo:(x:Int, y:Int)) {
        point = Point(coo.x, coo.y)
        type = tileType()

        text = SKLabelNode(text: "")
        text.fontSize = CGFloat(16)
        text.fontName = "Lucida Grande"
        text.zPosition = 2

        level0 = SKSpriteNode(texture: type.texture)
        level0.color = NSColor.black
        level0.name = "level0"
        level0.zPosition = -1

        bound.physicsBody = SKPhysicsBody (edgeFrom: CGPoint(x:-10, y: -5), to:CGPoint(x: 10, y: -5))
        bound.physicsBody?.restitution = 0.5
        
        shape = SKShapeNode(path: tileShape)
        //shape.lineWidth = 0
        super.init()

        addChild(level0)

        path = tileShape
        fillColor = SKColor.clear
        strokeColor = SKColor.clear
        //zPosition = 100000
        //lineWidth = 0

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

    func calcHumidity() {

        var hScore = 0

        for points in point.area {
            if let neighbor = points.newtile {
                hScore += neighbor.type.humidity
            }
        }
        
        let newHumidity = hScore / 8
        let maxHumidity = 85.0
        let maxcolorBFactorDif = 0.3

        print(newHumidity)
        print(self.type.humidity)

        if newHumidity != self.type.humidity {

            let colorBFac = CGFloat((maxcolorBFactorDif / maxHumidity) * Double(newHumidity))

            removeAction(forKey: "Humidity")

            //level0.run(SKAction.colorize(withColorBlendFactor: colorBFac, duration: 0), withKey: "Humidity")
            level0.colorBlendFactor = colorBFac

            type.humidity = newHumidity

            if newHumidity > 83 {
                setTo(newType: .water)
            }

        }

    }

    func growGrass() {
        if(type.element == .earth) {
            if(type.humidity > 10) {
                let texture = SKTexture(image: #imageLiteral(resourceName: "grass1"))
                level1.texture = texture
                level1.size = texture.size()
            }
            if(type.humidity > 20) {
                let texture = SKTexture(image: #imageLiteral(resourceName: "grass2"))
                level1.texture = texture
                level1.size = texture.size()
            }
            if(type.humidity > 40) {
                let texture = SKTexture(image: #imageLiteral(resourceName: "grass3"))
                level1.texture = texture
                level1.size = texture.size()
            }
        }

        //level1.colorBlendFactor = colorBlendFactor - 0.03
    }

    func setTo (newType:Elements) {
        switch(newType) {
        case .water :
            type.age = globalTime

            type.element = .water

            let texture = type.texture

            removeAction(forKey: "Humidity")

            level0.run(SKAction.group([
                SKAction.colorize(withColorBlendFactor: 0, duration: 0),
                SKAction.setTexture(texture, resize: true),
                ]), withKey: "Humidity")

            type.humidity = 100


            level1.texture = nil
            level1.size = CGSize(width: 0, height: 0)
            level1.removeFromParent()


        default :
            break

        }

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func raiseWater() {
    for (_, tile) in newTileTable.filter({ $1.type.element == .earth }) {

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
            if let tile = n as? newTile {


                if firstTime {
                    humidity = tile.type.humidity
                    firstTime = false
                }

                let ok =  Int(round(CGFloat(humidity) + CGFloat(value-humidity)*(i/CGFloat(duration))))
                tile.text.text = ok.description
                tile.type.humidity = ok

                print("ok")

            }

        })
    }
    open class func dig(tile:SKNode, duration:TimeInterval) -> SKAction {

        return SKAction.customAction(withDuration: duration, actionBlock: { (n:SKNode, i:CGFloat) in
            if let t = tile as? newTile {
                if i >= CGFloat(duration) {

                    t.setTo(newType: .water)
                }
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
            return SKTexture(image: #imageLiteral(resourceName: "Sand_Iso_Center"))
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




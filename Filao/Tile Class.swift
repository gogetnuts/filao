import SpriteKit
import GameplayKit


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

var closedS:[Point] = []


class Object:SKSpriteNode {


    init() {
        super.init(texture: nil, color: NSColor.black, size: CGSize(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class Tile:SKSpriteNode {
    var grid:Point
    var type:tileType
    let text:SKLabelNode
    let level1 = Object()

    init(coo:(x:Int, y:Int)) {
        grid = Point(p: coo)
        type = tileType()
        
        text = SKLabelNode(text: "")
        text.fontSize = CGFloat(16)
        text.fontName = "Lucida Grande"

        super.init(texture: type.texture, color: NSColor.black, size: type.texture.size())

        physicsBody = SKPhysicsBody(circleOfRadius: 5)
        physicsBody?.categoryBitMask = UInt32(1 << 31)
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0
 
        //level1.zPosition = 2

    }

    func plant() {

    }



    func calcHumidity() {

        var hScore = 0

        for points in grid.area {
            if let tile = points.tile {
                hScore += tile.type.humidity
            }
        }

        let newHumidity = hScore / 8
        let maxHumidity = 85.0
        let maxcolorBFactorDif = 0.3

        if newHumidity != self.type.humidity {

            let colorBFac = CGFloat((maxcolorBFactorDif / maxHumidity) * Double(newHumidity))

            removeAction(forKey: "Humidity")

            run(SKAction.group([
                SKAction.colorize(withColorBlendFactor: colorBFac, duration: 0),
                SKAction.changeHumidity(duration: 0.001, value: newHumidity)
            ]), withKey: "Humidity")


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
        level1.colorBlendFactor = colorBlendFactor-0.03
    }

    func changeHumidity(to:Int) {
        type.humidity = to
        text.text = to.description
    }


    func setTo (newType:Elements) {
        switch(newType) {
        case .water :
            type.age = globalTime

            type.element = .water

            let texture = type.texture

            removeAction(forKey: "Humidity")

            run(SKAction.group([
                SKAction.colorize(withColorBlendFactor: 0, duration: 0),
                SKAction.setTexture(texture, resize: true),
                SKAction.changeHumidity(duration: 0.001, value: 100)
            ]), withKey: "Humidity")


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

func pointIsElementWater(_ p: Point) -> Bool { return p.tile?.type.element == .water }
func pointIsElementEarth(_ p: Point) -> Bool { return p.tile?.type.element == .earth }

func tileIsElementEarth(key: Point, value: Tile?) -> Bool { return value?.type.element == .earth }

func raiseWater() {
    for (_, tile) in tileTable.filter(tileIsElementEarth) {

        tile.calcHumidity()
        tile.growGrass()

    }
}



func myRand(max:Int) -> Int {
    let ok = GKRandomDistribution(lowestValue: 0, highestValue: max)
    return ok.nextInt()
}





extension SKAction {
    open class func changeHumidity(duration:TimeInterval, value:Int) -> SKAction {
        var firstTime:Bool = true
        var humidity:Int = 0

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


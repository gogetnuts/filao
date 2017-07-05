//
//  GameScene.swift
//  Test2
//
//  Created by Ben on 02/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit
import GameplayKit



var tileTable = [Point: Tile]()
var tileIndex = [Tile]();
let tileWidth = 120
let tileHeight = 60
let tileHalfHeight = tileHeight/2
let tileHalfWidth = tileWidth/2
let firstCam = SKCameraNode()
var mainCharacter = characterMovable()
let tileShape = CGMutablePath()

let tileDistanceToGround = 20
var globalTime : TimeInterval = 0


class GameScene: SKScene {

    //let tileSquare = CGMutablePath()


    var firstStart = true
    var lastUpdateTime : TimeInterval = 0
    var label : SKTileMapNode?

    var friend:characterMovable = characterMovable()

    override func sceneDidLoad() {



        if firstStart {
            //scNode?.physicsBody = nil
            tileShape.move(to: CGPoint(x:-tileWidth/2, y:0))
            tileShape.addLine(to: CGPoint(x:0, y:-tileHeight/2))
            tileShape.addLine(to: CGPoint(x:tileWidth/2, y:0))
            tileShape.addLine(to: CGPoint(x:0, y:tileHeight/2))
            tileShape.closeSubpath()

            firstCam.setScale(CGFloat(0.75))
           // firstCam.setScale(1)


            let newgrid1 = Grid(start: Point(0,0), line:20)

            let tilePerLine = newgrid1.nbTilePerLine //To make sure count is always right

            let newgrid2 = Grid(start: Point(0,tilePerLine), line:30)
            newgrid2.position.x += CGFloat(tileHalfWidth * tilePerLine)
            newgrid2.position.y -= CGFloat(tileHalfHeight * tilePerLine)

            let newgrid3 = Grid(start: Point(0,tilePerLine * 2), line:40)
            newgrid3.position.x += CGFloat(tileHalfWidth * tilePerLine * 2)
            newgrid3.position.y -= CGFloat(tileHalfHeight * tilePerLine * 2)

            let newgrid4 = Grid(start: Point(tilePerLine,0), line:10)
            newgrid4.position.x += CGFloat(tileHalfWidth * tilePerLine)
            newgrid4.position.y += CGFloat(tileHalfHeight * tilePerLine)

            let newgrid5 = Grid(start: Point(tilePerLine,tilePerLine), line:20)
            newgrid5.position.x += CGFloat(tileHalfWidth * tilePerLine * 2)

            let newgrid6 = Grid(start: Point(tilePerLine,tilePerLine * 2), line:30)
            newgrid6.position.x += CGFloat(tileHalfWidth * tilePerLine * 3)
            newgrid6.position.y -= CGFloat(tileHalfHeight * tilePerLine)

            addChild(firstCam)

            firstCam.addChild(newgrid1)
            firstCam.addChild(newgrid2)
            firstCam.addChild(newgrid3)
            firstCam.addChild(newgrid4)
            firstCam.addChild(newgrid5)
            firstCam.addChild(newgrid6)


            if let tile = tileTable[Point(3,3)], let position = tile.positionInCamera {
                mainCharacter.position = position
                mainCharacter.name = "main"
                firstCam.addChild(mainCharacter)
            }

            if let tile = tileTable[Point(2,2)], let position = tile.positionInCamera {
                friend.position = position
                friend.name = "friend"
                firstCam.addChild(friend)
            }

            //buiding tileIndex for random tile
            for (_, tile) in tileTable {
                tileIndex.append(tile)
            }

            //Centering camera on mainCharacter */
            firstCam.position.x = -mainCharacter.positionInScene.x
            firstCam.position.y = -mainCharacter.positionInScene.y

            firstStart = false


        }

    }

    func getTileAt(point: CGPoint) -> Tile? {
        //let tiles = self.nodes(at: point).filter ({ $0.isMember(of: Tile.self) }) as! [Tile]
        let grids = self.nodes(at: point).filter ({ $0.isMember(of: Grid.self) }) as! [Grid]
        //print("go")
        for grid in grids {
          //  print("grille : \(grid)")
            for eachchild in grid.layer0.children {
            //    print("child : \(eachchild)")
              //  print(convert(point, to: eachchild))
                if tileShape.contains(convert(point, to: eachchild)) {
                    return eachchild as? Tile
                }
            }
        }
        return nil
        /*for tile in tiles {
            if(tileShape.contains(convert(point, to: tile))) {
                return tile
            }
        }
        return nil*/
    }

    /*
    var lastTile:Tile?
    override func mouseDragged(with event: NSEvent) {

        if let tile = getTileAt(point:event.location(in: self)) {

            if lastTile != tile || lastTile == nil {

                lastTile = tile
                for tiles in tile.point.area {
                    tileTable[tiles]?.addPhysics()
                    tileTable[tiles]?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.3))
                }
                tile.addPhysics()
                tile.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.5))
            }
        }
    }
    // */


    /*
    override func didSimulatePhysics() {


        //print("did")

        for (_, tile) in tileTable.filter({ $1.physicsBody != nil }) {
            print("yo")
            if tile.physicsBody?.velocity.dy == 0 {
                tile.removePhysics()
            }
        }
        //
    }
    // */

    override func mouseDown(with event: NSEvent) {

        if let tile = getTileAt(point:event.location(in: self)) {
            print(tile.point)



             switch selectedAction.selectedSegment {
            case 0 :
                mainCharacter.digTo(destination: tile)
            case 1 :
                mainCharacter.moveTo(destination: tile)
            case 2 :
                tile.riseUp()
            default: break
            }

            //tile.addPhysics()
            //tile.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.5))
        }
    }

    override func keyDown(with event: NSEvent) {
        let code = event.keyCode
        print(code)

        //Space Bar is Pause Button for DayProgression
        if (event.keyCode == 49) {
            toolPause.state = toolPause.state == 0 ? 1 : 0
        }

        //Enter generate
        if (event.keyCode == 36) {
            let grids = firstCam.children.filter ({ $0.isMember(of: Grid.self) }) as! [Grid]
            for grid in grids {
                grid.setTextureMap()
            }
        }
        //Backspace delete
        if (event.keyCode == 51) {
            let grids = firstCam.children.filter ({ $0.isMember(of: Grid.self) }) as! [Grid]
            for grid in grids {
                grid.removeTextureMap()
            }
        }


        // Camera Movement
        var moveCamera = true

        var x = CGFloat(tileWidth/2) * firstCam.xScale
        var y = CGFloat(tileHeight/2) * firstCam.yScale

        switch (code) {
        case 126:
            x = -x
            y = -y
        case 123:
            y = -y
        case 124:
            x = -x
        case 125: break
        default: moveCamera = false
        }

        if moveCamera {
            firstCam.run(SKAction.moveBy(x: x, y: y, duration: 0.5))
        }

    }
    
    func generateRand(max:Int) -> Int {
        let ok = GKRandomDistribution(lowestValue: 0, highestValue: max)
        return ok.nextInt()
    }

    var dayLapse = 0
    var lastSunRise:TimeInterval = 0
    var timePause:TimeInterval = 0

    var lastRefresh:TimeInterval = 0
    var alt = true
    override func update(_ currentTime: TimeInterval) {

        let refreshTime = currentTime - lastRefresh
        if  refreshTime > 0.2 {

            lastRefresh = currentTime

            //If friend is lazy
            if !(friend.hasActions()) {
                
                let random = generateRand(max:tileIndex.count-1)
                friend.moveTo(destination: tileIndex[random])

                //From A to B in loop
                /*
                 if alt {
                    friend.moveTo(destination: tileTable[Point(1,8)]!)
                    alt = false
                } else {
                    friend.moveTo(destination: tileTable[Point(0,0)]!)
                    alt = true
                }
                // */
                // */
            }
            // */

            let grids = firstCam.children.filter({ $0.isKind(of: Grid.self)}) as! [Grid]
            let gridToUpdate = grids.filter({ $0.updateBitmap })

            for grid in gridToUpdate {
                print("Updating on demand Grid \(grid.origin.x,grid.origin.y) at \(currentTime)")
                grid.removeTextureMap()
                grid.setTextureMap()
                
            }
            // */

            /*
            //Performance test

            let ok = getPath(start: Point(0,0), goal: Point(4,8))
            let ok2 = getPath(start: Point(4,8), goal: Point(0,0))
            let ok3 = getPath(start: Point(0,0), goal: Point(1,8))
            let ok4 = getPath(start: Point(1,8), goal: Point(0,0))
            // */

            if toolPause.state == 0 {

                if lastSunRise == 0 { lastSunRise = currentTime }

                let timePerDay = toolStep.doubleValue

                if timePause != 0 {
                    lastSunRise += (currentTime - timePause)
                    timePause = 0
                }

                let dayProgression = (currentTime - lastSunRise) * 100 / timePerDay

                dayProgressionBar.doubleValue = dayProgression

                if dayProgression >= 100 {
                    dayLapse += 1
                    toolChamp.stringValue = dayLapse.description

                    lastSunRise = currentTime
                    raiseWater()
                }
                
            } else {
                if timePause == 0 && lastSunRise != 0 { timePause = currentTime }
            }
            
        }

    }
    
}





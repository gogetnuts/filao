//
//  GameScene.swift
//  Test2
//
//  Created by Ben on 02/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit



var tileTable = [Point: Tile]();
let tileWidth = 120
let tileHeight = 60
let firstCam = SKCameraNode()


let tileDistanceToGround = 20
var globalTime : TimeInterval = 0


class GameScene: SKScene {

    var firstStart = true
    private var lastUpdateTime : TimeInterval = 0
    let timerLabel = SKLabelNode ()


    override func sceneDidLoad() {


        if firstStart {

            timerLabel.fontName = "Arial"
            timerLabel.fontSize = 20

            //self.anchorPoint = CGPoint(x:0, y:0)
            self.addChild(timerLabel)

            //print(self.size)
            self.addChild(firstCam)
            firstCam.setScale(CGFloat(0.75))

            let grid = Grid(start: Point(p:(0,0)), line:0)
            firstCam.addChild(grid)
            gridTable.updateValue(Point(p:(0,0)), forKey: grid)

            let grid2 = Grid(start: Point(p:(tilePerLine,tilePerLine)), line:0)
            firstCam.addChild(grid2)
            grid2.position.x += CGFloat(tileWidth * tilePerLine)
            gridTable.updateValue(Point(p:(tilePerLine,tilePerLine)), forKey: grid)

            let grid3 = Grid(start: Point(p:(-gridLines/2,gridLines/2)), line:1)
            grid3.position.y -= CGFloat(tileHeight/2 * gridLines)
            firstCam.addChild(grid3)

            let grid4 = Grid(start: Point(p:(-gridLines/2 + tilePerLine,gridLines/2 + tilePerLine)), line:1)
            grid4.position.y -= CGFloat(tileHeight/2 * gridLines)
            grid4.position.x += CGFloat(tileWidth * tilePerLine)
            firstCam.addChild(grid4)

            //gridTable.updateValue(Point(p:(-5,5)), forKey: grid3)

        }

        firstStart = firstStart ? false : true

    }

    var lastTile:Tile?
    override func mouseDragged(with event: NSEvent) {

        if let tile = getTileAt(pos:event.location(in: self)) {
            if lastTile != tile || lastTile == nil {

                lastTile = tile
                for tiles in tile.grid.area {
                    tileTable[tiles]?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.5))
                }
                tile.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.4))
            }
        }
    }

    var lastTileClicked:Tile?
    override func mouseDown(with event: NSEvent) {


        if let tile = getTileAt(pos:event.location(in: self)) {
            print("pokeball go")


            if (lastTileClicked == nil) {
                lastTileClicked = tile
            } else {
                bestWay(from:(lastTileClicked?.grid)!, to: tile.grid)
            }

            lastTileClicked = tile
            tile.setTo(newType: .water)

        }
    }

    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        let code = event.keyCode

        var x = CGFloat(tileWidth/2) * firstCam.xScale
        var y = CGFloat(tileHeight/2) * firstCam.yScale
        var go = true

        switch (code) {
        case 126:
            x = -x
            y = -y
        case 123:
            y = -y
        case 124:
            x = -x
        case 125: break
        default: go = false
        }

        if go {
            firstCam.run(SKAction.moveBy(x: x, y: y, duration: 0.5))

            //for grid in gridTable {
            //  print(firstCam.contains(grid.key))
            // }

        }

        if (event.keyCode == 24) {
            firstCam.xScale += 0.1
            firstCam.yScale += 0.1
        }
        if (event.keyCode == 49) {
            toolPause.state = toolPause.state == 0 ? 1 : 0
        }
        if (event.keyCode == 44) {
            if (firstCam.xScale > 0.2 && firstCam.yScale > 0.2) {
                firstCam.xScale -= 0.1
                firstCam.yScale -= 0.1
            }
        }
    }

    func getTileAt(pos: CGPoint) -> Tile? {
        let nodesAtPos = nodes(at: pos)


        for node in nodesAtPos {
            if let n = node as? Tile {

                let p = convert(pos, to: n)

                let tileSquare = CGMutablePath()
                //print(n.anchorPoint.)
                tileSquare.move(to: CGPoint(x:-tileWidth/2, y:0))
                tileSquare.addLine(to: CGPoint(x:0, y:-tileHeight/2))
                tileSquare.addLine(to: CGPoint(x:tileWidth/2, y:0))
                tileSquare.addLine(to: CGPoint(x:0, y:tileHeight/2))
                tileSquare.closeSubpath()


                if(tileSquare.contains(p)) {
                    return n
                }
            }
        }
        return nil
    }



    var dayLapse = 0
    var lastSunRise:TimeInterval = 0
    var timePause:TimeInterval = 0
    var timePerDay = 2.0
    var filterHumidity:Int = toolFilterHumidity.state
    var filterLevel1:Int = toolFilterLevel1.state
    var filterPhysics:Int = toolPhysics.state
    override func update(_ currentTime: TimeInterval) {
        if lastSunRise == 0 { lastSunRise = currentTime }

        if toolPause.state == 0 {

            timePerDay = toolStep.doubleValue

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
            if timePause == 0 { timePause = currentTime }
        }

        //Humidity TOGGLE

        if toolFilterHumidity.state == 0 {
            if filterHumidity == 1 {
                for (_, tile) in tileTable {
                    tile.text.removeFromParent()
                }
                filterHumidity = 0
            }
        } else {
            if filterHumidity == 0 {
                for (_, tile) in tileTable {
                    //for (_, tile) in tileTable.filter({ ($1?.type.humidity)! > 0 }) {
                    tile.addChild(tile.text)
                }
                filterHumidity = 1
            }

        }

        //Level1 TOGGLE

        if toolFilterLevel1.state == 0 {
            if filterLevel1 == 1 {
                for (_, tile) in tileTable {
                    tile.level1.removeFromParent()
                }
                filterLevel1 = 0
            }
        } else {
            if filterLevel1 == 0 {
                for (_, tile) in tileTable {
                    //for (_, tile) in tileTable.filter({ $1?.level1.texture != nil }) {
                    tile.addChild(tile.level1)
                }
                filterLevel1 = 1
            }
            
        }
        
        //Physics TOGGLE
        
        if toolPhysics.state == 0 {
            if filterPhysics == 1 {
                self.scene?.view?.showsPhysics = false
                filterPhysics = 0
            }
        } else {
            if filterPhysics == 0 {
                self.scene?.view?.showsPhysics = true
                filterPhysics = 1
            }
            
        }
    }
    
}





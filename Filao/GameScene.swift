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
    var lastUpdateTime : TimeInterval = 0

    override func sceneDidLoad() {

        if firstStart {

            firstCam.setScale(CGFloat(0.75))

            let grid1 = Grid(start: Point(p:(0,0)), line:0)

            let tilePerLine = grid1.nbTilePerLine
            let gridLines = grid1.nbLines

            let grid2 = Grid(start: Point(p:(tilePerLine,tilePerLine)), line:0)
            grid2.position.x += CGFloat(tileWidth * tilePerLine)

            let grid3 = Grid(start: Point(p:(-gridLines/2,gridLines/2)), line:1)
            grid3.position.y -= CGFloat(tileHeight/2 * gridLines)

            let grid4 = Grid(start: Point(p:(-gridLines/2 + tilePerLine,gridLines/2 + tilePerLine)), line:1)
            grid4.position.y -= CGFloat(tileHeight/2 * gridLines)
            grid4.position.x += CGFloat(tileWidth * tilePerLine)

            addChild(firstCam)

            firstCam.addChild(grid1)
            firstCam.addChild(grid2)
            firstCam.addChild(grid3)
            firstCam.addChild(grid4)

            firstStart = false
        }

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

    var lastTileClicked = Tile(coo:(0,0))
    override func mouseDown(with event: NSEvent) {

        if let tile = getTileAt(pos:event.location(in: self)) {

            var path = getPath(start:lastTileClicked.grid, goal:tile.grid)

            while !path.isEmpty {
                let nextPoint = path.removeFirst()
                nextPoint.tile?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
            }

            lastTileClicked = tile

            //Turn tile into water for testing other features
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

        let tileSquare = CGMutablePath()
        tileSquare.move(to: CGPoint(x:-tileWidth/2, y:0))
        tileSquare.addLine(to: CGPoint(x:0, y:-tileHeight/2))
        tileSquare.addLine(to: CGPoint(x:tileWidth/2, y:0))
        tileSquare.addLine(to: CGPoint(x:0, y:tileHeight/2))
        tileSquare.closeSubpath()


        for node in nodesAtPos {
            if let n = node as? Tile {

                let p = convert(pos, to: n)

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





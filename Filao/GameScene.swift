//
//  GameScene.swift
//  Test2
//
//  Created by Ben on 02/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit
import GameplayKit



var tileTable = [Point: newTile]()
var newTileTable = [Point: newTile]()
var tileIndex = [newTile]();
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

        //chara

        if firstStart {

            tileShape.move(to: CGPoint(x:-tileWidth/2, y:0))
            tileShape.addLine(to: CGPoint(x:0, y:-tileHeight/2))
            tileShape.addLine(to: CGPoint(x:tileWidth/2, y:0))
            tileShape.addLine(to: CGPoint(x:0, y:tileHeight/2))
            tileShape.closeSubpath()

            firstCam.setScale(CGFloat(0.75))




            let newgrid1 = newGrid(start: Point(0,0), line:20)

            let tilePerLine = newgrid1.nbTilePerLine //To make sure count is always right

            let newgrid2 = newGrid(start: Point(0,tilePerLine), line:30)
            newgrid2.position.x += CGFloat(tileHalfWidth * tilePerLine)
            newgrid2.position.y -= CGFloat(tileHalfHeight * tilePerLine)

            let newgrid3 = newGrid(start: Point(0,tilePerLine * 2), line:40)
            newgrid3.position.x += CGFloat(tileHalfWidth * tilePerLine * 2)
            newgrid3.position.y -= CGFloat(tileHalfHeight * tilePerLine * 2)

            let newgrid4 = newGrid(start: Point(tilePerLine,0), line:10)
            newgrid4.position.x += CGFloat(tileHalfWidth * tilePerLine)
            newgrid4.position.y += CGFloat(tileHalfHeight * tilePerLine)

            let newgrid5 = newGrid(start: Point(tilePerLine,tilePerLine), line:20)
            newgrid5.position.x += CGFloat(tileHalfWidth * tilePerLine * 2)

            let newgrid6 = newGrid(start: Point(tilePerLine,tilePerLine * 2), line:30)
            newgrid6.position.x += CGFloat(tileHalfWidth * tilePerLine * 3)
            newgrid6.position.y -= CGFloat(tileHalfHeight * tilePerLine)




            addChild(firstCam)

            firstCam.addChild(newgrid1)
            firstCam.addChild(newgrid2)
            firstCam.addChild(newgrid3)
            firstCam.addChild(newgrid4)
            firstCam.addChild(newgrid5)
            firstCam.addChild(newgrid6)

            print(newgrid1.zPosition)


            if let tile = newTileTable[Point(3,3)] {
                mainCharacter.position = tile.positionInCamera
                firstCam.addChild(mainCharacter)
            }

            if let tile = newTileTable[Point(2,2)] {
                friend.position = tile.positionInCamera
                firstCam.addChild(friend)
            }

            //buiding tileIndex for random tile
            for (_, tile) in newTileTable {
                tileIndex.append(tile)
            }

            //Centering camera on mainCharacter */
            //firstCam.position.x = -mainCharacter.positionInScene.x
            //firstCam.position.y = -mainCharacter.positionInScene.y

            firstStart = false


        }

    }
/*
    func getTileAt(point: CGPoint) -> Tile? {
        let tiles = self.nodes(at: point).filter ({ $0.isMember(of: Tile.self) }) as! [Tile]
        for tile in tiles {
            if(tileShape.contains(convert(point, to: tile))) {
                return tile
            }
        }
        return nil
    }
    */
    func getNewTileAt(point: CGPoint) -> newTile? {
        let tiles = self.nodes(at: point).filter ({ $0.isMember(of: newTile.self) }) as! [newTile]
        for tile in tiles {
            if(tileShape.contains(convert(point, to: tile))) {
                return tile
            }
        }
        return nil
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
    }*/

    override func didSimulatePhysics() {
        /*for (_, tile) in tileTable.filter({ $1.physicsBody != nil }) {
            if tile.physicsBody?.velocity.dy == 0 {
                tile.removePhysics()
            }
        }*/
    }


    override func mouseDown(with event: NSEvent) {
        if let tile = getNewTileAt(point:event.location(in: self)) {
            print(tile.point)
            mainCharacter.makeRunTo(tile: tile)
        }

        /*
         let texture:SKTexture? = self.view?.texture(from: Grid(start: Point(0,0), line:0))
        let node = SKSpriteNode(texture: texture)
        node.position.x = 400
        print(superView)
        self.addChild(node)
        */
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
            let grids = firstCam.children.filter ({ $0.isMember(of: newGrid.self) }) as! [newGrid]
            for grid in grids {
                grid.setTextureMap()
            }
        }
        //Backspace delete
        if (event.keyCode == 51) {
            let grids = firstCam.children.filter ({ $0.isMember(of: newGrid.self) }) as! [newGrid]
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
    override func update(_ currentTime: TimeInterval) {

        let refreshTime = currentTime - lastRefresh
        if  refreshTime > 1 {

            lastRefresh = currentTime

            //If our friend is lazy, send him somewhere randomly

            if !(friend.hasActions()) {
                let random = generateRand(max:tileIndex.count-1)
                friend.moveTo(tile: tileIndex[random])
            }
            // */

            /*
            //Performance test

            let ok = getPath(start: Point(0,0), goal: Point(4,8))
            let ok2 = getPath(start: Point(4,8), goal: Point(0,0))
            let ok3 = getPath(start: Point(0,0), goal: Point(1,8))
            let ok4 = getPath(start: Point(1,8), goal: Point(0,0))
            // */
            /*
            let grid1 = Grid(start: Point(0,0), line:0)
            let tilePerLine = grid1.nbTilePerLine

            firstCam.childNode(withName: "grid1")?.removeFromParent()
            var texture:SKTexture? = compileTexture(node: grid1)
            var node = SKSpriteNode(texture: texture)
            node.position.x -= CGFloat(tileWidth/2)
            node.position.y += CGFloat(tileHeight/2)
            node.anchorPoint = CGPoint(x:0,y:1)
            node.size = CGSize(width: 540, height: 330)
            node.name = "grid1"

            firstCam.addChild(node)
            
            firstCam.childNode(withName: "grid2")?.removeFromParent()
            texture = compileTexture(node: Grid(start: Point(tilePerLine,tilePerLine), line:0))
            node = SKSpriteNode(texture: texture)
            node.position.x += CGFloat(tileWidth * tilePerLine)
            node.position.x -= CGFloat(tileWidth/2)
            node.position.y += CGFloat(tileHeight/2)
            node.anchorPoint = CGPoint(x:0,y:1)
            node.size = CGSize(width: 540, height: 330)
            node.name = "grid2"

            firstCam.addChild(node)

            */
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





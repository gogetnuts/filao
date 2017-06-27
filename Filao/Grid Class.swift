import SpriteKit

class Grid : SKNode {
    var line:Int

    let nbTilePerLine = 4
    let nbLines = 8

    init(start:Point, line:Int) {
            self.line = line
            super.init()

            var incremX = 0
            var incremY = 0

            let startX = -650
            let startY = 350

            var y = 0

            let nbTileTotal = nbTilePerLine * nbLines

            /* Draw Grid loop */
            for i:Int in 0 ..< nbTileTotal {

                let x = i%nbTilePerLine
                let lineStart = x == 0 ? true : false

                y = lineStart && i != 0 ? y + 1 : y

                let linePair = y % 2 == 0

                /* code provisoire */
                if (!linePair && lineStart) {
                    incremY += 1
                } else if(linePair && y != 0 && lineStart) {
                    incremX += 1
                }
                let cooX = x - incremX + start.x
                let cooY = x + incremY + start.y

                let tile = Tile(coo: (cooX,cooY))

                tile.physicsBody?.collisionBitMask = UInt32(1 << y)

                let posX = linePair ? startX + x * tileWidth : startX + x * tileWidth + tileWidth / 2
                let posY = startY - y * tileHeight / 2

                tile.zPosition = CGFloat(y + line*nbLines)

                tile.position = CGPoint(x: posX, y: posY)

                if lineStart {
                    let ground = SKNode()
                    ground.physicsBody = SKPhysicsBody(
                        edgeFrom: CGPoint(x:startX - 50, y: posY-tileDistanceToGround),
                        to:CGPoint(x:startX + nbTilePerLine * tileWidth, y: posY-tileDistanceToGround)
                    )
                    ground.physicsBody?.categoryBitMask = UInt32(1 << y)
                    ground.physicsBody?.restitution = 0.5
                    self.addChild(ground)
                }
                self.addChild(tile)
                tileTable.updateValue(tile, forKey: tile.grid)
            }



    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

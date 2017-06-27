//
//  Path Finding.swift
//  Source
//
//  Created by Ben on 23/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit
/** PATH FINDING FUNC **/

func buildUp(path:[Point:Point], to:Point) -> [Point] {
    var total_path = [to]
    var current = to
    while path.keys.contains(current) {
        current = path[current]!
        total_path.append(current)
    }
    total_path.reverse()
    return total_path
}

func getBestPath (start:Point, goal:Point) -> [Point] {

    var closedSet = [Point]()
    var openSet = [start]
    var gScore = [start:0]
    var fScore = [Point:Int]()
    var cameFrom = [Point:Point]()

    while !openSet.isEmpty {
        openSet = openSet.sorted(by: { fScore[$0]! < fScore [$1]! })

        let current = openSet.removeFirst()

        if current == goal {
            return buildUp(path: cameFrom, to: current)
        }

        closedSet.append(current)

        for neighbor in current.area {

            if closedSet.contains(neighbor) { continue }

            if !neighbor.isWalkable {
                closedSet += [neighbor]
                continue
            }

            if !(openSet.contains (neighbor)) { openSet += [neighbor] }

            let tentative_gScore = gScore[current]! + neighbor.distanceTo(p:current)

            if let gScoreNeighbor = gScore[neighbor] {
                if tentative_gScore >= gScoreNeighbor {
                    continue
                }
            }

            cameFrom[neighbor] = current
            gScore[neighbor] = tentative_gScore
            fScore[neighbor] = tentative_gScore + neighbor.distanceTo(p:goal)
        }

    }
    return openSet
}

func bestWay(from:Point, to:Point) {
    var myway = getBestPath(start:from, goal:to)

    while !myway.isEmpty {
        let goto = myway.removeFirst()

        if let tile = tileTable[goto] {
            tile.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
        }
        
    }
}

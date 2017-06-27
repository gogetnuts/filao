//
//  Path Finding.swift
//  Source
//
//  Created by Ben on 23/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//


func constructPath (array:[Point:Point], from:Point) -> [Point] {
    var total_path = [from]
    var current = from
    while array.keys.contains(current) {
        current = array[current]!
        total_path += [current]
    }
    total_path.reverse()
    return total_path
}

func getPath (start:Point, goal:Point) -> [Point] {

    var closedSet = [Point]()
    var openSet = [start]
    var gScore = [start:0]
    var fScore = [Point:Int]()
    var cameFrom = [Point:Point]()

    while !openSet.isEmpty {
        openSet = openSet.sorted(by: { fScore[$0]! < fScore [$1]! })

        let current = openSet.removeFirst()

        if current == goal {
            return constructPath(array: cameFrom, from: current)
        }

        closedSet += [current]

        for neighbor in current.area {

            if closedSet.contains(neighbor) {
                continue
            }

            if !neighbor.isWalkable {
                closedSet += [neighbor]
                continue
            }

            if !(openSet.contains (neighbor)) {
                openSet += [neighbor]
            }

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
    return []
}



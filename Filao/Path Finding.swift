
//Return array of points to reach point from point
func getPath (start:Point, goal:Point) -> [Point] {
    var i = 0

    if !goal.isWalkable {
        print("waste avoided")
        return []
    }

    var closedSet = [Point]()

    var openSet = [start]

    //var openSetFromGoal = [goal]

    var gScore = [start:0]

    var fScore = [Point:Int]()

    var cameFrom = [Point:Point]()

    //var fromEnd = false
    while !openSet.isEmpty {

        i += 1


        //Order points to evaluate by closest distance to goal
        openSet = openSet.sorted(by: { fScore[$0]! < fScore [$1]! })

        //openSetFromGoal = openSetFromGoal.sorted(by: { fScore[$0]! < fScore [$1]! })


        //let current = fromEnd ? openSetFromGoal.removeFirst() : openSet.removeFirst()
        let current = openSet.removeFirst()

        //fromEnd = fromEnd ? false : true


        if current == goal {
            return constructPath(array: cameFrom, from: current)
        }


        closedSet += [current]

        //.filter({ if let ok = $0.tile?.type.walkable { return ok } else { return false }})
        for neighbor in current.directArea {


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

            let tentative_gScore = gScore[current]! + neighbor.distanceTo(current)

            if let gScoreNeighbor = gScore[neighbor] {
                if tentative_gScore >= gScoreNeighbor {
                    continue
                }
            }

            cameFrom[neighbor] = current

            gScore[neighbor] = tentative_gScore

            fScore[neighbor] = tentative_gScore + neighbor.distanceTo(goal)
        }
        
    }
    print("An wasted loop of \(i)")
    return []
}


func constructPath (array:[Point:Point], from:Point) -> [Point] {

    var total_path = [from]

    var current = from

    while array.keys.contains(current) {
        current = array[current]!
        total_path += [current]
    }

    total_path.reverse()
    total_path.removeFirst() //remove start point
    return total_path
}




//Return array of points to reach goal point from start point
func getPath (start:Point, goal:Point) -> [Point] {

    //Already evaluated points
    var closedSet = [Point]()


    //Points to evaluate
    var openSet = [start]

    //Distance from start to point 
    //start to start = 0
    var gScore = [start:0]

    //Distance from start to goal passing by point
    var fScore = [Point:Int]()

    //For each point, the best point to reach it
    var cameFrom = [Point:Point]()

    //Loop as long as there is points to evaluate
    while !openSet.isEmpty {

        //Order points to evaluate by closest distance to goal
        openSet = openSet.sorted(by: { fScore[$0]! < fScore [$1]! })

        //Define current point and remove it from array of points to evaluate
        //Point is supposed to be the shortest to goal
        let current = openSet.removeFirst()

        //If current point is goal
        if current == goal {
            return constructPath(array: cameFrom, from: current)
        }

        //Add current point to evaluated points
        closedSet += [current]

        //For each neighbor in area of current point
        //area include 8 points : top, bottom, left, right, topright, topleft, bottomright, bottomleft
        for neighbor in current.directArea {

            //Ignore neighbor already evaluated
            if closedSet.contains(neighbor) {
                continue
            }

            //Ignore neighbor not walkable & add it to closedSet
            if !neighbor.isWalkable {
                closedSet += [neighbor]
                continue
            }

            //Add neighbor to future points to evaluate if not in list already
            if !(openSet.contains (neighbor)) {
                openSet += [neighbor]
            }

            //Distance from start to current neighbor
            let tentative_gScore = gScore[current]! + neighbor.distanceTo(current)


            if let gScoreNeighbor = gScore[neighbor] {
                if tentative_gScore >= gScoreNeighbor {
                    continue
                }
            }

            cameFrom[neighbor] = current

            //Record distance from start to current neighbor
            gScore[neighbor] = tentative_gScore

            //Record estimated distance from start to goal passing by current neighboor
            fScore[neighbor] = tentative_gScore + neighbor.distanceTo(goal)
        }
        
    }
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
    total_path.removeFirst() //remove start
    //total_path.removeLast() //remove goal
    return total_path
}



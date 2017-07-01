
//Defining structure of Point (x,y)
struct Point : Hashable {

    let x, y:Int

    //Coordinates of neighbors points : Top, Right, Left, Bottom and Top R, Top L, Bottom R, Bottom L
    var t:Point { return Point(x + 1, y - 1) }
    var r:Point { return Point(x + 1, y + 1) }
    var l:Point { return Point(x - 1, y - 1) }
    var b:Point { return Point(x - 1, y + 1) }
    var tr:Point { return Point(x + 1, y) }
    var tl:Point { return Point(x, y - 1) }
    var br:Point { return Point(x, y + 1) }
    var bl:Point { return Point(x - 1, y) }

    //Arrays of neighbors points
    var directArea:[Point] { return [tl, tr, bl, br] }
    var extendedArea:[Point] { return [t, r, b, l] }
    var area:[Point] { return [t, r, b, l, tl, tr, br, bl] }

    //Associated Tile?
    //var tile:Tile? { return tileTable[self] }

    //Associated Tile?
    var newtile:newTile? { return newTileTable[self] }

    //Associated Tile isWalkable?
    var isWalkable:Bool {
        if let t = newtile {
            return t.type.walkable
        } else {
            return false
        }
    }

    //Init Func
    init(_ x: Int, _ y: Int){
        self.x = x
        self.y = y
    }

    //Calculate distance from this point to another
    func distanceTo(_ point:Point) -> Int {
        return abs(point.x - x) + abs(point.y - y)
    }

    //Necessary to make it compatible with Hashable Protocol
    var hashValue: Int { return x.hashValue ^ y.hashValue }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

}

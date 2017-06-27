

struct Point : Hashable {

    let x, y:Int

    //Coordinates of neighbors points : Top, Right, Left, Bottom and Top R, Top L, Bottom R, Bottom L
    var t:Point { return Point(p:(x + 1, y - 1)) }
    var r:Point { return Point(p:(x + 1, y + 1)) }
    var l:Point { return Point(p:(x - 1, y - 1)) }
    var b:Point { return Point(p:(x - 1, y + 1)) }
    var tr:Point { return Point(p:(x + 1, y)) }
    var tl:Point { return Point(p:(x, y - 1)) }
    var br:Point { return Point(p:(x, y + 1)) }
    var bl:Point { return Point(p:(x - 1, y)) }

    //Array of neighbors points
    var directArea:[Point] { return [tl, tr, bl, br] }
    var extendedArea:[Point] { return [t, r, b, l] }
    var area:[Point] { return [t, r, b, l, tl, tr, br, bl] }

    //Associated Tile?
    var tile:Tile? { return tileTable[self] }

    //Associated Tile is Walkable ?
    var isWalkable:Bool {
        if let t = tile {
            return t.type.walkable
        } else {
            return false
        }
    }

    //Init Func
    init(p:(Int,Int)){
        (x, y) = p
    }

    //Calculate distance from this point to another
    func distanceTo(p:Point) -> Int {
        return abs(p.x - x) + abs(p.y - y)
    }

    //Necessary to make it compatible with Hashable Protocol
    var hashValue: Int { return x.hashValue ^ y.hashValue }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

}

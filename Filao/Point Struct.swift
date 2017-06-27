

struct Point : Hashable {

    //let coo:(x:Int,y:Int)
    let x, y:Int

    var directArea:[Point] {
        return [tl, tr, bl, br]
    }
    var extendedArea:[Point] {
        return [t, r, b, l]
    }
    var extendedDirectArea:[Point] {
        return [tl.tl, tr.tr, bl.bl, br.br]
    }
    var area:[Point] {
        return [tl, tr, bl, br, t, l, b, r]
    }
    var affectedArea:[Point] {
        return area+extendedDirectArea
    }


    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    var tile:Tile? {
        return tileTable[self]
    }
    var isWalkable:Bool {
        if let t = tile {
            return t.type.walkable
        } else {
            return false
        }
    }

    var tl:Point {return Point(p:(x, y - 1))}
    var br:Point {return Point(p:(x, y + 1))}
    var tr:Point {return Point(p:(x + 1, y))}
    var bl:Point {return Point(p:(x - 1, y))}
    var t:Point {return Point(p:(x + 1, y - 1))}
    var b:Point {return Point(p:(x - 1, y + 1))}
    var l:Point {return Point(p:(x - 1, y - 1))}
    var r:Point {return Point(p:(x + 1, y + 1))}

    init(p:(Int,Int)){
        (x, y) = p
    }

    func distanceTo(p:Point) -> Int {
        return abs(p.x - x) + abs(p.y - y)
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }


}

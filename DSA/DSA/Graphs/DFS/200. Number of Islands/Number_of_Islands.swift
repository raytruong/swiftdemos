import Playgrounds

struct NumberOfIslands {
    typealias Point = (x: Int, y: Int)

    class Map {
        var grid: [[Character]]

        init(_ grid: [[Character]]) {
            self.grid = grid
        }

        func isLand(x: Int, y: Int) -> Bool {
            guard
                x >= 0, x < grid.count,
                y >= 0, y < grid[0].count,
                grid[x][y] == "1"
            else {
                return false
            }
            return true
        }

        func visit(x: Int, y: Int) {
            guard isLand(x: x, y: y) else {
                return
            }
            grid[x][y] = "0"
        }
    }

    static func dfs(_ grid: [[Character]]) -> Int {
        var islandCounter = 0
        let map = Map(grid)
        for x in 0..<map.grid.count {
            for y in 0..<map.grid[0].count {
                guard map.grid[x][y] == "1" else {
                    continue
                }
                dfsVisitor(on: map, at: Point(x: x, y: y))
                islandCounter += 1
            }
        }
        return islandCounter
    }

    private static func dfsVisitor(on map: Map, at point: Point) {
        var stack: [Point] = [point]

        while !stack.isEmpty {
            guard let currPoint = stack.popLast() else {
                return
            }
            map.visit(x: currPoint.x, y: currPoint.y)
            let x = currPoint.x
            let y = currPoint.y
            let adjacentPoints = [
                Point(x: x-1, y),
                Point(x: x+1, y),
                Point(x: x, y-1),
                Point(x: x, y+1),
            ]
            adjacentPoints.forEach { point in
                if map.isLand(x: point.x, y: point.y) {
                    stack.append(point)
                }
                else {
                    // out of bounds, or water. do nothing
                }
            }
        }
    }
}

#Playground {
    let input: [[Character]] = [["1","1","1","1","0"],["1","1","0","1","0"],["1","1","0","0","0"],["0","0","0","0","0"]]
    print(NumberOfIslands.dfs(input))
}

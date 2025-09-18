import Playgrounds

struct ThreeSum {
    static func bruteForce(_ nums: [Int]) -> [[Int]] {
        var answers = Set<[Int]>()
        for i in 0..<nums.count {
            for j in 0..<nums.count {
                for k in 0..<nums.count {
                    guard i != j, i != k, j != k else {
                        continue
                    }

                    if nums[i] + nums[j] + nums[k] == 0 {
                        answers.insert([nums[i], nums[j], nums[k]].sorted())
                    }
                    else {
                        continue
                    }
                }
            }
        }
        return Array(answers)
    }
}

#Playground {
    print(ThreeSum.bruteForce([1, -1, 2, 3, 4, -5]))
}

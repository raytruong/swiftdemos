import Playgrounds

struct TwoSum {
    static func bruteforce(_ nums: [Int], _ target: Int) -> [Int] {
        for i in (0..<nums.count) { // n iteration
            for j in (0..<nums.count) { // n iteration
                guard i != j else {
                    continue // target can't use two numbers at the same time
                }

                if nums[i] + nums[j] == target {
                    return [i, j]
                }
                else {
                    continue
                }
            }
        }
        return []
    }

    static func dictionary(_ nums: [Int], _ target: Int) -> [Int] {
        typealias TargetValue = Int
        typealias TargetIndex = Int

        var map: [TargetValue: TargetIndex] = [:]

        for i in 0..<nums.count {
            let currentValue = nums[i]
            let currentTargetValue = target - currentValue

            if let foundTargetIndex = map[currentTargetValue] {
                return [i, foundTargetIndex]
            }
            else {
                map[currentValue] = i
            }
        }
        return []
    }
}

#Playground {
    let input = [2,7,11,15]
    let target = 9
    print(TwoSum.bruteforce(input, target))
    print(TwoSum.dictionary(input, target))
}

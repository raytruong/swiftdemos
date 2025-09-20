import Playgrounds

struct BinarySearch {
    static func binarySearch(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count-1

        while left <= right { // while there are still elements in the slice to check (<= handles single element slice case)
            let mid = Int((Double(left) + Double(right)) / 2) // prevent addition overflow
            if nums[mid] == target {
                return mid
            }
            else if nums[mid] < target {
                left = mid+1 // discard mid
            }
            else {
                right = mid-1 // discard mid
            }
        }
        return -1
    }
}

#Playground {
    let nums = [-1, 0, 3, 5, 9, 12]
    print(BinarySearch.binarySearch(nums, 9))
}

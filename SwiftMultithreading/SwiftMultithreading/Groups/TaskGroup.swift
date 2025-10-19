import Foundation
import Playgrounds

#Playground {
    typealias ResultType = Int

    let taskGroupResult = await withTaskGroup(of: ResultType.self) { group in
        var resultAggregator = 0

        for i in (0..<100) {
            group.addTask { // fan out
                return 1
            }
        }

        for await taskResult in group { // fan in
            resultAggregator += taskResult
        }

        return resultAggregator
    }

    print(taskGroupResult)
}


import Foundation

import Foundation

func logCtx(_ message: String) {
    let threadInfo = Thread.isMainThread ? "Main" : "Background"
    let threadNumber = Thread.current

    print("[\(threadInfo)] \(message)")
}

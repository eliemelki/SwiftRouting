import Testing

//
//  SerialQueueTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 29/05/2025.
//
@testable import SwiftRouting

@MainActor
@Test func testSerialExecutionOrder() async {
    let queue = SerialQueue()
    var events: [Int] = []
    var releaseFirst: CheckedContinuation<Void, Never>?
    let first = Task {
        await queue.execute {
            events.append(1)
            await withCheckedContinuation {
                releaseFirst = $0
            }
            events.append(2)
        }
    }
    while releaseFirst == nil {
        await Task.yield()
    }
    let second = Task {
        await queue.execute {
            events.append(3)
        }
    }
    // The second operation must stay blocked while the first is suspended.
    for _ in 0..<10 {
        await Task.yield()
    }
    #expect(events == [1])
    releaseFirst?.resume()
    await first.value
    await second.value
    #expect(events == [1, 2, 3])
    let value = await queue.execute {
        42
    }
    #expect(value == 42)
}

@Test func testExecutionReturnsCorrectValue() async {
    let queue = await SerialQueue()

    let result: Int = await queue.execute {
        return 42
    }

    #expect(result == 42)
}

@Test func testMultipleExecutions() async {
    let queue = await SerialQueue()
    var results: [Int] = []

    for i in 0..<5 {

        async let result: Void = queue.execute {
            results.append(i)
        }
        _ = await result

    }

    #expect(results == [0, 1, 2, 3, 4])
}

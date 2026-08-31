//
//  CurrentValueAsyncStream.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/31/26.
//

import Observation

/// Mimics a Combine `CurrentValueSubject` while supporting Swift Observation.
@Observable
nonisolated final class CurrentValueAsyncStream<Value: Equatable> {
    /// An asynchronous sequence that emits each new value.
    let values: AsyncStream<Value>
    
    /// The continuation used to publish new values to the stream.
    private let continuation: AsyncStream<Value>.Continuation
    
    /// The current value.
    private(set) var value: Value

    /// Creates a stream with the given initial value.
    init(_ initialValue: Value) {
        value = initialValue

        let (stream, continuation) = AsyncStream<Value>.makeStream()
        values = stream
        self.continuation = continuation
    }

    /// Updates the current value and emits it when it differs from the existing value.
    func send(_ value: Value) {
        guard value != self.value else { return }

        self.value = value
        continuation.yield(value)
    }
}

//
//  Publisher+.swift
//  SwiftRouting
//
//  Created by Elie Melki on 02/04/2025.
//
import Combine

class PublishedTracker<T> {
    var values: [T]
    var cancellable: AnyCancellable! = nil
    
    init(publisher: Published<T>.Publisher) {
        values = []
        cancellable = publisher.dropFirst()
            .sink(receiveValue: { [weak self] value in
                self?.values.append(value)
            })
    }
}

extension Published.Publisher{
    func tracker() -> PublishedTracker<Output> {
        return .init(publisher: self)
    }
}

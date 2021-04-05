//
//  TextLimiter.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/4.
//

import Foundation
class TextLimiter: ObservableObject {
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var text = "" {
        didSet {
            if text.count > self.limit {
                text = String(text.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    @Published var hasReachedLimit = false
}

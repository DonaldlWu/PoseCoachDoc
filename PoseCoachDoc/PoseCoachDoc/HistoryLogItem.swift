//
//  HistoryLogItem.swift
//  PoseCoachDoc
//
//  Created by 吳得人 on 2021/12/20.
//

import Foundation

public struct HistoryLogItem: Equatable, Decodable {
    public let title: String
    public let description: String?
    public let timestamp: String
    
    public init(title: String, description: String? = nil, timestamp: String) {
        self.title = title
        self.description = description
        self.timestamp = timestamp
    }
}


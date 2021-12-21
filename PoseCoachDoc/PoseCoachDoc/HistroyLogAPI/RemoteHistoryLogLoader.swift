//
//  RemoteHistoryLogLoader.swift
//  PoseCoachDoc
//
//  Created by 吳得人 on 2021/12/21.
//

import Foundation

public protocol HTTPClient {
    func get(from: URL)
}

public final class RemoteHistoryLogLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}

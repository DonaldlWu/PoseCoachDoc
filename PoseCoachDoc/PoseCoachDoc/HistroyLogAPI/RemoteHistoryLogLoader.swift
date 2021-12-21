//
//  RemoteHistoryLogLoader.swift
//  PoseCoachDoc
//
//  Created by 吳得人 on 2021/12/21.
//

import Foundation

public protocol HTTPClient {
    func get(from: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteHistoryLogLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}

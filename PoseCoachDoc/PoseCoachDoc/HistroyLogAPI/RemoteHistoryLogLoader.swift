//
//  RemoteHistoryLogLoader.swift
//  PoseCoachDoc
//
//  Created by 吳得人 on 2021/12/21.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from: URL, completion: @escaping (HTTPClientResult) -> Void)
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
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([HistoryLogItem])
        case failure(Error)
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                if let logItmes = try? HistoryLogItemMapper.map(data, response) {
                    completion(.success(logItmes))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private class HistoryLogItemMapper {
    private struct JSONItem: Decodable {
        let logs: [HistoryLog]
    }
    
    private struct HistoryLog: Decodable {
        let title: String
        let content: String?
        let timestamp: String
        
        var log: HistoryLogItem {
            return HistoryLogItem(title: title,
                                  description: content,
                                  timestamp: timestamp)
        }
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [HistoryLogItem] {
        guard response.statusCode == 200 else {
            throw RemoteHistoryLogLoader.Error.invalidData
        }
        
        let logItems = try JSONDecoder().decode(JSONItem.self, from: data).logs.map { $0.log }
        return logItems
    }
}





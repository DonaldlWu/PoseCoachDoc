//
//  PoseCoachDocTests.swift
//  PoseCoachDocTests
//
//  Created by 吳得人 on 2021/12/20.
//

import XCTest

class RemoteHistoryLogLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from: URL)
}


class RemoteHistoryLogLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteHistoryLogLoader(url: URL(string: "https://a-url.com")!, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteHistoryLogLoader(url: URL(string: "https://a-url.com")!, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helper
    
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }

}

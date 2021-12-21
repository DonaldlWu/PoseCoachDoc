//
//  PoseCoachDocTests.swift
//  PoseCoachDocTests
//
//  Created by 吳得人 on 2021/12/20.
//

import XCTest
import PoseCoachDoc

class RemoteHistoryLogLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helper
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteHistoryLogLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteHistoryLogLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }

}

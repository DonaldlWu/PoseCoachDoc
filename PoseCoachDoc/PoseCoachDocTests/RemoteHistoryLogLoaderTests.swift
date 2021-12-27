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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let cases = [199, 201, 300, 400, 500]
        
        cases.enumerated().forEach { index, code in
            expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJSON = Data("{\"logs\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversLogsOn200HTTPResponseWithJSONLogItems() {
        let (sut, client) = makeSUT()
        
        let logItem1 = HistoryLogItem(title: "title", timestamp: "2021/12/27")
        let log1JSON = [
            "title": logItem1.title,
            "timestamp": logItem1.timestamp
        ]
        
        let logItem2 = HistoryLogItem(title: "title2", description: "des2", timestamp: "2021/12/28")
        let log2JSON = [
            "title": logItem2.title,
            "content": logItem2.description,
            "timestamp": logItem2.timestamp
        ]
        
        let logsJSON = [
            "logs": [log1JSON, log2JSON]
        ]
        
        expect(sut, toCompleteWithResult: .success([logItem1, logItem2]), when: {
            let json = try! JSONSerialization.data(withJSONObject: logsJSON)
            client.complete(withStatusCode: 200, data: json)
        })
    }

    // MARK: - Helper
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteHistoryLogLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteHistoryLogLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteHistoryLogLoader, toCompleteWithResult result: RemoteHistoryLogLoader.Result, when action: () -> Void, filePath file: StaticString = #file, line: UInt = #line) {
        
        var captureResults = [RemoteHistoryLogLoader.Result]()
        sut.load { captureResults.append($0) }
        
        action()
        
        XCTAssertEqual(captureResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[0],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }

}

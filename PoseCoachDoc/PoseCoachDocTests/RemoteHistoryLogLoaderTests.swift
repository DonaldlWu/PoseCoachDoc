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
            let json = makeLogsJSON([])
            expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: json, at: index)
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
            let emptyListJSON = makeLogsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversLogsOn200HTTPResponseWithJSONLogItems() {
        let (sut, client) = makeSUT()
        
        let logItem1 = makeLogItem(title: "title", timestamp: "2021/12/27")
        let logItem2 = makeLogItem(title: "title2", description: "des2", timestamp: "2021/12/28")
        let logs = [logItem1.model, logItem2.model]
        let jsons = [logItem1.json, logItem2.json]
        
        expect(sut, toCompleteWithResult: .success(logs), when: {
            let json = makeLogsJSON(jsons)
            client.complete(withStatusCode: 200, data: json)
        })
    }

    // MARK: - Helper
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteHistoryLogLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteHistoryLogLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func makeLogItem(title: String, description: String? = nil, timestamp: String) -> (model: HistoryLogItem, json: [String: Any]) {
        let logItem = HistoryLogItem(title: title,
                                     description: description,
                                     timestamp: timestamp)
        let logJSON = [
            "title": title,
            "content": description,
            "timestamp": timestamp
        ].compactMapValues({$0})
        
        return (logItem, logJSON)
    }
    
    private func makeLogsJSON(_ logs: [[String: Any]]) -> Data {
        let json = ["logs": logs]
        return try! JSONSerialization.data(withJSONObject: json)
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
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[0],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }

}

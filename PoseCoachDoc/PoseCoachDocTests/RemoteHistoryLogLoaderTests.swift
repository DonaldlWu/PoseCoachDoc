//
//  PoseCoachDocTests.swift
//  PoseCoachDocTests
//
//  Created by 吳得人 on 2021/12/20.
//

import XCTest

class RemoteHistoryLogLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteHistoryLogLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteHistoryLogLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}

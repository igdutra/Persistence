//
//  XCTestCase.swift
//  Persistence-EssentialsTests
//
//  Created by Ivo on 22/12/22.
//

import XCTest

public extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    // MARK: - Stubs
    
    func anyURL(_ host: String = "a-url.com") -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        return components.url!
    }
}

//
//  CacheFeedUseCaseTests.swift
//  Persistence-EssentialsTests
//
//  Created by Ivo on 21/12/22.
//

import XCTest
import Network

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    var messages: [Methods] = []
    
    enum Methods {
        case deleteCachedFeed
        case insert
    }
    
    func deleteCachedFeed() {
        messages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.messages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(makeItems())
        
        XCTAssertEqual(store.messages, [.deleteCachedFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(makeItems())
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.messages, [.deleteCachedFeed])
    }
}

// MARK: - Helpers

private extension CacheFeedUseCaseTests {
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    
    // MARK: Stubs
    
    func makeItems() -> [FeedItem] {
        let uniqueItem1 = FeedItem(id: UUID(), imageURL: anyURL())
        let uniqueItem2 = FeedItem(id: UUID(), imageURL: anyURL())
        
        return [uniqueItem1, uniqueItem2]
    }
}

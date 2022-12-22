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
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(items)
            }
        }
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    private var deletionCompletions = [DeletionCompletion]()
    
    var deleteCachedFeedCallCount = 0
    var insertCallCount = 0
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deleteCachedFeedCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem]) {
        insertCallCount += 1
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(makeItems())
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(makeItems())
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(makeItems())
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.insertCallCount, 1)
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

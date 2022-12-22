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
     var deleteCachedFeedCallCount = 0
     
     func deleteCachedFeed() {
         deleteCachedFeedCallCount += 1
     }
 }

 class CacheFeedUseCaseTests: XCTestCase {

     func test_init_doesNotDeleteCacheUponCreation() {
         let store = FeedStore()
         _ = LocalFeedLoader(store: store)

         XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
     }
     
     func test_save_requestsCacheDeletion() {
         let store = FeedStore()
         let sut = LocalFeedLoader(store: store)

         sut.save(makeItems())
         
         XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
     }

 }

// MARK: - Helpers

private extension CacheFeedUseCaseTests {
 
    func makeItems() -> [FeedItem] {
        let uniqueItem1 = FeedItem(id: UUID(), imageURL: anyURL())
        let uniqueItem2 = FeedItem(id: UUID(), imageURL: anyURL())
       
        return [uniqueItem1, uniqueItem2]
    }
}

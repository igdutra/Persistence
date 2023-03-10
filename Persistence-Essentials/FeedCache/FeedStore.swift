//
//  FeedStore.swift
//  Persistence-Essentials
//
//  Created by Ivo on 10/01/23.
//

import Foundation
import Network

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

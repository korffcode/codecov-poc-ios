import Foundation

protocol SearchHistoryRepositoryProtocol {
    var queries: [String] { get }
    func save(_ query: String)
}

class SearchHistoryRepository: SearchHistoryRepositoryProtocol {
    var queries: [String] {
        _queries.array as? [String] ?? []
    }
    
    var _queries: NSMutableOrderedSet = ["pasta", "car", "clouds"]
    
    func save(_ query: String) {
        _queries.insert(query, at: 0)
    }
}

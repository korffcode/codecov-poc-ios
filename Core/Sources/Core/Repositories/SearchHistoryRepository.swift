import Foundation

public protocol SearchHistoryRepositoryProtocol {
    var queries: [String] { get }
    func save(_ query: String)
}

public class SearchHistoryRepository: SearchHistoryRepositoryProtocol {
    public init() {}

    public var queries: [String] {
        _queries.array as? [String] ?? []
    }
    
    var _queries: NSMutableOrderedSet = ["pasta", "car", "clouds"]
    
    public func save(_ query: String) {
        _queries.insert(query, at: 0)
    }
}

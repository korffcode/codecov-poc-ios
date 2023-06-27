import XCTest
@testable import Core

final class SearchHistoryRepositoryTests: XCTestCase {
    var sut: SearchHistoryRepository!

    override func setUpWithError() throws {
        sut = SearchHistoryRepository()
    }

    func testRespository_shouldSuperSave() throws {
        sut.superSave()
    }
}

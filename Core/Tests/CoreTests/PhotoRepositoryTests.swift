import XCTest
@testable import Core

final class PhotoRepositoryTests: XCTestCase {
    var sut: PhotoRepository!

    override func setUpWithError() throws {
        sut = PhotoRepository(api: MockAPI())
    }

    func testRepository_shouldReturnPhotosFromAPI() async throws {
        let photos = try await sut.getPhotos("test query")

        XCTAssertFalse(photos.isEmpty)
        XCTAssertEqual(photos.first!.id, 52703925845)
    }

    func testRepository_callNewFunction() async throws {
        let photos = try await sut.getSavedPhotos()

        XCTAssertNotNil(photos)
    }
}

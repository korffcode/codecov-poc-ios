import Combine
import XCTest
@testable import FlickrFindr

final class PhotoListVMTests: XCTestCase {
    var sut: PhotoListVM!
    var cancellables: Set<AnyCancellable> = .init()

    override func setUpWithError() throws {
        sut = PhotoListVM(
            searchHistoryRepository: SearchHistoryRepository(),
            photoRepository: MockPhotoRepository()
        )
    }

    override func tearDownWithError() throws {
        MockPhotoRepository.getRecentPhotosCalled = nil
        MockPhotoRepository.getPhotosCalled = nil
    }

    func testViewModel_initialState() throws {
        XCTAssert(sut.photos.isEmpty)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.showError)
    }

    func testViewModel_givenEmptyQuery_shouldLoadMostRecentPhotos() async throws {
        let expectation = expectation(description: "getRecentPhotos method in PhotoRepository should be called")

        MockPhotoRepository.getRecentPhotosCalled = {
            expectation.fulfill()
        }
        MockPhotoRepository.getPhotosCalled = { _ in
            XCTFail()
        }
        
        await sut.search("")
        await waitForExpectations(timeout: 1.0)
    }

    func testViewModel_givenQuery_shouldLoadPhotosUsingQuery() async throws {
        let expectation = expectation(description: "getPhotos method in PhotoRepository should be called with the passed query")
        let testQuery = "foobar"

        MockPhotoRepository.getRecentPhotosCalled = {
            XCTFail()
        }
        MockPhotoRepository.getPhotosCalled = { query in
            XCTAssertEqual(query, testQuery)
            expectation.fulfill()
        }

        await sut.search(testQuery)
        await waitForExpectations(timeout: 1.0)
    }

    func testViewModel_whenAskedToPerformSearch_shouldPublishNewPhotos() async throws {
        let expectation = expectation(description: "ViewModel should publish new photos after a search")
        sut.$photos
            .dropFirst()
            .sink { photos in
                XCTAssertFalse(photos.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        Task.detached {
            await self.sut.search("pasta")
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

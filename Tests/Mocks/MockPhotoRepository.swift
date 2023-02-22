class MockPhotoRepository: PhotoRepositoryProtocol {
    static var getRecentPhotosCalled: (() -> Void)?
    static var getPhotosCalled: ((String) -> Void)?

    func getPhotos(_ query: String) async throws -> [Photo] {
        MockPhotoRepository.getPhotosCalled?(query)
        return [.preview(title: query)]
    }

    func getRecentPhotos() async throws -> [Photo] {
        MockPhotoRepository.getRecentPhotosCalled?()
        return [.preview]
    }
}

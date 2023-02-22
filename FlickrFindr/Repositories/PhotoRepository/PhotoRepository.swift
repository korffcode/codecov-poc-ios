protocol PhotoRepositoryProtocol {
    func getPhotos(_ query: String) async throws -> [Photo]
    func getRecentPhotos() async throws -> [Photo]
}

class PhotoRepository: PhotoRepositoryProtocol {
    private let api: API
    
    init(api: API = FlickrAPI()) {
        self.api = api
    }
    
    func getPhotos(_ query: String) async throws -> [Photo] {
        return PhotoDtoToModelMapper.map(try await api.fetchPhotos(query))
    }
    
    func getRecentPhotos() async throws -> [Photo] {
        return PhotoDtoToModelMapper.map(try await api.fetchRecentPhotos())
    }
}

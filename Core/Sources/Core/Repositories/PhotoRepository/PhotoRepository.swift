public protocol PhotoRepositoryProtocol {
    func getPhotos(_ query: String) async throws -> [Photo]
    func getRecentPhotos() async throws -> [Photo]
}

public class PhotoRepository: PhotoRepositoryProtocol {
    private let api: API
    
    public init(api: API = FlickrAPI()) {
        self.api = api
    }
    
    public func getPhotos(_ query: String) async throws -> [Photo] {
        return PhotoDtoToModelMapper.map(try await api.fetchPhotos(query))
    }
    
    public func getRecentPhotos() async throws -> [Photo] {
        return PhotoDtoToModelMapper.map(try await api.fetchRecentPhotos())
    }
}

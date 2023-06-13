import Core
import Foundation

class PhotoListVM: ObservableObject {
    enum PhotoListError: LocalizedError {
        case serverError
        case genericError

        var errorDescription: String? {
            switch self {
            case .serverError: return "Something went wrong communicating with Flickr, try again later..."
            case .genericError: return "Something went wrong, try again later..."
            }
        }
    }

    @Published var photos: [Photo] = []
    @Published var error: LocalizedError?
    @Published var showError: Bool = false
    var recentQueries: [String] {
        searchHistoryRepository.queries
    }

    private let searchHistoryRepository: SearchHistoryRepositoryProtocol
    private let photoRepository: PhotoRepositoryProtocol

    init(
        searchHistoryRepository: SearchHistoryRepositoryProtocol = SearchHistoryRepository(),
        photoRepository: PhotoRepositoryProtocol = PhotoRepository()
    ) {
        self.searchHistoryRepository = searchHistoryRepository
        self.photoRepository = photoRepository
    }

    @MainActor
    func search(_ query: String) {
        Task {
            do {
                if query.isEmpty {
                    photos = try await photoRepository.getRecentPhotos()
                } else {
                    searchHistoryRepository.save(query)
                    photos = try await photoRepository.getPhotos(query)
                }
            } catch is URLError {
                showError = true
                self.error = PhotoListError.serverError
            } catch {
                showError = true
                self.error = error as? LocalizedError
            }
        }
    }
}

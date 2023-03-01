import Foundation

protocol API {
    func fetchPhotos(_ query: String) async throws -> [PhotoDTO]
    func fetchRecentPhotos() async throws -> [PhotoDTO]
}

class FlickrAPI: API {
    enum APIError: Error, LocalizedError {
        case failure(message: String)

        var errorDescription: String? {
            switch self {
            case .failure(message: let message):
                return message
            }
        }
    }

    private enum Endpoint {
        case getRecent
        case search(query: String)

        var method: String {
            switch self {
            case .search: return "flickr.photos.search"
            case .getRecent: return "flickr.photos.getRecent"
            }
        }

        static var baseQueryItems: [URLQueryItem] = [
            .init(name: "api_key", value: Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""),
            .init(name: "format", value: "json"),
            .init(name: "nojsoncallback", value: "1"),
            .init(name: "per_page", value: "25")
        ]

        static func builder(_ endpoint: Endpoint) -> URL? {
            var components = URLComponents(string: "https://www.flickr.com/services/rest")
            components?.queryItems = baseQueryItems
            components?.queryItems?.append(contentsOf: [
                .init(name: "method", value: endpoint.method),
            ])

            switch endpoint {
            case .search(query: let query):
                components?.queryItems?.append(contentsOf: [
                    .init(name: "text", value: query)
                ])
            default: break
            }

            return components?.url
        }
    }
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchPhotos(_ query: String) async throws -> [PhotoDTO] {
        guard let url = Endpoint.builder(.search(query: query)) else {
            return []
        }

        let apiResponseDto: FlickrApiResponseDTO = try await performApiRequest(url)
        try checkResponse(apiResponseDto)
        return apiResponseDto.photos?.photo ?? []
    }

    func fetchRecentPhotos() async throws -> [PhotoDTO] {
        guard let url = Endpoint.builder(.getRecent) else {
            return []
        }

        let apiResponseDto: FlickrApiResponseDTO = try await performApiRequest(url)
        try checkResponse(apiResponseDto)
        return apiResponseDto.photos?.photo ?? []
    }

    private func performApiRequest<T: Decodable>(_ url: URL) async throws -> T {
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func checkResponse(_ dto: FlickrApiResponseDTO) throws {
        if dto.stat == "fail", let message = dto.message {
            throw APIError.failure(message: message)
        }
    }
}

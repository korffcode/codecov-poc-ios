import Foundation

class MockAPI: API {
    var mockResponseJsonString = """
        {
          "photos": {
            "page": 1,
            "pages": 1000,
            "perpage": 1,
            "total": 1000,
            "photo": [
              {
                "id": "52703925845",
                "owner": "152493592@N07",
                "secret": "1f54c236d6",
                "server": "65535",
                "farm": 66,
                "title": "20230209_180805",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              }
            ]
          },
          "stat": "ok"
        }
    """

    func fetchPhotos(_ query: String) async throws -> [PhotoDTO] {
        returnMockData().photos?.photo ?? []
    }

    func fetchRecentPhotos() async throws -> [PhotoDTO] {
        returnMockData().photos?.photo ?? []
    }

    private func returnMockData() -> FlickrApiResponseDTO {
        let data = mockResponseJsonString.data(using: .utf8)!
        return try! JSONDecoder().decode(FlickrApiResponseDTO.self, from: data)
    }
}

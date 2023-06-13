import Foundation

enum PhotoDtoToModelMapper {
    static func map(_ input: [PhotoDTO]) -> [Photo] {
        input.compactMap {
            guard let id = Int($0.id ?? ""),
                  let serverId = $0.server,
                  let secret = $0.secret,
                  let url = URL(string: "https://live.staticflickr.com/\(serverId)/\(id)_\(secret)_b.jpg") else {
                return nil
            }
            
            return Photo(
                id: id,
                title: ($0.title ?? "").isEmpty ? "(untitled)" : $0.title ?? "",
                photoUrl: url
            )
        }
    }
}

import Foundation

public struct Photo: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let photoUrl: URL

    init(id: Int, title: String, photoUrl: URL) {
        self.id = id
        self.title = title
        self.photoUrl = photoUrl
    }

    #if DEBUG
    public static var preview: Photo {
        .init(id: Int.random(in: 0...300), title: "Test Photo \(Int.random(in: 0...300))", photoUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e4/Deep-purple-1970.jpg")!)
    }

    static func preview(title: String) -> Photo {
        .init(id: Int.random(in: 0...99999), title: title, photoUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e4/Deep-purple-1970.jpg")!)
    }
    #endif
}

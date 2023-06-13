import Core
import SwiftUI

struct PhotoDetail: View {
    let photo: Photo

    var body: some View {
            AsyncImage(url: photo.photoUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .navigationTitle(photo.title)
    }
}

struct PhotoDetail_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetail(photo: .preview)
    }
}

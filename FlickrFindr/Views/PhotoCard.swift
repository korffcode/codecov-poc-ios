import SwiftUI

struct PhotoCard: View {
    let photo: Photo

    var body: some View {
        VStack {
            AsyncImage(url: photo.photoUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .cornerRadius(12)
            Text(photo.title)
                .font(.body)
        }

    }
}

struct PhotoCard_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCard(photo: .preview)
    }
}

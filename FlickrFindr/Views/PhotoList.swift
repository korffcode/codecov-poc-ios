import SwiftUI

struct PhotoList: View {
    @StateObject private var viewModel = PhotoListVM()
    @State private var searchText = ""

    let columns: [GridItem] = [
        GridItem(),
        GridItem()
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.photos) { photo in
                        NavigationLink(value: photo) {
                            PhotoCard(photo: photo)
                                .frame(height: 180)
                        }
                    }
                }
                .padding()
                .navigationTitle("FlickrFindr")
                .task {
                    if viewModel.photos.isEmpty {
                        performSearch()
                    }
                }
                .navigationDestination(for: Photo.self) { photo in
                    PhotoDetail(photo: photo)
                }
                .searchable(text: $searchText, prompt: "Search for something on Flickr") {
                    ForEach(viewModel.recentQueries, id: \.self) {
                        Text($0)
                            .searchCompletion($0)
                    }
                }
                .onSubmit(of: .search, {
                    performSearch()
                })
                .onChange(of: searchText) {
                    if $0.isEmpty {
                        performSearch()
                    }
                }
                .alert(viewModel.error?.localizedDescription ?? "", isPresented: $viewModel.showError) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
    }

    private func performSearch() {
        viewModel.search(searchText)
    }
}

struct PhotoList_Previews: PreviewProvider {
    static var previews: some View {
        PhotoList()
    }
}

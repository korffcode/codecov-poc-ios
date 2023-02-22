struct FlickrApiResponseDTO: Codable {
    let photos: PhotosDTO?
    let stat: String?
    let code: Int?
    let message: String?
}

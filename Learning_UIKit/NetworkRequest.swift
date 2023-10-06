import Foundation

protocol NetworkRequest {
    func gettingPhotoURL(_ url: URL)
    func downloadAndSetImage(_ url: URL)
}

protocol GalleryOperations {
    func nextImage()
    func prevImage()
}

struct PhotoResponse: Codable {
    let success: Bool
    let message: String
    let photo: Photo
}

struct Photo: Codable {
    let description: String
    let url: String
    let title: String
    let id: Int
    let user: Int
}

extension NetworkRequest {
    func gettingPhotoURL(_ url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error : \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let photoResponse = try decoder.decode(PhotoResponse.self, from: data)
                    let photo_url: URL = URL(string: photoResponse.photo.url)!
                    downloadAndSetImage(photo_url)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

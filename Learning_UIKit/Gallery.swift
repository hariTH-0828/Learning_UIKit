import UIKit

var index: Int = 0
var imageView: UIImageView!
var loadingIndicator: UIActivityIndicatorView!

func passingImageView(_ iv: inout UIImageView) {
    imageView = iv
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
}

func passingLoadingIndicator(_ loadIndicator: inout UIActivityIndicatorView) {
    loadingIndicator = loadIndicator
    loadingIndicator.isHidden = false
    loadingIndicator.startAnimating()
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

func nextImage() {
    if index < 100 {
        index += 1
        let prepare_url = "https://api.slingacademy.com/v1/sample-data/photos/\(index)"
        let url = URL(string: prepare_url)!
        gettingPhotoURL(url)
    }
}

func prevImage() {
    if index > 1, index < 100 {
        index -= 1
        let prepare_url = "https://api.slingacademy.com/v1/sample-data/photos/\(index)"
        let url = URL(string: prepare_url)!
        gettingPhotoURL(url)
    }
}

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
                let photo_url_string = photoResponse.photo.url
                let photo_url: URL = URL(string: photo_url_string)!
                downloadAndSetImage(photo_url)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
    }.resume()
}

func downloadAndSetImage(_ url: URL) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error downloading image: \(error)")
            return
        }
        
        guard let data = data else {
            print("No data returned from the server")
            return
        }
            
        let image = UIImage(data: data)
        
        DispatchQueue.main.async {
            imageView.image = image
            loadingIndicator.isHidden = true
        }
    }.resume()
}

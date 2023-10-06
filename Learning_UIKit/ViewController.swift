import UIKit

class ViewController: UIViewController, NetworkRequest, GalleryOperations {
   
    @IBOutlet var imageViewFrame: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextImage()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeft))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRight))
        
        swipeLeft.direction = .left; swipeRight.direction = .right
        swipeLeft.numberOfTouchesRequired = 1; swipeRight.numberOfTouchesRequired = 1
        imageViewFrame.addGestureRecognizer(swipeLeft)
        imageViewFrame.addGestureRecognizer(swipeRight)
        imageViewFrame.contentMode = .scaleAspectFill
        imageViewFrame.isUserInteractionEnabled = true
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    @objc func SwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        nextImage()
    }
    
    @objc func SwipeRight(_ gesture: UISwipeGestureRecognizer) {
        prevImage()
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
                self.imageViewFrame.image = image
                self.loadingIndicator.isHidden = true
            }
        }.resume()
    }
}


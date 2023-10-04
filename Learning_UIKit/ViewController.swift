import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageViewFrame: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var countValue: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var buttonPressMe: UIButton!
    var image_index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextImage()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeft))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRight))
        
        swipeLeft.direction = .left; swipeRight.direction = .right
        swipeLeft.numberOfTouchesRequired = 1; swipeRight.numberOfTouchesRequired = 1
        
        imageViewFrame.contentMode = .scaleAspectFill
        imageViewFrame.addGestureRecognizer(swipeLeft)
        imageViewFrame.addGestureRecognizer(swipeRight)
        imageViewFrame.isUserInteractionEnabled = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
    }

    @objc func SwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        nextImage()
    }
    
    @objc func SwipeRight(_ gesture: UISwipeGestureRecognizer) {
        showAlert()
    }
    
    @IBAction func updateCount(_ sender: Any) {
        let prev_value: Int = Int(countValue.text!) ?? 0
        countValue.text = String(prev_value + 1)
    }
    
    @IBAction func visibilityChange(_ power: UISwitch) {
        if power.isOn {
            countValue.isHidden = false
            countLabel.isHidden = false
            buttonPressMe.isHidden = false
        }else {
            countValue.isHidden = true
            countLabel.isHidden = true
            buttonPressMe.isHidden = true
        }
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
                    self.downloadAndSetImage(photo_url)
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
                self.imageViewFrame.image = image
                self.loadingIndicator.isHidden = true
            }
        }.resume()
    }
    
    func nextImage() {
        if image_index < 100 {
            image_index += 1
            let prepare_url = "https://api.slingacademy.com/v1/sample-data/photos/\(image_index)"
            let url = URL(string: prepare_url)!
            gettingPhotoURL(url)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Warning", message: "still no previous feature add", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

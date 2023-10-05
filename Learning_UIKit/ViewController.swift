import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageViewFrame: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var countValue: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var buttonPressMe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextImage()
        passingImageView(&imageViewFrame)
        passingLoadingIndicator(&loadingIndicator)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeft))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRight))
        
        swipeLeft.direction = .left; swipeRight.direction = .right
        swipeLeft.numberOfTouchesRequired = 1; swipeRight.numberOfTouchesRequired = 1
        imageViewFrame.addGestureRecognizer(swipeLeft)
        imageViewFrame.addGestureRecognizer(swipeRight)
    }

    @objc func SwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        nextImage()
    }
    
    @objc func SwipeRight(_ gesture: UISwipeGestureRecognizer) {
        prevImage()
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
}

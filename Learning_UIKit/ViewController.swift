import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageViewFrame: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
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
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
    }
    
    
}

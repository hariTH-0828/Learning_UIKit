import Foundation
import UIKit


class ListImagesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var viewLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        viewLabel.text = "List Images"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let photoIndex = indexPath.row + 1
        if let imageUrl = URL(string: "https://api.slingacademy.com/v1/sample-data/photos/\(photoIndex)") {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error : \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let photoResponse = try decoder.decode(PhotoResponse.self, from: data)
                        self.downloadAndSetImage(photoResponse.photo.title, photoResponse.photo.url, forCell: cell)
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
        return cell
    }
    
    func downloadAndSetImage(_ title: String, _ urlString: String, forCell cell: CustomTableViewCell) {
        let url = URL(string: urlString)!
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
                cell.iconImageView.image = image
                cell.label.text = title
            }
        }.resume()
    }
}

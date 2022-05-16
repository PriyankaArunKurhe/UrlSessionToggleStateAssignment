import UIKit
class SecondViewController: UIViewController {
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    var containerTitle: String?
    var containerDescription: String?
    var containerCategory: String?
    var containerRate: String?
    var containerCount: String?
    var containerImage: String?
    var detailArray: [DetailModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = containerTitle
        descriptionLabel.text = containerDescription
        categoryLabel.text = containerCategory
        rateLabel.text = containerRate
        countLabel.text = containerCount
        let imageURL = URL(string: containerImage!)!
        urlImage.downloadImage(from: imageURL)
    }
}
extension UIImageView {
    func downloadImage(from url: URL){
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var urlParsingDataView: UICollectionView!
    var detailArray: [DetailModel] = []
    @IBOutlet weak var btnSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlParsingDataView.dataSource = self
        self.urlParsingDataView.delegate = self
        let nibFile = UINib(nibName: "DetailsOfProductCell", bundle: nil)
        self.urlParsingDataView.register(nibFile, forCellWithReuseIdentifier: "DetailsOfProductCell")
        btnSwitch.setOn(false, animated: true)
    }
    @IBAction func switchOnOff(_ sender: UISwitch){
        if sender.isOn {
            parseData()
        } else {
            print("no internet connection")
        }
        
    }
    func parseData(){
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else{
            print("URL is Invalid...")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            print("Data received from URL is: \(String(describing: data))")
            
            if let error = error {
                print("Error received from URL is: \(error)")
            } else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else {
                          print("Data is invalid OR Status code is not proper")
                          return
                      }
                do{
                    
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else{
                        print("JSON Data is not proper Format...")
                        return
                    }
                    
                    for dictionary in jsonObject{
                        let eachDictionary = dictionary as? [String: AnyObject]
                        let postTitle = eachDictionary?["title"] as? String
                        let postPrice = eachDictionary?["price"] as? Double
                        print("Title is:\(postTitle) \n Price is:\(postPrice)")
                        let postDescription = eachDictionary?["description"] as? String
                        let postCategory = eachDictionary?["category"] as? String
                        let postImage = eachDictionary?["image"] as? String
                        guard let rating = eachDictionary?["rating"] as? [String: Any] else{
                            print("Dictionary does not contain rating key")
                            return
                        }
                        let postRate = rating["rate"] as? Double
                        let postCount = rating["count"] as? Int
                        let detail = DetailModel(title: postTitle!, price: postPrice!, description: postDescription!, category: postCategory!, rate: postRate!, count: postCount!,image: postImage!)
                        self.detailArray.append(detail)
                        DispatchQueue.main.async {
                            
                            self.urlParsingDataView.reloadData()
                        }
                    }
                }catch let myError {
                    print("Got error while converting Data to JSON - \(myError.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.urlParsingDataView.dequeueReusableCell(withReuseIdentifier: "DetailsOfProductCell", for: indexPath) as? DetailsOfProductCell else{
            return UICollectionViewCell()
        }
        cell.titleLabel.text = detailArray[indexPath.row].title as String
        cell.priceLabel.text = String(describing: detailArray[indexPath.row].price as NSNumber)
        return cell
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: urlParsingDataView.frame.size.width, height: 100)
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        let dataToPassTitle = detailArray[indexPath.row].title
        secondVC?.containerTitle = dataToPassTitle
        let dataToPassCategory = detailArray[indexPath.row].category
        secondVC?.containerCategory = dataToPassCategory
        let dataToDescription = detailArray[indexPath.row].description
        secondVC?.containerDescription = dataToDescription
        let dataToPassRate = detailArray[indexPath.row].rate
        secondVC?.containerRate = String(describing: dataToPassRate)
        let dataToPassCount = detailArray[indexPath.row].count
        secondVC?.containerCount = String(dataToPassCount)
        let dataToPassImage = detailArray[indexPath.row].image
        secondVC?.containerImage = String(dataToPassImage)
        self.navigationController?.pushViewController(secondVC!, animated: true)
        
    }
}

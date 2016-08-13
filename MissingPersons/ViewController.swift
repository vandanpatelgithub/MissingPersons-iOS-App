
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let baseURL = "http://localhost:6069/img/"
    
    let missingPeople =  [
        "person1.jpg",
        "person2.jpg",
        "person3.jpg",
        "person4.jpg",
        "person5.jpg",
        "person6.png"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }


    @IBAction func checkMatch(sender: UIButton) {
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        
        let url = "\(baseURL)\(missingPeople[indexPath.row])"
        cell.configureCell(url)
        return cell
    }
}


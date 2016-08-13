
import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImg: UIImageView!
    
    var person: Person!
    
    func configureCell(person: Person, selected: Bool) {
        self.person = person
        
        if let url = NSURL(string: "\(baseURL)\(person.personImageURL!)") {
            downloadImage(url, selected: selected)
        }
    }
    
    func downloadImage(url: NSURL, selected: Bool) {
        getDataFromURL(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.personImg.image = UIImage(data: data)
                self.person.personImage = self.personImg.image
                if !selected {
                    self.markUnselected()
                } else {
                    self.markSelected()
                }
                
            }
        }
    }
    
    func getDataFromURL(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func setSelected() {
        markSelected()
        self.person.downloadFaceID()
    }
    
    
    func markSelected() {
        personImg.layer.borderWidth = 2.0
        personImg.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func markUnselected() {
        self.personImg.layer.borderWidth = 2.0
        self.personImg.layer.borderColor = UIColor.whiteColor().CGColor
    }
}


import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImg: UIImageView!
    
    func configureCell(imageURL: String) {
        if let url = NSURL(string: imageURL) {
            downloadImage(url)
        }
    }
    
    func downloadImage(url: NSURL) {
        getDataFromURL(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.personImg.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromURL(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
    }
}


import UIKit
import ProjectOxfordFace

let baseURL = "http://localhost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    
    let imagePicker =  UIImagePickerController()
    
    let missingPeople = [
        Person(personImageURL: "person1.jpg"),
        Person(personImageURL: "person2.jpg"),
        Person(personImageURL: "person3.jpg"),
        Person(personImageURL: "person4.jpg"),
        Person(personImageURL: "person5.jpg"),
        Person(personImageURL: "person6.png"),
        Person(personImageURL: "preeti.jpg")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImage.addGestureRecognizer(tap)
        
        self.collectionView.allowsMultipleSelection = false
    }
    
    func showAlert(message: String, title: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func checkMatch(sender: UIButton) {
        if selectedPerson == nil || !hasSelectedImage {
            showAlert("Please select a missing person to check and an image from your album to compare", title: "Select Person & Image")
        }
        else {
            if let myImage = selectedImage.image, let imageData = UIImageJPEGRepresentation(myImage, 0.8) {
                FaceService.instance.client.detectWithData(imageData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, error: NSError!) in
                    
                    if error == nil {
                        var faceID: String?
                        for face in faces {
                            faceID = face.faceId
                            break
                        }
                        
                        if faceID != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceID, faceId2: faceID, completionBlock: { (result:MPOVerifyResult!, error: NSError!) in
                                
                                if error == nil {
                                    let confidence = result.confidence as Double * 100.0
                                    let rounded_confidence = Double(round(confidence*100)/100)
                                    
                                    if result.isIdentical {
                                        self.showAlert("Match Found! \n Confidence Level : \(rounded_confidence)%", title: "Match Status")
                                    } else {
                                        
                                        self.showAlert("Match NOT Found! \n Confidence Level : \(rounded_confidence)%", title: "Match Status")
                                    }
                                }
                                else {
                                    print(error.debugDescription)
                                }
                            })
                        }
                    }
                    
                    
                })
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPerson = missingPeople[indexPath.row]
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        
        cell.setSelected()
        
        cell.selected = true
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PersonCell {
            
            cell.markUnselected()
            
            cell.selected = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        
        let person = missingPeople[indexPath.row]
        
        cell.configureCell(person, selected: cell.selected)
        
        return cell
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = pickedImage
            hasSelectedImage = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}


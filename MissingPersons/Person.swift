
import Foundation
import UIKit
import ProjectOxfordFace

class Person {
    
    var faceID: String?
    var personImage: UIImage?
    var personImageURL: String?
    
    init(personImageURL: String) {
        self.personImageURL = personImageURL
    }
    
    func downloadFaceID() {
        if let img = personImage, let imageData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client.detectWithData(imageData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, error: NSError!) in
                
                if error == nil {
                    var faceID: String?
                    
                    for face in faces {
                        faceID = face.faceId
                        print("Face ID: \(faceID)")
                        break
                    }
                    
                    self.faceID = faceID
                }
            })
        }
    }
}



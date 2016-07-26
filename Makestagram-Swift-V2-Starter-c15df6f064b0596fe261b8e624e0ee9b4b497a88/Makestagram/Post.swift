import Foundation
import Parse


class Post : PFObject, PFSubclassing {
    
    var image: UIImage?
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    
    func uploadPost() {
        if let image = image {
            let imageData = UIImageJPEGRepresentation(image, 0.8)!
            let imageFile = PFFile(data: imageData)
            imageFile!.saveInBackgroundWithBlock(nil)
            
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            imageFile!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                

                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }

            
            self.imageFile = imageFile
            saveInBackgroundWithBlock(nil)
            
            user = PFUser.currentUser()
            self.imageFile = imageFile
            saveInBackgroundWithBlock(nil)
        }
    }
    
    // 2
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    
    
}
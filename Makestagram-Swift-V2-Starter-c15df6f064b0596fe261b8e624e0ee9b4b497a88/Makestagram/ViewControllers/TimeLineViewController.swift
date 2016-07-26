import UIKit
import Parse

var photoTakingHelper: PhotoTakingHelper?

class TimeLineViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        
            }
    
    func takePhoto() {

            photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!, callback: { (image: UIImage?) in
               
                
                 print("recieved a callback")
                            })
    }
}




// MARK: Tab Bar Delegate

extension TimeLineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if (viewController is PhotoViewController) {
            
            takePhoto()
            
            return false
            
        } else {
            
            return true
        }
    }
    
}




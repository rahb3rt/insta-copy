import UIKit

class TimeLineViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
    
}

// MARK: Tab Bar Delegate

extension TimeLineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if (viewController is PhotoViewController) {
            
            print("Take Photo")
            return false
        } else {
            return true
        }
    }
    
}

import UIKit
import Parse
import Bond

var photoTakingHelper: PhotoTakingHelper?

class TimeLineViewController: UIViewController {
    
    var posts: [Post] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        
            }

        func takePhoto() {
            // instantiate photo taking class, provide callback for when photo is selected
            photoTakingHelper =
                PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
                    let post = Post()
                    // 1
                    post.image.value = image!
                    post.uploadPost()
            }
        }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.timelineRequestForCurrentUser{
            (result: [PFObject]?, error: NSError?) -> Void in
            
            self.posts = result as? [Post] ?? []
            
            self.tableView.reloadData()
        }
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

extension TimeLineViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.downloadImage()
        post.fetchLikes()
        cell.post = post
        
        return cell
    }
}






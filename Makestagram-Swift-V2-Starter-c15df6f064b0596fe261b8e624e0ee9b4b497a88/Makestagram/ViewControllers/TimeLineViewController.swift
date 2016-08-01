import UIKit
import Parse
import Bond
import ConvenienceKit

var photoTakingHelper: PhotoTakingHelper?

class TimeLineViewController: UIViewController {
    
    var timelineComponent: TimelineComponent<Post, TimeLineViewController>!
    var posts: [Post] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineComponent = TimelineComponent(target: self)
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
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
        // 1
        ParseHelper.timelineRequestForCurrentUser(range) {
            (result: [PFObject]?, error: NSError?) -> Void in
            // 2
            let posts = result as? [Post] ?? []
            // 3
            completionBlock(posts)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timelineComponent.loadInitialIfRequired()
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
        return timelineComponent.content.count
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






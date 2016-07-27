import UIKit
import Parse

var photoTakingHelper: PhotoTakingHelper?

class TimeLineViewController: UIViewController {
    
    var posts: [Post] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        
            }
    
    
    func takePhoto(){

        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!, callback: { (image: UIImage?) in
            let post = Post()
            post.image = image
            post.uploadPost()
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1
        let followingQuery = PFQuery(className: "Follow")
        
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        // 2
        let postsFromFollowedUsers = Post.query()
        
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        // 3
        let postsFromThisUser = Post.query()
        
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 4
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        
        // 5
        query.includeKey("user")
        
        // 6
        query.orderByDescending("createdAt")
        
        
        // 7
        
        query.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            // 1
            for post in self.posts {
               
                do {
                // 2
                let data = try post.imageFile?.getData()
                    
                post.image = UIImage(data: data!, scale:1.0)
                    
                }
                
                catch _ {}
                
            }
            
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
        // 1
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        // 2
        cell.postImageView.image = posts[indexPath.row].image
        
        return cell
    }
}






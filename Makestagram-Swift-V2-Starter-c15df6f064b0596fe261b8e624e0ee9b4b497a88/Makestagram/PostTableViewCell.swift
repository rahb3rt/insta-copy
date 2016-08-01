import UIKit
import Bond
import Parse



class PostTableViewCell: UITableViewCell {
    
    var postDisposable: DisposableType?
    var likeDisposable: DisposableType?
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        
    }

    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    

    

    var post: Post? {
        didSet {
            // 1
            postDisposable?.dispose()
            likeDisposable?.dispose()
            
            if let post = post {
                // 2
                postDisposable = post.image.bindTo(postImageView.bnd_image)
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                    // 3
                    if let value = value {
                        // 4
                        self.likesLabel.text = self.stringFromUserList(value)
                        // 5
                        self.likeButton.selected = value.contains(PFUser.currentUser()!)
                        // 6
                        //self.likesIconImageView.hidden = (value.count == 0)
                    } else {
                        // 7
                        self.likesLabel.text = ""
                        self.likeButton.selected = false
                        //self.likesIconImageView.hidden = true
                    }
                }
            }
        }
    }    
    func downloadImage() {
        // if image is not downloaded yet, get it
        // 1
        dispatch_async(dispatch_get_main_queue()){
            
        if (self.post?.image.value == nil) {
            // 2
            self.post?.imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                
                if let data = data {
                    
                    let image = UIImage(data: data, scale:1.0)!
                    // 3
                    self.post!.image.value = image
                }
            }
        }
    }
}
    
    func stringFromUserList(userList: [PFUser]) -> String {
        // 1
        let usernameList = userList.map { user in user.username! }
        // 2
        let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
        
        return commaSeparatedUserList
    }
    
}
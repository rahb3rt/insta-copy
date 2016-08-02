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
    

    

    var post:Post? {
        didSet {
            
            postDisposable?.dispose()
            likeDisposable?.dispose()
            // free memory of image stored with post that is no longer displayed
            // 1
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                postDisposable = post.image.bindTo(postImageView.bnd_image)
                
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                    if let value = value {
                        self.likesLabel.text = self.stringFromUserList(value)
                        self.likeButton.selected = value.contains(PFUser.currentUser()!)
                        //self.likesIconImageView.hidden = (value.count == 0)
                    } else {
                        self.likesLabel.text = ""
                        self.likeButton.selected = false
                        //self.likesIconImageView.hidden = true
                    }
                }
            }
        }
    }
    
        func downloadImage() {
        // 1
        
            dispatch_async(dispatch_get_main_queue()){
                
            
        self.post?.image.value = Post.imageCache[(self.post?.imageFile!.name)!]
        
        // if image is not downloaded yet, get it
        if (self.post?.image.value == nil) {
        
        self.post?.imageFile!.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
        if let data = data {
        let image = UIImage(data: data, scale:1.0)!
        self.post!.image.value = image
        // 2
        Post.imageCache[(self.post?.imageFile!.name)!] = image
                    }
                }
            }
        }
    }
    
    func stringFromUserList(userList: [PFUser]) -> String {
        // 1
        let usernameList = userList.map { user in user.username! }
        // 2
        let commaSeparatedUserList = usernameList.joinWithSeparator(",")
        
        return commaSeparatedUserList
    }
    
}
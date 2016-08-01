import UIKit
import Bond
import Parse



class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIView!
    @IBOutlet weak var moreButton: UIView!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        
    }
    //@IBAction func moreButtonTapped(sender: AnyObject) {
    //}
    @IBAction func likeButtonTapped(sender: AnyObject) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    

    var post: Post! {
        didSet {
            // 1
            if let post = post {
                //2
                // bind the image of the post to the 'postImage' view
                post.image.bindTo(postImageView.bnd_image)
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
    
}
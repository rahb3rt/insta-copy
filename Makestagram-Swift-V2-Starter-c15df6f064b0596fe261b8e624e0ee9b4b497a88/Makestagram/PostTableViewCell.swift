import UIKit
import Bond
import Parse



class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    

    var post: Post? {
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
        if (post?.image.value == nil) {
            // 2
            post?.imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                
                if let data = data {
                    
                    let image = UIImage(data: data, scale:1.0)!
                    // 3
                    self.post!.image.value = image
                }
            }
        }
    }
    
}
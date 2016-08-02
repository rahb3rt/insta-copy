//
//  ParseLoginHelper.swift
//  Makestagram
//
//  Created by Benjamin Encz on 4/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
//import FBSDKCoreKit
import Parse
import ParseUI

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/** 
  This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
  it will call the callback function and provide a 'PFUser' object.
*/


class ParseLoginHelper : NSObject {
  static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
  static let usernameNotFoundErrorCode = 1
  static let usernameNotFoundLocalizedDescription = "Could not retrieve Facebook username"

  let callback: ParseLoginHelperCallback
  
  init(callback: ParseLoginHelperCallback) {
    self.callback = callback
  }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
  
  
  func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
    // Determine if this is a Facebook login

   }
    
  func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.callback(user, nil)
    }

}

extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
}
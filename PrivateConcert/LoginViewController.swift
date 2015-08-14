//
//  LoginViewController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/31/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(PFUser.currentUser() == nil) {
            self.logInViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.DismissButton
            
            var logoView = UIImageView(image: UIImage(named:"loginTitle"))
            
            self.logInViewController.logInView?.logo = logoView
            
            self.logInViewController.delegate = self
            
            var signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "Private Concert"
            
            self.signUpViewController.signUpView?.logo = logoView
            self.signUpViewController.delegate = self
            self.logInViewController.signUpController = self.signUpViewController
        } else {
            self.performSegueWithIdentifier("finishLogin", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Parse Login
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        var alert = UIAlertController(title: "Failed Login", message: "Please enter a valid username and password.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        logInViewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Parse Sign Up
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        var alert = UIAlertController(title: "Failed Signup", message: "Please enter a valid set of information", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        logInViewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User Dismissed Sign Up.")
    }
    
    
    //MARK: Actions
    
    @IBAction func showLoginAction (sender: AnyObject) {
        self.presentViewController(self.logInViewController, animated: true, completion: nil)
    }
    
}



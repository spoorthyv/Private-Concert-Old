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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //If there isnt a current user, open login screen
        if(PFUser.currentUser() == nil) {
            //Set Up Fields
            logInViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .DismissButton
            
            //Set Login Logo and delegate
            var logoView = UIImageView(image: UIImage(named:"loginTitle"))
            self.logInViewController.logInView?.logo = logoView
            self.logInViewController.delegate = self
            
            //Set Signup Logo and delegate
            var logoView2 = UIImageView(image: UIImage(named:"loginTitle"))
            self.signUpViewController.signUpView?.logo = logoView2
            self.signUpViewController.delegate = self
        
            self.logInViewController.signUpController = self.signUpViewController
            
        //Else perform segue to main screen
        } else {
            self.performSegueWithIdentifier("finishLogin", sender: self)
        }
    }
    
//MARK: Parse Login
    
    //If username and password arent blank -> uploads info to check if they are valid
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    //When the user logins successfully -> dismiss loginVC
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //If username and pass are invalid -> display error
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        var alert = UIAlertController(title: "Failed Login", message: "Please enter a valid username and password.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        logInViewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
//MARK: Parse Sign Up
    
    //When the user signs up successfully -> dismiss SignupVC
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //If user signup fails -> show error message
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        var alert = UIAlertController(title: "Failed Signup", message: "Please enter a valid set of information", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        signUpViewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Checks for valid Signup info
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        //Password must be > 4 characters long
        if let password = info["password"] as? String {
            if count(password) >= 5 {
                return true
            }
            else {
                var alert = UIAlertController(title: "Failed Signup", message: "Password must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                signUpViewController.presentViewController(alert, animated: true, completion: nil)
                return false
            }
        }
        //Username must be greater than 2 characters long
        else if let username = info["username"] as? String {
            if count(username) >= 2 {
                return true
            }
            else {
                var alert = UIAlertController(title: "Failed Signup", message: "Usernames must be greater than 2 characters", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                signUpViewController.presentViewController(alert, animated: true, completion: nil)
                return false
            }
        //Calls 'validateEmail' method to check for a valid email
        } else if let email = info["email"] as? String {
            if validateEmail(email){
                return true
            }
            else {
                var alert = UIAlertController(title: "Failed Signup", message: "Enter a Valid Email", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                signUpViewController.presentViewController(alert, animated: true, completion: nil)
                return false
            }
        }
        return false
    }
    
    //Checks for valid email
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
   
    
//MARK: Actions
    
    //Show login screen when login button pressed
    @IBAction func showLoginAction (sender: AnyObject) {
        self.presentViewController(self.logInViewController, animated: true, completion: nil)
    }
    
}



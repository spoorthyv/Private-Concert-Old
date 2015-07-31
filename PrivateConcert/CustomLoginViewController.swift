//
//  CustomLoginViewController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/31/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation

import UIKit
import Parse


class CustomLoginViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    
    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        
        if (count(username.utf16) < 4 || count(password.utf16) < 5) {
            var alert = UIAlertView(title: "Invalid", message: "Username must be great than 4 and password must be greater than 5", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password, block: {(user, error) ->
                Void in
                self.actInd.stopAnimating()
                if (user != nil) {
                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                } else {
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            })
        }
    }
    @IBAction func signupAction(sender: AnyObject) {
        self.performSegueWithIdentifier("signup", sender: self)
    }
    
}

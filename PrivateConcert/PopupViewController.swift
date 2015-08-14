//
//  PopupViewController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/6/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class PopupViewController: UIViewController, UITextFieldDelegate {
    var exSong = Song(title: "", tags: [], musicData: NSData())
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var tagField1: UITextField!
    @IBOutlet weak var tagField2: UITextField!
    @IBOutlet weak var tagField3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        tagField1.delegate = self
        tagField2.delegate = self
        tagField3.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func uploadSong(obj: Song) {
        var className = PFObject(className: "Song")
        className.setObject(obj.name, forKey: "songName")
        className.setObject(obj.tags, forKey: "tags")
        className.setObject(obj.user, forKey: "User")
        
        className.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success == true {
                let audioFile = PFFile(name: "demo.caf", data: self.exSong.audio)
                className["songFile"] = audioFile
                className.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
                    if success == false {
                        println("error in uploading audio file")
                    } else {
                        println("posted successfully")
                    }
                }
            } else {
                println(error)
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("cancelPopup", sender: self)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if (titleField.text.isEmpty){
            var alert = UIAlertView(title: "Invalid Title", message: "Please Enter a Valid Song Title", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            exSong.name = titleField.text!
        }
        if (tagField1 != nil) {
            exSong.tags.append(tagField1.text!)
        }
        if (tagField2 != nil) {
            exSong.tags.append(tagField2.text!)
        }
        if (tagField3 != nil) {
            exSong.tags.append(tagField3.text!)
        }
        
        uploadSong(exSong)
        var mainTableViewCont = MainTableViewController()
        mainTableViewCont.reloadTableQuery()
        performSegueWithIdentifier("cancelPopup", sender: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    func keyboardWillShow(sender: NSNotification) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if(self.view.frame.origin.y > -106) {
                self.view.frame.origin.y -= 106
            }
        })
    }
    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.frame.origin.y += 106
        })
    }

    
}

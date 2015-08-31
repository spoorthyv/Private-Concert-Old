//
//  MainTableViewController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/27/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import AVKit
import Mixpanel
import AudioToolbox

class MainTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
//MARK: Variables
    let mixpanel: Mixpanel = Mixpanel.sharedInstance()
    
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    var AudioPlayer = AVPlayer()
    var audioPlayer2 = AVAudioPlayer()
    
    var IDArray: [String] = [""]
    var nameArray: [String] = [""]
    var tagsArray: [String] = [""]
    var flagArray = NSArray()
    var flagPointerArray: [PFObject] = [PFObject(className: "Flag")]
    var flaggedSongIDArray: [String] = [""]
    

//MARK: View Did Load
    
    //When View Loads: load tableview data and add a refresh control to tableview
    override func viewDidLoad() {
        super.viewDidLoad()
        mixpanel.track("Open Concert Room")
        
        reloadTableQuery()
        
        var lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        lpgr.minimumPressDuration = 0.7
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.tableView.addGestureRecognizer(lpgr)
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "reloadTableQuery", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
    }
    
//MARK: Table View
    
    //Queries all objects from Parse. Puts data into 3 arrays. Refreshes tableview
    func reloadTableQuery(){
        
        var ObjectIDQuery2 = PFQuery(className: "Flag")
        ObjectIDQuery2.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        ObjectIDQuery2.findObjectsInBackgroundWithBlock({
            (objectsArray: [AnyObject]?, error: NSError?) -> Void in
            
            self.flagArray = objectsArray as! [PFObject]
            
            var tempFlagArray = objectsArray as! [PFObject]
            
            self.flagPointerArray = [PFObject](count: tempFlagArray.count, repeatedValue: PFObject(className: "Flag"))
            self.flaggedSongIDArray = [String](count: tempFlagArray.count, repeatedValue: "")
            
            if tempFlagArray.count > 0 {
                for i in 0...tempFlagArray.count-1 {
                    self.flagPointerArray[i] = (tempFlagArray[i].valueForKey("toSong") as! PFObject)
                    self.flaggedSongIDArray[i] = self.flagPointerArray[i].valueForKey("objectId") as! String
                    self.tableView.reloadData()
                }
                //Else display an error
            }
        
        })

        
        var ObjectIDQuery = PFQuery(className: "Song")
        ObjectIDQuery.findObjectsInBackgroundWithBlock({
            (objectsArray: [AnyObject]?, error: NSError?) -> Void in
            
            var objectIDs = objectsArray as! [PFObject]
            
            //Create blank arrays of the correct size
            self.IDArray = [String](count: objectIDs.count, repeatedValue: " ")
            self.nameArray = [String](count: objectIDs.count, repeatedValue: " ")
            self.tagsArray = [String](count: objectIDs.count, repeatedValue: " ")
            //self.flagArray = Array(count:objectIDs.count, repeatedValue: [PFUser](count:0, repeatedValue:PFUser()))

            //If there is more than 1 song, then load the data
            if objectIDs.count > 0 {
                for i in 0...objectIDs.count-1 {
                    self.IDArray[i] = (objectIDs[i].valueForKey("objectId") as! String)
                    self.nameArray[i] = (objectIDs[i].valueForKey("songName") as! String)
                    self.tagsArray[i] = (self.convertTagsToString(objectIDs[i].valueForKey("tags") as! [String]))
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                }
            //Else display an error
            } else {
                var alert = UIAlertController(title: "No Songs :(", message: "Be the first to share a song!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
        
    }
    
    //# of rows in table = size of IDArray
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IDArray.count
    }
    
    //For each cell, set the title,tagLabel,and button rows. When you click button call playPause method
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MainTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MainTableViewCell
        
        //set the title and tags of each cell
        //if nameArray[indexPath.row] == flagArray[0].valueForKey("toSong") as! [String] {
        if isInArray(IDArray[indexPath.row], iDArray: flaggedSongIDArray) {
            cell.titleLabel?.text = " "
            cell.tagsLabel?.text = " "
            cell.isFlaggedLabel?.text = "FLAGGED"
            
            //button tag = row of the button
            cell.playButton.tag = indexPath.row
            
        } else {
            cell.titleLabel?.text = nameArray[indexPath.row]
            cell.tagsLabel?.text = tagsArray[indexPath.row]
            cell.isFlaggedLabel?.text = " "
            
            //button tag = row of the button
            cell.playButton.tag = indexPath.row

        }
        
        println("Button index: \(cell.playButton.tag), Cell index: \(indexPath.row)")
        
        //When button is pressed call 'playPause'
        cell.playButton.addTarget(self, action: "playPause:", forControlEvents: .TouchUpInside)
        
        //Set image of each cell's playButton: If the currRow = the buttons row -> change image to pause
        setPlayButtonImage(cell)
        
        return cell
        
    }
    
//MARK: Audio
    
    //If the button is clicked, then either play the media associated with its cell or pause the player
    func playPause(sender:UIButton) {
        mixpanel.track("Play button tapped")
        
        let view = sender.superview!
        let cell = view.superview as! MainTableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        if (!isPaused && (currRow != sender.tag) && (currRow != -1)) {
            if (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0)) == nil) {
                println("nil")
                currRow = sender.tag
                grabSong(sender.tag)
                isPaused = false
            } else {
                println("notnil")
                var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0))  as! MainTableViewCell
                isPaused = true
                cell.playButton.setImage(UIImage(named: "Play1") as UIImage?, forState: .Normal)
                isPaused = true
                currRow = sender.tag
                sender.setImage(UIImage(named: "Pause2") as UIImage?, forState: .Normal)
                grabSong(sender.tag)
                
                isPaused = false
            }
        } else if (isPaused) {
            grabSong(sender.tag)
            isPaused = false
            sender.setImage(UIImage(named: "Pause2") as UIImage?, forState: .Normal)
            currRow = sender.tag
            
        } else {
            self.AudioPlayer.pause()
            isPaused = true
            sender.setImage(UIImage(named: "Play1") as UIImage?, forState: .Normal)
            currRow = -1
        }
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        mixpanel.track("Song Did Finish")
        
        println(currRow)
        if self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0)) == nil {
            println("nil")
            currRow = -1
            isPaused = true
        } else {
            println("notnil")
            var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0))  as! MainTableViewCell
            isPaused = true
            cell.playButton.setImage(UIImage(named: "Play1") as UIImage?, forState: .Normal)
            isPaused = true
            currRow = -1
        }
    }
    
    //queries song, loads it into AVAudioPlayer and plays it
    func grabSong(songNumber: Int){
        self.session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        var songQuery = PFQuery(className: "Song")
        songQuery.getObjectInBackgroundWithId(IDArray[songNumber], block: {
            (object: PFObject?, error: NSError?) -> Void in
            if let AudioFileURLTemp = object?.objectForKey("songFile")?.url{
                let item = AVPlayerItem(URL: NSURL(string: AudioFileURLTemp!))
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
                self.AudioPlayer = AVPlayer(playerItem: item)
                self.AudioPlayer.play()
            }
        })
    }

    
//MARK: Flagging
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizerState.Began {
            let p = gestureReconizer.locationInView(self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(p)
            
            if let index = indexPath {
                var cell = self.tableView.cellForRowAtIndexPath(indexPath!)
                // do stuff with your cell, for example print the indexPath
                println(index.row)
                
                playSound()
                
                showFlagActionSheetForPost(index.row)
            } else {
                println("Could not find index path")
            }
        }
    }
    func showFlagActionSheetForPost(objectRow: Int) {
        let alertController = UIAlertController(title: nil, message: "Do you want to flag this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Flag", style: UIAlertActionStyle.Destructive) { (alert) in
            self.flagPost(self.IDArray[objectRow])
        }
        
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func flagPost(objectID: String) {
        if isInArray(objectID, iDArray: flaggedSongIDArray) {
            var alert = UIAlertController(title: "Failed Flag", message: "You already flagged this post. We will look at the post and see if there is anything wrong!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            mixpanel.track("Flagged Song")
            var ObjectIDQuery2 = PFQuery(className: "Song")
            ObjectIDQuery2.whereKey("objectId", equalTo: objectID)
            var flaggedSong: PFObject = ObjectIDQuery2.findObjects()?.first as! PFObject
            
            let flagObject = PFObject(className: "Flag")
            flagObject.setObject(PFUser.currentUser()!, forKey: "fromUser")
            flagObject.setObject(flaggedSong, forKey: "toSong")
            
            let ACL = PFACL(user: PFUser.currentUser()!)
            ACL.setPublicReadAccess(true)
            flagObject.ACL = ACL
            
            flagObject.save()
            reloadTableQuery()
        }
    }
    
    
//MARK: Helper Methods
    func setPlayButtonImage(cell: MainTableViewCell){
        if cell.playButton.tag == currRow {
            cell.playButton.setImage(UIImage(named: "Pause2") as UIImage?, forState: .Normal)
        } else {
            cell.playButton.setImage(UIImage(named: "Play1") as UIImage?, forState: .Normal)
        }
    }
    
    //Converts array of strings into one String with tags seperated by " | "
    func convertTagsToString(tagArray: [String]) -> String{
        var tempString = ""
        var tempArray = tagArray
        for var i = 0; i < tempArray.count; i++ {
            if tempArray[i] == ""{
                tempArray.removeAtIndex(i)
            }
        }
        if tempArray.count > 0 {
            tempString = tempArray[0]
            for var i = 1; i < tempArray.count; i++ {
                tempString += "  |  " + tempArray[i]
            }
        }
        return tempString
    }
    
    func isInArray(objectId: String, iDArray: [String]) -> Bool{
        for var i = 0; i < iDArray.count; i++ {
            if iDArray[i] == objectId{
                return true
            }
        }
        return false
    }
    
    func playSound() {
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Lock", ofType: "mp3")!)
        var error:NSError?
        audioPlayer2 = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer2.prepareToPlay()
        audioPlayer2.play()
    }


}

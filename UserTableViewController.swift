//
//  UserTableViewController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/3/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//


import UIKit
import Parse
import AVFoundation
import AVKit
import Mixpanel

class UserTableViewController: UITableViewController {
    
    var grayBackroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    var AudioPlayer = AVPlayer()
    
    var IDArray: [String] = [""]
    var nameArray: [String] = [""]
    var tagsArray: [String] = [""]
    var numberOfObjects: Int = 0
    
    let mixpanel: Mixpanel = Mixpanel.sharedInstance()
    
    
    //When View Loads: load tableview data and add a refresh control to tableview
    override func viewDidLoad() {
        super.viewDidLoad()
        mixpanel.track("Open My Songs")
        
        reloadTableQuery()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "reloadTableQuery", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    
    //Queries all objects from Parse. Puts data into 3 arrays. Refreshes tableview
    func reloadTableQuery(){
        var ObjectIDQuery = PFQuery(className: "Song")
        ObjectIDQuery.whereKey("User", equalTo: PFUser.currentUser()!)
        ObjectIDQuery.findObjectsInBackgroundWithBlock({
            (objectsArray: [AnyObject]?, error: NSError?) -> Void in
            
            var objectIDs = objectsArray as! [PFObject]
            
            //NSLog("\(objectIDs)")
            self.IDArray = [String](count: objectIDs.count, repeatedValue: " ")
            self.nameArray = [String](count: objectIDs.count, repeatedValue: " ")
            self.tagsArray = [String](count: objectIDs.count, repeatedValue: " ")
            
            self.numberOfObjects = objectIDs.count
            if objectIDs.count > 0 {
                //ProgressHUD.show("Loading...")
                for i in 0...objectIDs.count-1 {
                    self.IDArray[i] = (objectIDs[i].valueForKey("objectId") as! String)
                    self.nameArray[i] = (objectIDs[i].valueForKey("songName") as! String)
                    self.tagsArray[i] = (self.convertTagsToString(objectIDs[i].valueForKey("tags") as! [String]))
                    //println(objectIDs[i].valueForKey("tags") as! [String])
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                    self.refreshControl!.endRefreshing()
                    //ProgressHUD.dismiss()
                }
            } else {
                let screenSize: CGRect = self.view.bounds
                var DynamicView=UIView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
                DynamicView.backgroundColor = self.grayBackroundColor
                
                var sadImage = UIImage(named: "NoSongs")
                var imageView = UIImageView(image: sadImage)
//                let xCenterConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
//                self.view.addConstraint(xCenterConstraint)
//                
//                let yCenterConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
//                self.view.addConstraint(yCenterConstraint)
                
                imageView.center = CGPoint(x: screenSize.width/2, y: (149 + (screenSize.height - 149)/6))
                
                self.view.addSubview(DynamicView)
                self.view.addSubview(imageView)
                self.refreshControl!.endRefreshing()
                
                
                ProgressHUD.dismiss()
//                var alert = UIAlertController(title: "No Songs :(", message: "You haven't shared any songs.", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertActionStyle.Cancel, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfObjects
    }
    
    //For each cell, set the title and tags. When you click button call playPause method
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UserTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UserTableViewCell
        
        cell.titleLabel?.text = nameArray[indexPath.row]
        cell.tagsLabel?.text = tagsArray[indexPath.row]
        
        cell.playButton.buttonRow = indexPath.row
        
        println("Button index: \(cell.playButton.buttonRow), Cell index: \(indexPath.row)")
        
        cell.playButton.addTarget(self, action: "playPause:", forControlEvents: .TouchUpInside)
        
        setImage(cell)
        
        return cell
        
    }
    
    func setImage(cell: UserTableViewCell){
        if cell.playButton.buttonRow == currRow {
            cell.playButton.setImage(UIImage(named: "Pause2") as UIImage?, forState: .Normal)
            //cell.playButton.isPaused = true
        } else {
            cell.playButton.setImage(UIImage(named: "Play5") as UIImage?, forState: .Normal)
            //cell.playButton.isPaused = false
        }
    }
    
    //If the button is clicked, then either play the media associated with its cell or pause the player
    func playPause(sender:MediaButton) {
        mixpanel.track("Play button tapped")
        let button = sender as MediaButton
        let view = button.superview!
        let cell = view.superview as! UserTableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        if (!isPaused && (currRow != sender.buttonRow) && (currRow != -1)) {
            if (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0)) == nil) {
                println("nil")
                currRow = sender.buttonRow
                grabSong(sender.buttonRow)
                isPaused = false
                //sender.setImage(UIImage(named: "Pause2") as UIImage?, forState: .Normal)
            } else {
                println("notnil")
                var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0))  as! UserTableViewCell
                isPaused = true
                cell.playButton.setImage(UIImage(named: "Play5") as UIImage?, forState: .Normal)
                isPaused = true
                currRow = sender.buttonRow
                sender.setImage(UIImage(named: "Pause2") as UIImage?, forState: .Normal)
                grabSong(sender.buttonRow)
                
                isPaused = false
            }
        } else if (isPaused) {
            grabSong(sender.buttonRow)
            isPaused = false
            sender.setImage(UIImage(named: "Pause2") as UIImage?, forState: .Normal)
            currRow = sender.buttonRow
            
        } else {
            self.AudioPlayer.pause()
            isPaused = true
            sender.setImage(UIImage(named: "Play5") as UIImage?, forState: .Normal)
            currRow = -1
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
    
    func playerDidFinishPlaying(note: NSNotification) {
        mixpanel.track("Song Did Finish")
        println(currRow)
        if self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0)) == nil {
            println("nil")
            currRow = -1
            isPaused = true
        } else {
            println("notnil")
            var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0))  as! UserTableViewCell
            isPaused = true
            cell.playButton.setImage(UIImage(named: "Play5") as UIImage?, forState: .Normal)
            isPaused = true
            currRow = -1
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        var ObjectIDQuery2 = PFQuery(className: "Song")
        ObjectIDQuery2.whereKey("objectId", equalTo: IDArray[indexPath.row])
        var flaggedSong: PFObject = ObjectIDQuery2.findObjects()?.first as! PFObject
        flaggedSong.delete()
        
        IDArray = [""]
        nameArray = [""]
        tagsArray = [""]

        reloadTableQuery()
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("index row = \(indexPath.row)")
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! UserTableViewCell
        // println("\(cell.playButton.buttonRow)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
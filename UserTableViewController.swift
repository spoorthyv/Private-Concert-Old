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

class UserTableViewController: UITableViewController {
    
    var grayBackroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    var AudioPlayer = AVPlayer()
    
    var IDArray: [String] = [""]
    var nameArray: [String] = [""]
    var tagsArray: [String] = [""]
    
    
    //When View Loads: load tableview data and add a refresh control to tableview
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            if objectIDs.count > 0 {
                for i in 0...objectIDs.count-1 {
                    self.IDArray[i] = (objectIDs[i].valueForKey("objectId") as! String)
                    self.nameArray[i] = (objectIDs[i].valueForKey("songName") as! String)
                    self.tagsArray[i] = (self.convertTagsToString(objectIDs[i].valueForKey("tags") as! [String]))
                    //println(objectIDs[i].valueForKey("tags") as! [String])
                    
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                }
            }
        })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IDArray.count
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
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("index row = \(indexPath.row)")
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! UserTableViewCell
        // println("\(cell.playButton.buttonRow)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
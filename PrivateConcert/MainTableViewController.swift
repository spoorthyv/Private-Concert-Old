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

class MainTableViewController: UITableViewController {
    
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
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MainTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MainTableViewCell
        
        cell.titleLabel?.text = nameArray[indexPath.row]
        cell.tagsLabel?.text = tagsArray[indexPath.row]
        
        cell.playButton.cellRow = indexPath.row
        cell.playButton.addTarget(self, action: "playPause:", forControlEvents: .TouchUpInside)
        
        return cell
        
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
                //self.AudioPlayer = AVPlayer(URL: NSURL(string: AudioFileURLTemp!))
                let item = AVPlayerItem(URL: NSURL(string: AudioFileURLTemp!))
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
                self.AudioPlayer = AVPlayer(playerItem: item)
                self.AudioPlayer.play()
            }
        })
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        println("swag sauce")
        
        println("\(currRow)")
        var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currRow, inSection: 0))  as! MainTableViewCell
        cell.playButton.isPaused = true
        cell.playButton.setImage(UIImage(named: "Play1") as UIImage?, forState: .Normal)
        isPaused = true
    }
    
    //pauses song
    func pauseSong(){
        self.AudioPlayer.pause()
    }
    
    //If the button is clicked, then either play the media associated with its cell or pause the player
    func playPause(sender:MediaButton) {
        if (isPaused) {
            grabSong(sender.cellRow)
            isPaused = false

        } else {
            pauseSong()
            isPaused = true
        
        }
    }
    
    
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
//        println("\(currRow)")
//        var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(index: currRow))  as! MainTableViewCell
//        cell.playButton.isPaused = true
//        cell.playButton.setImage(UIImage(named: "Play1") as UIImage?, forState: .Normal)
//        isPaused = true
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! MainTableViewCell
        println("\(cell.playButton.cellRow)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    }
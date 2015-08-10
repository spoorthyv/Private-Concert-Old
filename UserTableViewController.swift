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

class UserTableViewController: UITableViewController, AVAudioPlayerDelegate {
    
    var grayBackroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    var AudioPlayer = AVPlayer()
    var selectedSongNumber = Int()
    
    var IDArray = [String]()
    var nameArray = [String]()
    var tagsArray = [String]()
    
    let playImage = UIImage(named: "Play1") as UIImage?
    let pauseImage = UIImage(named: "Pause1") as UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        var ObjectIDQuery = PFQuery(className: "Song")
        
        
        ObjectIDQuery.includeKey("Song")
        ObjectIDQuery.whereKey("User", equalTo: PFUser.currentUser()!)
        
        
        ObjectIDQuery.findObjectsInBackgroundWithBlock({
            (objectsArray: [AnyObject]?, error: NSError?) -> Void in
            
            var objectIDs = objectsArray as! [PFObject]
            
            NSLog("\(objectIDs)")
            
            if objectIDs.count > 0 {
                for i in 0...objectIDs.count-1 {
                    self.IDArray.append(objectIDs[i].valueForKey("objectId") as! String)
                    self.nameArray.append(objectIDs[i].valueForKey("songName") as! String)
                    self.tagsArray.append(self.convertTagsToString(objectIDs[i].valueForKey("tags") as! [String]))
                    println(objectIDs[i].valueForKey("tags") as! [String])
                    self.tableView.reloadData()
                }
            }

        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IDArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorColor = grayBackroundColor
        tableView.separatorStyle = .None
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UserTableViewCell
        
        cell.titleLabel?.text = nameArray[indexPath.row]
        cell.tagsLabel?.text = tagsArray[indexPath.row]
        
        selectedSongNumber = indexPath.row
        cell.playButton.cellRow = indexPath.row
        //cell.playButton.addTarget(self, action: "playPause:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func convertTagsToString(tagArray: [String]) -> String{
        var tempString = tagArray[0]
        for var i = 1; i < tagArray.count; i++ {
            tempString += "  |  " + tagArray[i]
        }
        return tempString
    }
    
    func playSong(songNumber: Int){
        self.session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        var songQuery = PFQuery(className: "Song")
        songQuery.getObjectInBackgroundWithId(IDArray[songNumber], block: {
            (object: PFObject?, error: NSError?) -> Void in
            if let AudioFileURLTemp = object?.objectForKey("songFile")?.url{
                self.AudioPlayer = AVPlayer(URL: NSURL(string: AudioFileURLTemp!))
                self.AudioPlayer.play()
            }
        })
    }
    
    func pauseSong(selectedSongNumber: Int){
        self.AudioPlayer.pause()
    }
    
    func playPause(sender:MediaButton) {
        if (isPaused) {
            playSong(sender.cellRow)
            isPaused = false
            
        } else {
            pauseSong(sender.cellRow)
            isPaused = true
        }
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSongNumber = indexPath.row
        println(selectedSongNumber)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
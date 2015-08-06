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

class MainTableViewController: UITableViewController, AVAudioPlayerDelegate {
    
    var grayBackroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    var AudioPlayer = AVPlayer()
    
    var IDArray = [String]()
    var nameArray = [String]()
    var tagsArray = [String]()
    

//    let playImage = UIImage(named: "Play1") as UIImage?
//    let pauseImage = UIImage(named: "Pause1") as UIImage?

    var isPaused = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ObjectIDQuery = PFQuery(className: "Song")
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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IDArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MainTableViewCell
        
        cell.titleLabel?.text = nameArray[indexPath.row]
        cell.tagsLabel?.text = tagsArray[indexPath.row]
        
        cell.playButton.cellRow = indexPath.row
        cell.playButton.addTarget(self, action: "playPause:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func convertTagsToString(tagArray: [String]) -> String{
        var tempString = ""
        if tagArray.count == 0 {
            return ""
        }
        for i in 0...tagArray.count-1 {
            if tagArray[i] != "" {
                tempString = tagArray[i] + " | "
            }
        }
        return tempString
    }
    
    func grabSong(songNumber: Int){
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
            grabSong(sender.cellRow)
            isPaused = false
            
        } else {
            pauseSong(sender.cellRow)
            isPaused = true
        }
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
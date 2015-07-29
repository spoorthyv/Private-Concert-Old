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
    
    var AudioPlayer = AVPlayer()
    var selectedSongNumber = Int()
    
    var IDArray = [String]()
    var nameArray = [String]()
    var tagsArray = [String]()
    
    //images
    let playImage = UIImage(named: "GreenPlay") as UIImage?
    let pauseImage = UIImage(named: "PurplePause") as UIImage?

    var isPaused = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ObjectIDQuery = PFQuery(className: "Song")
        ObjectIDQuery.findObjectsInBackgroundWithBlock({
            (objectsArray: [AnyObject]?, error: NSError?) -> Void in
            
            var objectIDs = objectsArray as! [PFObject]
            
            NSLog("\(objectIDs)")
            
            for i in 0...objectIDs.count-1 {
                self.IDArray.append(objectIDs[i].valueForKey("objectId") as! String)
                self.nameArray.append(objectIDs[i].valueForKey("songName") as! String)
                self.tagsArray.append(self.convertTagsToString(objectIDs[i].valueForKey("tags") as! [String]))
                println(objectIDs[i].valueForKey("tags") as! [String])
                self.tableView.reloadData()
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IDArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MainTableViewCell
        
        cell.titleLabel?.text = nameArray[indexPath.row]
        cell.tagsLabel?.text = tagsArray[indexPath.row]
        
        selectedSongNumber = indexPath.row
        cell.playButton.cellRow = indexPath.row
        cell.playButton.addTarget(self, action: "playPause:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func convertTagsToString(tagArray: [String]) -> String{
        var tempString = tagArray[0]
        for var i = 1; i < tagArray.count; i++ {
            tempString += "  |  " + tagArray[i]
        }
        return tempString
    }
    
    func grabSong(songNumber: Int){
        var songQuery = PFQuery(className: "Song")
        //println(selectedSongNumber)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSongNumber = indexPath.row
        println(selectedSongNumber)
        //grabSong(indexPath.row)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
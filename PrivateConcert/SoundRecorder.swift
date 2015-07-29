//
//  SoundRecorder.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/28/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class SoundRecorder: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer:AVAudioPlayer!
    var soundFileURL: NSURL!
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    
    var exSong = Song(title: "hi", tags: ["howdy"])
    let fileName = "demo.caf"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    
    //creates an AVAudioRecorder object with the correct settings. Gives it a URL and settings
    func setupRecorder() {
        //set the settings for recorder
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2, AVSampleRateKey : 44100.0
        ]
        var error: NSError?
        soundRecorder = AVAudioRecorder(URL: getFileURL(), settings: recordSettings as [NSObject : AnyObject], error: &error)
        if let err = error {
            println("AVAudioRecorder error: \(err.localizedDescription)")
        } else {
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }
        session.requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                println("granted")
                self.session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
                self.session.setActive(true, error: nil)
            }else{
                println("not granted")
            }
        })
    }
    
    //gets URL of file by attaching the filename to the URL of cache
    func getFileURL() -> NSURL {
        
        let path = getCacheDirectory().stringByAppendingPathComponent(fileName)
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath!
    }
    
    //return string of URL for cache
    func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory,.UserDomainMask, true) as! [String]
        
        return paths[0]
    }
    
    //setup player by passing it a URL
    func preparePlayer() {
        var error: NSError?
        
        soundPlayer = AVAudioPlayer(contentsOfURL: getFileURL(), error: &error)
        
        if let err = error {
            println("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }
    
    //if the button labeled "record" is pressed record audio, then switch the buttons to correct labels
    @IBAction func recordSound(sender: UIButton) {
        if (sender.titleLabel?.text == "Record"){
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            playButton.enabled = false
        }
        else {
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
            addNamestoParse(exSong)
        }
    }
    
    @IBAction func playSound(sender: UIButton) {
        if (sender.titleLabel?.text == "Play"){
            self.session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
            recordButton.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
        }
    }
    
    func addNamestoParse(obj: Song) {
        var className = PFObject(className: "Song")
        className.setObject(obj.name, forKey: "songName")
        className.setObject(obj.tags, forKey: "tags")
        className.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success == true {
                let audioFile = PFFile(name: "demo.caf", data: NSData(contentsOfURL: self.getFileURL())!)
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
    
    
    //Useless stuff
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        playButton.enabled = true
        recordButton.setTitle("Record", forState: .Normal)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Error while recording audio \(error.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        recordButton.enabled = true
        playButton.setTitle("Play", forState: .Normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Error while playing audio \(error.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


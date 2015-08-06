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


class SoundRecorder: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var isRecordingLabel: UILabel!
    
    var soundRecorder: AVAudioRecorder!
    var soundFileURL: NSURL!
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    
    
    
//    @IBOutlet weak var titleField: UITextField!
//    @IBOutlet weak var tag1Field: UITextField!
//    @IBOutlet weak var tag2Field: UITextField!
//    @IBOutlet weak var tag3Field: UITextField!
    
    var exSong = Song(title: "", tags: [], musicData: NSData())
    let fileName = "demo.caf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        println("\(getCacheDirectory())")
    }
    
    //creates an AVAudioRecorder object with the correct settings. Gives it a URL and settings
    func setupRecorder() {
        
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
    
    //switch state of whether or not we are recording
    @IBAction func recordSound(sender: RecordButton) {
        if (sender.isRecording == false){
            soundRecorder.record()
            isRecordingLabel.text = "Recording"
            hasPopup = true
            
        }
        else {
            soundRecorder.stop()
            
            var audioAsset: AVURLAsset = AVURLAsset(URL: getFileURL(), options: nil)
            var audioDuration: CMTime = audioAsset.duration
            var audioDurationSeconds: Float64 = CMTimeGetSeconds(audioDuration)
            println("the song is \(audioDurationSeconds) seconds long")
            
            isRecordingLabel.text = "Share Your Voice!"
            hasPopup = false
        }
    }
    
    //Upload songname, tags, user, and songfile
//    func uploadSong(obj: Song, musicFile: NSData) {
//        var className = PFObject(className: "Song")
//        className.setObject(obj.name, forKey: "songName")
//        className.setObject(obj.tags, forKey: "tags")
//        className.setObject(obj.user, forKey: "User")
//        
//        className.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if success == true {
//                //let audioFile = PFFile(name: "demo.caf", data: NSData(contentsOfURL: self.getFileURL())!)
//                let audioFile = PFFile(name: "demo.caf", data: musicFile)
//                className["songFile"] = audioFile
//                className.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
//                    if success == false {
//                        println("error in uploading audio file")
//                    } else {
//                        println("posted successfully")
//                    }
//                }
//            } else {
//                println(error)
//            }
//        }
//    }
    
//    @IBAction func cancelButtonPressed(sender: AnyObject) {
//        performSegueWithIdentifier("cancelPopup", sender: self)
//        
//        var ObjectIDQuery = PFQuery(className: "Song")
//        ObjectIDQuery.findObjectsInBackgroundWithBlock({
//            (objectsArray: [AnyObject]?, error: NSError?) -> Void in
//            
//            var objectIDs = objectsArray as! [PFObject]
//            
//            objectIDs[objectIDs.count].deleteInBackground()
//        })
        //delete object
//    }
//    @IBAction func saveButtonPressed(sender: AnyObject) {
//        if (titleField.text! == ""){
//            var alert = UIAlertView(title: "Invalid Title", message: "Please Enter a Valid Song Title", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//        } else {
//            exSong.name = titleField.text!
//        }
//        if (tag1Field != nil) {
//            exSong.tags.append(tag1Field.text!)
//        }
//        if (tag2Field != nil) {
//            exSong.tags.append(tag2Field.text!)
//        }
//        if (tag3Field != nil) {
//            exSong.tags.append(tag3Field.text!)
//        }
//        
//        var audioAsset: AVURLAsset = AVURLAsset(URL: getFileURL(), options: nil)
//        var audioDuration: CMTime = audioAsset.duration
//        var audioDurationSeconds: Float64 = CMTimeGetSeconds(audioDuration)
//        println("the song is \(audioDurationSeconds) seconds long")
//        
//        uploadSong(exSong, musicFile: musicData)
//        performSegueWithIdentifier("cancelPopup", sender: self)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPopup" {
            let popupVC: PopupViewController = segue.destinationViewController as! PopupViewController
            popupVC.exSong = exSong
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        exSong.audio = NSData(contentsOfURL: getFileURL())!
        
        performSegueWithIdentifier("showPopup", sender: self)
        
        
    }
    
    //Useless stuff
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Error while recording audio \(error.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


//var audioAsset: AVURLAsset = AVURLAsset(URL: getFileURL(), options: nil)
//var audioDuration: CMTime = audioAsset.duration
//var audioDurationSeconds: Float64 = CMTimeGetSeconds(audioDuration)



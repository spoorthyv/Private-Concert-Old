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
    
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var isRecordingLabel: UILabel!
    
    var soundRecorder: AVAudioRecorder!
    var soundFileURL: NSURL!
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    
    var exSong = Song(title: "", tags: [], musicData: NSData())
    let fileName = "demo.caf"
    
    //When view loads, setup audio recorder
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    
    //creates an AVAudioRecorder object with the correct settings. Gives it a URL and settings
    func setupRecorder() {
        
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Low.rawValue,
            AVEncoderBitRateKey : 160000,
            AVNumberOfChannelsKey: 1, AVSampleRateKey : 16000.0
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
    
    //When audio finished saving locally, save the audio file and perform segue to PopupViewController
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        exSong.audio = NSData(contentsOfURL: getFileURL())!
        performSegueWithIdentifier("showPopup", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPopup" {
            let popupVC: PopupViewController = segue.destinationViewController as! PopupViewController
            popupVC.exSong = exSong
        }
    }
    
    //Useless stuff
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Error while recording audio \(error.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}




//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Yu Qi Hao on 1/25/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var btnStopRecord: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tapToRecord.hidden = false
        btnStopRecord.hidden = true
        btnRecord.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        tapToRecord.hidden = true
        recordingInProgress.hidden = false
        btnStopRecord.hidden = false
        btnRecord.enabled = false

        let filePath = getAudioFileName()
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        audioRecorder = try! AVAudioRecorder(URL: filePath, settings:[String: String]())
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecordAudio(sender: UIButton) {
        //TODO: Hide Record in progresss
        recordingInProgress.hidden = true
        //TODO: Stop record user's voice
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        audioRecorder.stop()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Record error")
            btnRecord.enabled = true
            btnStopRecord.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    private func getAudioFileName() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        return filePath!
    }
}


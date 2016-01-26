//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yu Qi Hao on 1/25/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
            let filePathUrl = NSURL.fileURLWithPath(filePath)
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl)
            } catch {
                //handle error
            }
            audioPlayer.enableRate = true
        } else {
            print("File is empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.rate = 1.5
        self.playAudio()
    }
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.rate = 0.5
        self.playAudio()
    }

    @IBAction func stopPlayAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    private func playAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

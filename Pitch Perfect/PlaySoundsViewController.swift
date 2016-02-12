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
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        resetAudioPlayer()
        audioPlayer.rate = 1.5
        playAudio()
    }
    @IBAction func playSlowAudio(sender: UIButton) {
        resetAudioPlayer()
        audioPlayer.rate = 0.5
        playAudio()
    }

    @IBAction func stopPlayAudio(sender: UIButton) {
        resetAudioPlayer()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(2000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    private func playAudio() {
        resetAudioPlayer()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    private func playAudioWithVariablePitch(pitch: Float) {
        resetAudioPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    private func resetAudioPlayer() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
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

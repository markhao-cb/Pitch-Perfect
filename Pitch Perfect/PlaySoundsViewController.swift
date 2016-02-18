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

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        resetAudioPlayer()
        playAudio(1.5)
    }
    @IBAction func playSlowAudio(sender: UIButton) {
        resetAudioPlayer()
        playAudio(0.5)
    }

    @IBAction func stopPlayAudio(sender: UIButton) {
        resetAudioPlayer()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(2000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithReverb(50, preset: .LargeHall2)
    }
    private func playAudio(rate: Float) {
        resetAudioPlayer()
        audioPlayer.rate = rate
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
    
    private func playAudioWithReverb(wetDryMix: Float, preset: AVAudioUnitReverbPreset) {
        resetAudioPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let audioUnitReverb = AVAudioUnitReverb()
        audioUnitReverb.loadFactoryPreset(preset)
        audioUnitReverb.wetDryMix = wetDryMix
        audioEngine.attachNode(audioUnitReverb)
        
        audioEngine.connect(audioPlayerNode, to: audioUnitReverb, format: nil)
        audioEngine.connect(audioUnitReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    private func resetAudioPlayer() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}

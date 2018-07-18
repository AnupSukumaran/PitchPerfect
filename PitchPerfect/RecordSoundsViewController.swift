//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sukumar Anup Sukumaran on 15/07/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    //MARK: Declarations & Outlets
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var tapToRecordLabel: UILabel!
    
    @IBOutlet weak var recordAudio: UIButton!
    
    @IBOutlet weak var StopToRecord: UIButton!
    
    
    
    
    
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopToRecord.isEnabled = false
    }
    
    func RecordingSound() {
        
        tapToRecordLabel.text = "Recording In Progress"
        congfigureUI(recordAudioEnabled: false, StopToRecordEnabled: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func StopRecording() {
        
        tapToRecordLabel.text = "Tap To Record"
        congfigureUI(recordAudioEnabled: true, StopToRecordEnabled: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }

    func congfigureUI(recordAudioEnabled: Bool, StopToRecordEnabled: Bool) {
        recordAudio.isEnabled = recordAudioEnabled
        StopToRecord.isEnabled = StopToRecordEnabled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordAudioURL
        }
    }
    
    
    
    
   
    //MARK: Actions
    
    @IBAction func recordAudio(_ sender: Any) {
        
        RecordingSound()
        
    }
    
    @IBAction func StopToRecord(_ sender: Any) {
        
       StopRecording()
        
    }
    
    
    

}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording failed")
        }
    }
    
}


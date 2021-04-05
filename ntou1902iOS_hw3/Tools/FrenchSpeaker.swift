//
//  Speecher.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/3.
//

import Foundation
import AVFoundation
class FrenchSpeaker{
    private var words2speak: String!
    let synthesizer = AVSpeechSynthesizer()
    func setWords2Speak(words2speak:String){
        self.words2speak = words2speak
    }
    func speakWords(){
        let utterance =  AVSpeechUtterance(string: self.words2speak)
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        //utterance.pitchMultiplier = 2
        //utterance.rate = 0.1
        self.synthesizer.speak(utterance)
    }
}

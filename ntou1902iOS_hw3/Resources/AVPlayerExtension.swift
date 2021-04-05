//
//  AVPlayerExtension.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/3.
//

import UIKit
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AVPlayer.setupBgMusic()
        AVPlayer.bgQueuePlayer.play()
        return true
    }
}

extension AVPlayer{
    //Background
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!
    static func setupBgMusic(){
        guard let url = Bundle.main.url(forResource: "French music no copyright", withExtension: "mp3")
        else{
            fatalError("Failed to find sound file.")
        }
        let item = AVPlayerItem(url: url)
        bgQueuePlayer.volume = 0.05
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    
    //Sound SFX
    static let sharedCorrectPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "correct", withExtension:"mp3")
        else{
            fatalError("Failed to find sound file.")
        }
        return AVPlayer(url: url)
    }()

    static let sharedWrongPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "wrong", withExtension: "mp3")
        else{
            fatalError("Failed to find sound file.")
        }
        return AVPlayer(url: url)
    }()
    
    static let sharedWinPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "MLG_Horns", withExtension: "mp3")
        else{
            fatalError("Failed to find sound file.")
        }
        return AVPlayer(url: url)
    }()
    
    static let sharedLosePlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "Sad Trombone", withExtension: "mp3")
        else{
            fatalError("Failed to find sound file.")
        }
        return AVPlayer(url: url)
    }()

    func playFromStart(){
        seek(to: .zero)
        play()
    }
}

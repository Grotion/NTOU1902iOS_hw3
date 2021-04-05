//
//  GameTimer.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/3/31.
//

import Foundation

class GameTimer: ObservableObject
{
    private var frequency:Double = 0.01
    private var timer: Timer?
    private var startDate: Date?
    @Published var timeElapsed:Double = 0.00
    
    func timerStart(){
        timeElapsed = 0.00
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true){
            timer in
            /*if let startDate = self.startDate{
                self.timeElapsed = Double(timer.fireDate.timeIntervalSince1970 - startDate.timeIntervalSince1970)
            }*/
            self.timeElapsed += self.frequency
        }
    }
    
    func timerStop(){
        timer?.invalidate()
        timer = nil
    }
    
    func timerPause(){
        timer?.invalidate()
        timer = nil
    }
    
    func timerContinue(){
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true){
            timer in
            self.timeElapsed += self.frequency
        }
    }
    
    func timerRestart(){
        timerStop()
        timerStart()
    }
}

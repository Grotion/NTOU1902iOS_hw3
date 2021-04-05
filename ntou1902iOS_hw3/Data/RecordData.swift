//
//  RecordData.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/1.
//

import Foundation
import SwiftUI

struct Record: Identifiable, Codable
{
    var id = UUID()
    var name: String
    var totalCount: Int
    var correctCount: Int
    var completion:Double
    var useTime: Double
    var date:Date
}


class RecordsData: ObservableObject
{
    @AppStorage("records") var recordsData: Data?
    let demoData =
    [
        Record(id: UUID(), name: "demoPlayer_A", totalCount:100, correctCount: 100, completion:10.0/10.0, useTime: 10.1, date: Date()),
        Record(id: UUID(), name: "demoPlayer_B", totalCount:10, correctCount: 9, completion:9.0/10.0, useTime: 12.1, date: Date()),
        Record(id: UUID(), name: "demoPlayer_C", totalCount:10, correctCount: 9, completion:9.0/10.0, useTime: 11.1, date: Date()),
        Record(id: UUID(), name: "demoPlayer_D", totalCount:10, correctCount: 10, completion:10.0/10.0, useTime: 130.1, date: Date()),
        Record(id: UUID(), name: "demoPlayer_E", totalCount:10, correctCount: 4, completion:4.0/10.0, useTime: 1350.1, date: Date()),
        Record(id: UUID(), name: "demoPlayer_F", totalCount:10, correctCount: 2, completion:2.0/10.0, useTime: 150.1, date: Date()),
        Record(id: UUID(), name: "demoPlayer_G", totalCount:10, correctCount: 4, completion:4.0/10.0, useTime: 50.77, date: Date()),
        Record(id: UUID(), name: "demoPlayer_H", totalCount:10, correctCount: 1, completion:1.0/10.0, useTime: 888.17, date: Date()),
        Record(id: UUID(), name: "demoPlayer_I", totalCount:10, correctCount: 0, completion:0.0/10.0, useTime: 888.17, date: Date()),
        Record(id: UUID(), name: "demoPlayer_J", totalCount:10, correctCount: 10, completion:10.0/10.0, useTime: 10.1, date: Date()),
    ]
    let demoData1 =
    [
        Record(id: UUID(), name: "Alex", totalCount:100, correctCount: 100, completion:10.0/10.0, useTime: 10.1, date: Date()),
        Record(id: UUID(), name: "Jeniffer", totalCount:10, correctCount: 9, completion:9.0/10.0, useTime: 12.1, date: Date()),
        Record(id: UUID(), name: "Jasmine", totalCount:10, correctCount: 9, completion:9.0/10.0, useTime: 11.1, date: Date()),
        Record(id: UUID(), name: "Mandy", totalCount:10, correctCount: 10, completion:10.0/10.0, useTime: 130.1, date: Date()),
        Record(id: UUID(), name: "Adam", totalCount:10, correctCount: 4, completion:4.0/10.0, useTime: 1350.1, date: Date()),
        Record(id: UUID(), name: "Calvien", totalCount:10, correctCount: 2, completion:2.0/10.0, useTime: 150.1, date: Date()),
        Record(id: UUID(), name: "Jacob", totalCount:10, correctCount: 4, completion:4.0/10.0, useTime: 50.77, date: Date()),
        Record(id: UUID(), name: "May", totalCount:10, correctCount: 1, completion:1.0/10.0, useTime: 888.17, date: Date()),
        Record(id: UUID(), name: "Oscar", totalCount:10, correctCount: 0, completion:0.0/10.0, useTime: 888.17, date: Date()),
        Record(id: UUID(), name: "Gorden", totalCount:10, correctCount: 10, completion:10.0/10.0, useTime: 10.1, date: Date()),
    ]
    init(){
        if let recordsData = recordsData{
            let decoder = JSONDecoder()
            do{
                records = try decoder.decode([Record].self, from: recordsData)
                sortData()
            }
            catch{
                print(error)
            }
        }
    }
    
    @Published var records = [Record]() {
        didSet{
            let encoder = JSONEncoder()
            do{
                recordsData = try encoder.encode(records)
            }
            catch{
                print(error)
            }
        }
    }
    func sortData()
    {
        self.records.sort{
            if($0.completion != $1.completion){
                //print("\($0.name) completon = \($0.completion), \($1.name) completon = \($1.completion)")
                return $0.completion > $1.completion
            }
            else if($0.useTime != $1.useTime){
                //print("\($0.name) completon = \($1.name) completon")
                return $0.useTime < $1.useTime
            }
            else{
                //print("\($0.name) useTime = \($1.name) useTime")
                return $0.date <= $1.date
            }
        }
    }
    func generateRandomDate(daysBack: Int)-> Date?{
            let day = arc4random_uniform(UInt32(daysBack))+1
            let hour = arc4random_uniform(23)
            let minute = arc4random_uniform(59)
            
            let today = Date(timeIntervalSinceNow: 0)
            let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            var offsetComponents = DateComponents()
            offsetComponents.day = -1 * Int(day - 1)
            offsetComponents.hour = -1 * Int(hour)
            offsetComponents.minute = -1 * Int(minute)
            
            let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
            return randomDate
    }
    func insertDemoData(){
        //self.records.removeAll()
        let orinalAmount = self.records.count
        for i in 0..<self.demoData.count{
            self.records.append(demoData[i])
            self.records[orinalAmount+i].date = self.generateRandomDate(daysBack: 1000) ?? Date()
        }
        sortData()
    }
    func removeDemoData(){
        for i in 0..<self.demoData.count{
            self.records.removeAll{
                ($0.name==demoData[i].name)&&($0.correctCount==demoData[i].correctCount)&&($0.useTime==demoData[i].useTime)
            }
        }
        sortData()
    }
    func removeAllData(){
        self.records.removeAll()
    }
}

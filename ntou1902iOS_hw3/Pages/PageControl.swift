//
//  PageControl.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/1.
//

import SwiftUI

enum Pages{
    case HomePage, PlayPage, LeaderboardPage, GameOverPage, EnterNamePage
}

struct PageControl: View {
    @State var currentPage = Pages.HomePage
    @ObservedObject var recordsData = RecordsData()
    @State private var record2set:Record = Record(id: UUID(), name: "demoPlayer_A", totalCount:100, correctCount: 100, completion:10.0/10.0, useTime: 10.1, date: Date())
    @State private var winGame:Bool = false
    var body: some View {
        ZStack
        {
            switch currentPage
            {
                case Pages.HomePage: HomePage(currentPage: $currentPage)
                case Pages.PlayPage: PlayPage(currentPage: $currentPage, recordsData: self.recordsData, record2set: $record2set, winGame: $winGame)
                case Pages.LeaderboardPage: LeaderboardPage(currentPage: $currentPage, recordsData: self.recordsData)
                case Pages.GameOverPage: GameOverPage(currentPage: $currentPage)
                case Pages.EnterNamePage: EnterNamePage(currentPage: $currentPage, recordsData: self.recordsData, record2set: $record2set, winGame: $winGame)
            }
        }
        .onAppear(){
            print("Width: \(UIScreen.main.bounds.size.width)")
            print("Height: \(UIScreen.main.bounds.size.height)")
            print("Unit: \(UIScreen.main.bounds.size.width/926.0)")
        }
    }
}

struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl()
    }
}

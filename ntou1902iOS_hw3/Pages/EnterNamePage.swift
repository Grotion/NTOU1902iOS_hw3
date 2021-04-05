//
//  EnterNamePage.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/4.
//

import SwiftUI
import KeyboardObserving

struct EnterNamePage: View {
    @Binding var currentPage:Pages
    @ObservedObject var recordsData:RecordsData
    @Binding var record2set:Record
    @Binding var winGame:Bool
    @ObservedObject var playerName = TextLimiter(limit: 10)
    @State private var emptyName:Bool = false
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        ZStack{
            EnterNamePageBackgroundView()
            VStack{
                if(winGame){
                    Text("🪅Congratulations🪅")
                    .font(Font.custom("GillSans-Bold", size: unit*60))
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(unit*10)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    StrokeText(text:"You got all question correct ! Well done !!", width: 1, color: .white)
                    .font(Font.custom("GillSans-Bold", size: unit*26))
                    .foregroundColor(Color(red: 51/255, green: 0/255, blue: 102/255))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    StrokeText(text:"Leave your name on the leaderboard 🏆", width: 1, color: .black)
                    .font(Font.custom("GillSans-Bold", size: unit*24))
                    .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                }
                else{
                    VStack{
                        Text("Game Over👻")
                        .font(Font.custom("GillSans-Bold", size: unit*50))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 153/255, green: 0/255, blue: 0/255))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        StrokeText(text:"You can do better next time !!", width: 1, color: .white)
                        .font(Font.custom("GillSans-Bold", size: unit*30))
                        .foregroundColor(Color(red: 51/255, green: 0/255, blue: 102/255))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    }
                }
                VStack(alignment: .leading){
                    HStack{
                        TextField("Your Name", text:$playerName.text)
                        .font(Font.custom("AvenirNext-Bold", size: unit*20))
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: unit*1))
                        .multilineTextAlignment(.center)
                        .frame(width:unit*220)
                        Button(action: {
                            if(playerName.text==""){
                                emptyName = true
                            }
                            else{
                                record2set.name = playerName.text
                                recordsData.records.append(record2set)
                                recordsData.sortData()
                                currentPage = Pages.LeaderboardPage
                            }
                            }, label:{
                            Image(systemName: "checkmark")
                            .font(.system(size: unit*14, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(width: unit*30, height:unit*30)
                            .background(Circle().fill(Color.green))
                        })
                        .alert(isPresented: $emptyName){ () -> Alert in
                            Alert(title: Text("Invalid Name!"), message: Text("Your Name Cannot Be Empty!!"), dismissButton: .default(Text("Try Again")))
                        }
                    }
                    StrokeText(text:"Max of 10 characters", width: 1, color: .white)
                    //Text("Max of 10 characters")
                    .font(Font.custom("GillSans-Bold", size: unit*18))
                    .foregroundColor(Color(red: 220/255, green: 20/255, blue: 60/255))
                    .multilineTextAlignment(.center)
                    .frame(width:unit*220)
                    .opacity(playerName.hasReachedLimit ? 1 : 0)
                }
            }
        }
        .keyboardObserving()
    }
}

struct EnterNamePage_Previews: PreviewProvider {
    static var previews: some View {
        EnterNamePage(currentPage: .constant(Pages.EnterNamePage), recordsData: RecordsData(), record2set: .constant(Record(id: UUID(), name: "demoPlayer_H", totalCount:10, correctCount: 0, completion:0.0/10.0, useTime: 888.17, date: Date())), winGame: .constant(false))
    }
}

struct EnterNamePageBackgroundView: View {
    var body: some View {
        Image("hw3_background6")
        .resizable()
        .opacity(0.5)
        .frame(width: UIScreen.main.bounds.size.width)
        .scaledToFit()
        .edgesIgnoringSafeArea(.all)

    }
}

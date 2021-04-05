//
//  GameOverPage.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/2.
//

import SwiftUI
import AVFoundation

struct GameOverPage: View {
    @Binding var currentPage:Pages
    var losePlayer: AVPlayer{AVPlayer.sharedLosePlayer}
    func go2EnterName()
    {
        losePlayer.playFromStart()
        DispatchQueue.main.asyncAfter(deadline: .now()+4){
            currentPage = Pages.EnterNamePage
        }
    }
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        ZStack{
            GameOverPageBackgroundView()
            VStack{
                Text("⏰ Times Up ⏰")
                .font(Font.custom("GillSans-Bold", size: unit*70))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 255/255, green: 0/255, blue: 0/255))
                .multilineTextAlignment(.center)
                Text("Game Over")
                .font(Font.custom("GillSans-Bold", size: unit*50))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 140/255, green: 0/255, blue: 211/255))
                .multilineTextAlignment(.center)
            }
        }
        .onAppear(){
            go2EnterName()
        }
    }
}

struct GameOverPage_Previews: PreviewProvider {
    static var previews: some View {
        GameOverPage(currentPage: .constant(Pages.GameOverPage))
    }
}

struct GameOverPageBackgroundView: View {
    var body: some View {
        Image("hw3_background4")
        .resizable()
        .opacity(0.5)
        .frame(width: UIScreen.main.bounds.size.width)
        .scaledToFit()
        .edgesIgnoringSafeArea(.all)

    }
}

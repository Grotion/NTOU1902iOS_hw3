//
//  ContentView.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/3/31.
//

import SwiftUI

struct HomePage: View
{
    @Binding var currentPage:Pages
    var body: some View
    {
        let screenWidth:CGFloat = UIScreen.main.bounds.size.width
        let unit:CGFloat = screenWidth/926.0
        ZStack(alignment: .center)
        {
            HomePageBackgroundView()
            GrotionCopyright()
            VStack
            {
                Text("Enchanté")
                .font(Font.custom("HelveticaNeue-CondensedBlack", size: unit*80))
                .foregroundColor(Color(red: 255/255, green: 255/255, blue: 255/255))
                .multilineTextAlignment(.center)
                .frame(width:screenWidth * 4 / 5)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: unit*10, trailing:0))
                Button(action: {currentPage = Pages.PlayPage}, label: {
                    Text("Play")
                    .foregroundColor(Color(red: 0/255, green: 250/255, blue: 154/255))
                    .font(Font.custom("GillSans-Bold", size: unit*30))
                    .multilineTextAlignment(.center)
                    .frame(width:screenWidth * 1 / 3, height: unit*60)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0/255, green: 250/255, blue: 154/255), style: StrokeStyle(lineWidth: unit*2)))
                })
                .padding(EdgeInsets(top: 0, leading: 0, bottom: unit*10, trailing:0))
                Button(action: {currentPage = Pages.LeaderboardPage}, label: {
                    Text("Leaderboard")
                    .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                    .font(Font.custom("GillSans-Bold", size: unit*30))
                    .multilineTextAlignment(.center)
                    .frame(width:screenWidth * 1 / 3, height: unit*60)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 255/255, green: 215/255, blue: 0/255), style: StrokeStyle(lineWidth: unit*2)))
                })
            }
        }
        .edgesIgnoringSafeArea(.leading)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(currentPage:.constant(Pages.HomePage))
    }
}

struct HomePageBackgroundView: View {
    var body: some View {
        Image("hw3_background1")
        .resizable()
        //.opacity(0.8)
        .frame(width: UIScreen.main.bounds.size.width)
        .scaledToFit()
        .edgesIgnoringSafeArea(.all)
        /*Color.black
        .frame(width: UIScreen.main.bounds.size.width)
        .edgesIgnoringSafeArea(.all)*/

    }
}

struct GrotionCopyright: View {
    var body: some View {
        VStack{
            Spacer()
            Text("© 2021 Grotion")
            .foregroundColor(.white)
        }
    }
}

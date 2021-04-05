//
//  LeaderBoardPage.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/3/31.
//

import SwiftUI

struct LeaderboardPage: View {
    @Binding var currentPage:Pages
    @ObservedObject var recordsData:RecordsData
    let dataEditable = true
    @State private var showEditOptions:Bool = false
    @State private var showRemoveAllAlert = false
    @State private var aniControl:Bool = false
    @State private var frameSize:CGRect = CGRect.zero
    let aniDuration:Double = 0.5
    var body: some View {
        let screenWidth:CGFloat = UIScreen.main.bounds.size.width
        let screenHeight:CGFloat = UIScreen.main.bounds.size.height
        let unit:CGFloat = screenWidth/926.0
        ZStack()
        {
            LeaderboardPageBackgroundView()
            VStack{
                HStack{
                    Button(action:{currentPage = Pages.HomePage}, label:{
                        Image(systemName: "house.fill")
                        .font(.system(size: unit*30, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(width: unit*50, height:unit*50)
                        .background(Circle().fill(Color(red: 30/255, green: 144/255, blue: 255/255)))
                    })
                    Spacer()
                }
                Spacer()
            }
            .padding(EdgeInsets(top: unit*20, leading: unit*30, bottom: 0, trailing: 0))
            if(dataEditable){
                if(!showEditOptions){
                    VStack{
                        HStack(spacing: unit*10){
                            Spacer()
                            Button(action:{
                                showEditOptions=true
                                aniControl = true
                            }, label:{
                                Image(systemName: "restart")
                                .font(.system(size: unit*30, weight: .bold))
                                .foregroundColor(Color.white)
                                .frame(width: unit*50, height:unit*50)
                                .background(Circle().fill(Color.gray))
                            })
                        }
                        Spacer()
                    }
                    .padding(EdgeInsets(top: unit*20, leading: 0, bottom: 0, trailing: unit*20))
                }
                VStack{
                    HStack{
                        Spacer()
                        HStack(spacing: unit*10)
                        {
                            Button(action:{
                                aniControl = false
                                DispatchQueue.main.asyncAfter(deadline: .now()+aniDuration){
                                    showEditOptions=false
                                }
                            }, label:{
                                Image(systemName: "play")
                                .font(.system(size: unit*30, weight: .bold))
                                .foregroundColor(Color.white)
                                .frame(width: unit*50, height:unit*50)
                                .background(Circle().fill(Color.gray))
                            })
                            Button(action:{recordsData.insertDemoData()}, label:{
                                Image(systemName: "plus")
                                .font(.system(size: unit*30, weight: .bold))
                                .foregroundColor(Color.white)
                                .frame(width: unit*50, height:unit*50)
                                .background(Circle().fill(Color.green))
                            })
                            Button(action:{recordsData.removeDemoData()}, label:{
                                Image(systemName: "minus")
                                .font(.system(size: unit*30, weight: .bold))
                                .foregroundColor(Color.white)
                                .frame(width: unit*50, height:unit*50)
                                .background(Circle().fill(Color(red: 184/255, green: 134/255, blue: 11/255)))
                            })
                            Button(action:{showRemoveAllAlert=true}, label:{
                                Image(systemName: "trash")
                                .font(.system(size: unit*30, weight: .bold))
                                .foregroundColor(Color.white)
                                .frame(width: unit*50, height:unit*50)
                                .background(Circle().fill(Color.red))
                            })
                            .alert(isPresented: $showRemoveAllAlert)
                            {
                                () -> Alert in
                                return Alert(title: Text("Remove All Records!"), message: Text("Are you sure remove all records?"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Confirm"), action:{
                                    recordsData.removeAllData()
                                }))
                            }
                        }
                        .overlay(
                            GeometryReader(content:{
                                geometry in
                                Color.clear
                                .onAppear(perform: {
                                    frameSize = geometry.frame(in: .global)
                                    //print(frameSize.width)
                                })
                            })
                        )
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: unit*20, leading: 0, bottom: 0, trailing: unit*20))
                .offset(x: aniControl ? 0 : frameSize.width+(unit*50))
                .animation(showEditOptions ? .easeIn(duration: aniDuration) : nil)
            }
            VStack(alignment: .center)
            {
                HStack{
                    Image("trophy")
                    .resizable()
                    .frame(width: unit*50, height:unit*50)
                    .scaledToFit()
                    .padding(.trailing, unit*10)
                    StrokeText(text: "Leaderboard", width: unit*1, color: Color.black)
                    .foregroundColor(.yellow)
                    .font(Font.custom("GillSans-Bold", size: unit*50))
                }
                .padding(.bottom, unit*20)
                Group{
                    let unitt = UIScreen.main.bounds.size.width/926.0
                    HStack(spacing: unitt*20)
                    {
                        Spacer()
                        Group{
                            Text("Rank")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(width: unitt*60, alignment: .center)
                            Text("Player Name")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(width: unitt*180, alignment: .center)
                            SocreTitleFormat2_3()
                            Text("Time Used")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(width: unitt*130, alignment: .center)
                            Text("Date")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(width: unitt*190, alignment: .center)
                        }
                        .font(Font.custom("GillSans-Bold", size: unitt*22))
                        .foregroundColor(Color(red: 72/255, green: 61/255, blue: 139/255))
                        Spacer()
                    }
                    ScrollView(.vertical, showsIndicators: false)
                    {
                        VStack(spacing: unitt*15)
                        {
                            ForEach(recordsData.records.indices, id: \.self)
                            {
                                (index) in
                                RecordRow(rank: index+1, record: recordsData.records[index])
                            }
                        }
                    }
                    .frame(height:screenHeight * 1 / 2)
                }
                .padding(.trailing, unit*20)
            }
            
        }
        .edgesIgnoringSafeArea(.leading)
        .onAppear(){
            recordsData.sortData()
        }
    }
}

struct LeaderboardPage_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardPage(currentPage:.constant(Pages.LeaderboardPage), recordsData: RecordsData())
    }
}

struct LeaderboardPageBackgroundView: View {
    var body: some View {
        Image("hw3_background2")
        .resizable()
        .opacity(0.3)
        .frame(width: UIScreen.main.bounds.size.width)
        .scaledToFit()
        .edgesIgnoringSafeArea(.all)

    }
}

struct SocreTitleFormat1: View {
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        Text("Score")
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .frame(width: unit*165, alignment: .center)
    }
}
struct SocreTitleFormat2_3: View {
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        Text("Score")
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .frame(width: unit*80, alignment: .center)
    }
}

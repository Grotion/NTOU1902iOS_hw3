//
//  PlayPage.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/3/31.
//

import SwiftUI
import AVFoundation

class positionData: ObservableObject {
    var lettersPos = [CGRect]()
    var posCreated = [Bool]()
}

struct PlayPage: View {
    @Binding var currentPage:Pages
    @ObservedObject var recordsData:RecordsData
    @Binding var record2set:Record
    @Binding var winGame:Bool
    let targetStage:Int = 10
    @State private var stage: Int = 0
    @State private var isBigStageShow:Bool = false
    @State private var isCompleteShow:Bool = false
    @State private var vocab = [Vocabulary(fr:"", en: "",picName: "bear")]
    @State private var questions = [[""]]
    @State private var qCount:Int = 0
    @State private var letterSize:CGFloat = .zero
    @State private var answers = [[""]]
    @State private var offsets = [CGSize.zero]
    @State private var questionPos = positionData()
    @State private var answerPos = positionData()
    @State private var questionCorrect:[Bool] = [false]
    @State private var answerCorrect:[Bool] = [false]
    @State var timeRemaining:Double = 100.00
    let totalTime:Double = 5000.00
    //var timer1 = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @StateObject private var timer2 = GameTimer()
    @State private var frenchSpeaker = FrenchSpeaker()
    @State private var letterSpoke:Bool = false
    @State private var  cheatAvailable = true
    @State private var hintAvailable = false
    @State private var hintCount:Int = 0
    var correctPlayer: AVPlayer{AVPlayer.sharedCorrectPlayer}
    var wrongPlayer: AVPlayer{AVPlayer.sharedWrongPlayer}
    var winPlayer: AVPlayer{AVPlayer.sharedWinPlayer}
    func initialGame(){
        winGame = false
        stage = 9
        showBigStage()
        vocabulary.shuffle()
        vocab.removeAll()
        questions.removeAll()
        answers.removeAll()
        for i in 0..<vocabulary.count{
            vocab.append(vocabulary[i])
            answers.append(Array(vocab[i].fr).map(String.init))
            for j in 0..<answers[i].count{
                if(answers[i][j]==" "){
                    answers[i][j] = ""
                }
            }
            var tmp = answers[i]
            tmp.shuffle()
            while (answers[i].elementsEqual(tmp)){
                tmp.shuffle()
            }
            questions.append(tmp)
        }
        timeRemaining = totalTime
        timer2.timerStart()
        initialStage()
    }
    func initialStage(){
        //print("Question: \(questions[stage])")
        print("Stage\(stage+1): \(vocab[stage].fr)")
        offsets.removeAll()
        questionCorrect.removeAll()
        answerCorrect.removeAll()
        questionPos.lettersPos.removeAll()
        answerPos.lettersPos.removeAll()
        let n = questions[stage].count
        offsets = [CGSize](repeating: .zero, count: n)
        questionPos.lettersPos = [CGRect](repeating: .zero, count: n)
        answerPos.lettersPos = [CGRect](repeating: .zero, count: n)
        questionPos.posCreated = [Bool](repeating: false, count: n)
        questionCorrect = [Bool](repeating: false, count: n)
        answerCorrect = [Bool](repeating: false, count: n)
        qCount = 0
        for i in 0..<questions[stage].count{
            if !(questions[stage][i]==""){
                qCount+=1
            }
            else{
                questionCorrect[i] = true
            }
            if(answers[stage][i]==""){
                answerCorrect[i] = true
            }
        }
        let unit:CGFloat = UIScreen.main.bounds.size.width/926.0
        letterSize = unit*((580-(CGFloat(answers[stage].count)-1)*10)/CGFloat(answers[stage].count))
        letterSize = letterSize>=(unit*70) ? (unit*70) : letterSize
        hintCount = 0
    }
    func showBigStage(){
        isBigStageShow = true
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
            isBigStageShow = false
            hintAvailable = true
            cheatAvailable = true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                frenchSpeaker.setWords2Speak(words2speak: vocab[stage].fr)
                frenchSpeaker.speakWords()
            }
        }
    }
    func updateQuestionPos(geometry: GeometryProxy, index: Int) {
        let pos = geometry.frame(in: .global)
        if(!questionPos.posCreated[index]){
            questionPos.lettersPos[index] = pos
            questionPos.posCreated[index] = true
        }
        //print(questionPos.lettersPos)
    }
    func updateAnswerPos(geometry: GeometryProxy, index: Int) {
        let pos = geometry.frame(in: .global)
        answerPos.lettersPos[index] = pos
        //print(answerPos.lettersPos)
    }
    func speakLetter(letter2speak: String){
        if(!letterSpoke){
            frenchSpeaker.setWords2Speak(words2speak: letter2speak=="" ? " " : letter2speak)
            frenchSpeaker.speakWords()
            letterSpoke = true
        }
    }
    func checkFinish() -> Bool{
        var finish = false
        var correctCount = 0
        for i in answerCorrect.indices{
            if(answerCorrect[i]==true){
                correctCount += 1
            }
        }
        if(correctCount>=answerCorrect.count){
            finish = true
        }
        return finish
    }
    func finishStage(){
        if(checkFinish()){
            winGame = true
            hintAvailable = false
            cheatAvailable = false
            frenchSpeaker.setWords2Speak(words2speak: vocab[stage].fr)
            frenchSpeaker.speakWords()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                var speakerFinish = false
                while(!speakerFinish){
                    speakerFinish = !frenchSpeaker.synthesizer.isSpeaking
                    if(speakerFinish){
                        if(stage+1==targetStage){
                            timer2.timerStop()
                            saveRecord(stageComplete: stage+1)
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                                isCompleteShow = true
                                winPlayer.playFromStart()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+3.5){
                                currentPage = Pages.EnterNamePage
                            }
                        }
                        else{
                            stage += 1
                            showBigStage()
                            initialStage()
                        }
                    }
                }
            }
        }
    }
    func saveRecord(stageComplete: Int){
        record2set = Record(id:UUID(), name:"unknown", totalCount:targetStage, correctCount: stageComplete, completion: Double(stageComplete)/Double(targetStage), useTime: totalTime-timeRemaining, date: Date())
        //recordsData.records.append(Record(id:UUID(), name:"unknown", totalCount:targetStage, correctCount: stageComplete, completion: Double(stageComplete)/Double(targetStage), useTime: totalTime-timeRemaining, date: Date()))
        //recordsData.sortData()
    }
    var body: some View {
        GeometryReader{
            geometry in
            let screenWidth:CGFloat = UIScreen.main.bounds.size.width
            let unit:CGFloat = screenWidth/926.0
            ZStack(alignment: .center){
                PlayPageBackgroundView()
                if(isCompleteShow){
                    Congratulations(timeUsed: timer2.timeElapsed)
                }
                else{
                    if(isBigStageShow){
                        BigStageCount(stage: stage)
                    }
                    else{
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action:{
                                    questionCorrect = [Bool](repeating: true, count: questions[stage].count)
                                    answerCorrect = [Bool](repeating: true, count: questions[stage].count)
                                    finishStage()
                                    
                                }, label:{
                                    Image(systemName: "forward.fill")
                                    .font(.system(size: unit*25, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .frame(width: unit*50, height:unit*50)
                                    .background(Circle().fill(Color.green))
                                    .opacity(0)
                                    //.opacity(cheatAvailable ? 1 : 0)
                                })
                                .disabled(!cheatAvailable)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: unit*20, trailing: unit*30))
                        VStack{
                            HStack{
                                Spacer()
                                Button(action:{
                                    var qIndex = Int.random(in: 0..<questions[stage].count)
                                    while(questionCorrect[qIndex]==true){
                                        qIndex = Int.random(in: 0..<questions[stage].count)
                                    }
                                    for i in 0..<answers[stage].count{
                                        if((answers[stage][i]==questions[stage][qIndex])&&(!answerCorrect[i])){
                                            questionCorrect[qIndex] = true
                                            answerCorrect[i] = true
                                            hintCount+=1
                                            break
                                        }
                                    }
                                    if(hintCount>=3){
                                        hintAvailable = false
                                    }
                                    finishStage()
                                    
                                }, label:{
                                    Image(systemName: "lightbulb.fill")
                                    .font(.system(size: unit*25, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .frame(width: unit*50, height:unit*50)
                                    .background(Circle().fill(Color.yellow))
                                    .opacity(hintAvailable ? 1 : 0)
                                })
                                .disabled(!hintAvailable)
                            }
                            Spacer()
                        }
                        .padding(EdgeInsets(top: unit*20, leading: 0, bottom: 0, trailing: unit*30))
                        StageCount(stage: stage)
                        Image("\(vocab[stage].picName)")
                        .resizable()
                        //.scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: unit*600, maxHeight: unit*300)
                        .onTapGesture{
                            frenchSpeaker.setWords2Speak(words2speak: vocab[stage].fr)
                            frenchSpeaker.speakWords()
                        }
                        .zIndex(0)
                        .padding(.leading, unit*75)
                        VStack{
                            HStack{
                                ForEach(questions[stage].indices, id: \.self){
                                    (index) in
                                    if !(questions[stage][index]==""){
                                        if(questionCorrect[index]){
                                            Text("")
                                            .frame(width: letterSize, height:letterSize)
                                            //.frame(width: 0, height:0)
                                            .overlay(Circle().stroke(Color.clear, style: StrokeStyle(lineWidth: unit*3)))
                                            .padding(.trailing, unit*10)
                                            .opacity(0)
                                        }
                                        else{
                                            Text(questions[stage][index])
                                            .font(Font.custom("GillSans-Bold", size: unit*40*(letterSize/70)))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(red: 102/255, green: 0/255, blue: 102/255))
                                            .padding(unit*10)
                                            .shadow(radius: 20)
                                            .frame(width: letterSize, height:letterSize)
                                            .background( Circle().fill(Color.white).opacity(0.3))
                                            .overlay(
                                                GeometryReader(content: { geometry in
                                                    Circle().stroke(Color(red: 102/255, green: 0/255, blue: 102/255), style: StrokeStyle(lineWidth: unit*3))
                                                    let _ = updateQuestionPos(geometry: geometry, index: index)
                                                })
                                            )
                                            .padding(.trailing, unit*10)
                                            .offset(offsets[index])
                                            .gesture(
                                                DragGesture()
                                                .onChanged({
                                                    value in
                                                    speakLetter(letter2speak: questions[stage][index])
                                                    offsets[index].width = value.translation.width
                                                    offsets[index].height = value.translation.height
                                                    //print("Offsets: \(offsets[index])")
                                                })
                                                .onEnded({
                                                    value in
                                                    letterSpoke = false
                                                    let currentPos_x = questionPos.lettersPos[index].origin.x+offsets[index].width
                                                    let currentPos_y = questionPos.lettersPos[index].origin.y+offsets[index].height
                                                    //print("\nQuestion position: \(questionPos.lettersPos)")
                                                    //print("Offsets: \(offsets[index])")
                                                    //print("Answer position: \(answerPos.lettersPos)")
                                                    //print("Letter \(questions[stage][index]) current x_position:\(currentPos_x)")
                                                    //print("Letter \(questions[stage][index]) current y_position:\(currentPos_y)")
                                                    var found = false
                                                    var foundIndex = 0
                                                    for i in answers[stage].indices{
                                                        let targetPos_x = answerPos.lettersPos[i].origin.x
                                                        let targetPos_y = answerPos.lettersPos[i].origin.y
                                                        //print("Answer \(answers[stage].fr_spell[i]) osition:\(targetPos_x)")
                                                        //print("Answer \(answers[stage].fr_spell[i]) position:\(targetPos_y)")
                                                        //print("Distance(x-axis):\(abs(currentPos_x-targetPos_x))")
                                                        //print("Distance(y-axis):\(abs(currentPos_y-targetPos_y))\n")
                                                        if((abs(currentPos_x-targetPos_x)<25)&&(abs(currentPos_y-targetPos_y)<20)){
                                                            //print("Match Position....")
                                                            //print("Answer: \(answer.fr_spell[i])")
                                                            //print("Current: \(question[index])")
                                                            if(answers[stage][i]==questions[stage][index]){
                                                                found = true
                                                                foundIndex = i
                                                                break
                                                            }
                                                            
                                                        }
                                                    }
                                                    if(found){
                                                        answerCorrect[foundIndex] = true
                                                        questionCorrect[index] = true
                                                        //print("Correct Position!")
                                                        correctPlayer.playFromStart()
                                                        finishStage()
                                                    }
                                                    else{
                                                        wrongPlayer.playFromStart()
                                                        offsets[index] = CGSize.zero
                                                        //let _ = updateQuestionPos(geometry: geometry, index: index)
                                                    }
                                                    
                                                })
                                            )
                                        }
                                    }
                                }
                            }
                            .zIndex(3)
                            .padding(.top, unit*30)
                            .frame(maxWidth: unit*500)
                            Spacer()
                            HStack{
                                ForEach(answers[stage].indices, id: \.self){
                                    (index) in
                                    Group{
                                        if !(answers[stage][index]==""){
                                            if(answerCorrect[index]){
                                                Text(answers[stage][index])
                                                .font(Font.custom("GillSans-Bold", size: unit*40*(letterSize/70)))
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(red: 102/255, green: 0/255, blue: 102/255))
                                                .padding(unit*10)
                                                .frame(width: letterSize, height:letterSize)
                                                .background(Circle().fill(Color(red: 204/255, green: 204/255, blue: 255/255)))
                                                .overlay(Circle().stroke(Color(red: 102/255, green: 0/255, blue: 102/255), style: StrokeStyle(lineWidth: unit*3)))
                                            }
                                            else{
                                                Color(red: 204/255, green: 204/255, blue: 255/255)
                                                .clipShape(Circle())
                                                .frame(width: letterSize, height:letterSize)
                                                .shadow(radius: 20)
                                                .overlay(
                                                    GeometryReader(content: { geometry in
                                                        let _ = updateAnswerPos(geometry: geometry, index: index)
                                                        //Circle().stroke(Color(red: 100/255, green: 149/255, blue: 230/255), style: StrokeStyle(lineWidth: unit*3))
                                                        Color.clear
                                                    })
                                                )
                                            }
                                        }
                                        else{
                                            Spacer()
                                            .frame(width: letterSize, height:letterSize)
                                        }
                                    }
                                    .padding(.trailing, unit*10)
                                }
                            }
                            .zIndex(2)
                            .padding(.bottom, unit*30)
                        }
                        .padding(.leading, unit*75)
                    }
                    HStack{
                        let unitt = UIScreen.main.bounds.size.width/926.0
                        VStack(alignment: .center){
                            Spacer()
                            ZStack(alignment: .bottom){
                                RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                                .frame(width: unitt*50, height: timeRemaining>=0 ? unitt*(250*CGFloat((timeRemaining/totalTime))) : 0)
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.green, lineWidth: unitt*5)
                                .frame(width: unitt*50, height: unitt*250)
                            }
                            HStack(alignment: .bottom, spacing: unitt*0){
                                Group{
                                    Text("\(Int(timeRemaining)).")
                                    .font(Font.custom("GillSans-Bold", size: unitt*30))
                                    .fontWeight(.bold)
                                    Text("\(Int((timeRemaining-floor(timeRemaining))*100), specifier: "%02d")")
                                    .font(Font.custom("GillSans-Bold", size: unitt*25))
                                }
                                .foregroundColor(timeRemaining>20 ? Color.black : Color.red)
                                
                            }
                            .onChange(of: timer2.timeElapsed, perform: {
                                value in
                                if (timeRemaining>0){
                                    timeRemaining = totalTime - value
                                }
                                else{
                                    timeRemaining = 0
                                    timer2.timerStop()
                                    saveRecord(stageComplete: stage)
                                    currentPage = Pages.GameOverPage
                                }
                            })
                        }
                        .frame(width: unitt*200)
                        .padding(.bottom, unitt*20)
                        Spacer()
                    }
                    .padding(.leading, unit*((screenWidth-500)/2-200)/2)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {initialGame()})
    }
    
}

struct PlayPage_Previews: PreviewProvider {
    static var previews: some View {
        PlayPage(currentPage:.constant(Pages.PlayPage), recordsData: RecordsData(), record2set: .constant(Record(id: UUID(), name: "demoPlayer_H", totalCount:10, correctCount: 0, completion:0.0/10.0, useTime: 888.17, date: Date())), winGame: .constant(false))
    }
}

struct PlayPageBackgroundView: View {
    var body: some View {
        Image("hw3_background5")
        .resizable()
        .opacity(0.4)
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .scaledToFill()
        .edgesIgnoringSafeArea(.all)

    }
}
struct Congratulations: View {
    var timeUsed: Double
    var body: some View {
        VStack{
            let unit = UIScreen.main.bounds.size.width/926.0
            Text("Congratulations🥳🥳🥳")
            .font(Font.custom("GillSans-Bold", size: unit*60))
            .fontWeight(.bold)
            .foregroundColor(Color.red)
            .padding(unit*10)
            .multilineTextAlignment(.center)
            Text("Time used: \(timeUsed, specifier: "%.2f")")
            .font(Font.custom("GillSans-Bold", size: unit*20))
            .fontWeight(.bold)
            .foregroundColor(Color.black)
            .multilineTextAlignment(.center)
        }
        
    }
}
struct StageCount: View {
    var stage:Int
    var body: some View {
        let unit = UIScreen.main.bounds.size.width/926.0
        VStack{
            HStack{
                Text("Stage \(stage+1)")
                .font(Font.custom("GillSans-Bold", size: unit*30))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0/255, green: 139/255, blue: 139/255))
                .multilineTextAlignment(.center)
                Spacer()
            }
            Spacer()
        }
        .padding(EdgeInsets(top: unit*20, leading: unit*30, bottom: 0, trailing: 0))
    }
}
struct BigStageCount: View {
    var stage:Int
    var body: some View {
        let unit = UIScreen.main.bounds.size.width/926.0
        Text("Stage \(stage+1)")
        .font(Font.custom("GillSans-Bold", size: unit*100))
        .fontWeight(.bold)
        .foregroundColor(Color(red: 0/255, green: 139/255, blue: 139/255))
        .multilineTextAlignment(.center)
    }
}

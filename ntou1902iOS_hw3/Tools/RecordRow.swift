//
//  RecordRow.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/4/1.
//

import SwiftUI

struct RecordRow: View {
    var rank: Int
    var record: Record
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm , dd MMM yyyy"
        return formatter
    }()
    var rankShow:String = ""
    init(rank: Int, record: Record)
    {
        self.rank = rank
        self.record = record
        switch rank{
            case 1:
                rankShow = "🥇"
                break
            case 2:
                rankShow = "🥈"
                break
            case 3:
                rankShow = "🥉"
                break
            default:
                rankShow = String(rank)
                break
        }
    }
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        HStack(spacing: unit*20)
        {
            Spacer()
            Group{
                Text("\(rankShow)")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(width: unit*60, alignment: .center)
                Text("\(record.name)")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(width: unit*180, alignment: .center)
                SocreRowFormat3(record: record)
                Text("\(record.useTime, specifier: "%.2f")(s)")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(width: unit*130, alignment: .center)
                Text("\(record.date, formatter: formatter)")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(width: unit*190, alignment: .center)
            }
            .font(Font.custom("AvenirNext-Bold", size: unit*18))
            .foregroundColor(Color.black)
            Spacer()
        }
    }
}

struct RecordRow_Previews: PreviewProvider {
    static var previews: some View {
        RecordRow(rank: 3, record: Record(id: UUID(), name: "Alex", totalCount: 10, correctCount: 10, completion: 10.0/10.0, useTime: 10.0, date: Date()))
    }
}

struct SocreRowFormat1: View {
    var record:Record
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        Text("\(record.completion*100, specifier: "%.2f")%(\(record.correctCount)/\(record.totalCount))")
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .frame(width: unit*165, alignment: .center)
    }
}
struct SocreRowFormat2: View {
    var record:Record
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        Text("\(record.completion*100, specifier: "%.2f")%")
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .frame(width: unit*80, alignment: .center)
    }
}

struct SocreRowFormat3: View {
    var record:Record
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let unit = screenWidth/926.0
        Text("\(record.correctCount)/\(record.totalCount)")
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .frame(width: unit*80, alignment: .center)
    }
}



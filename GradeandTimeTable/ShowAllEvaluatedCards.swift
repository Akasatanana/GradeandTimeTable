//
//  ShowAllEvaluatedCards.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/10.
//

import SwiftUI

struct ShowAllEvaluatedCards: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var setting: UserSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var evaluatedClasses: [ClassData] {
        return classes.filter({
            $0.attendlikeEvalItems != nil ||
            $0.testlikeEvalItems != nil
        })
    }
    
    var aveGPA: Double {
        var res: Double = 0
        var creditsum: Double = 0
        for classdata in evaluatedClasses{
            if let value = JudgeGradePoint(classdata: classdata){
                res += (value * Double(classdata.unwrappedCredit))
                creditsum += Double(classdata.unwrappedCredit)
            }
        }
        return res / creditsum
    }
    
    var gpacolor: Color {
        switch aveGPA{
        case 0 ..< 1.1:
            return .purple
        case 1.5 ..< 2.0:
            return .green
        case 2.0 ..< 2.5:
            return .blue
        case 2.5 ..< 3.0:
            return .blue
        case 3.0 ..< 3.5:
            return .red
        case 4.0:
            return .yellow
        default:
            return .black
            
        }
    }
    
    var body: some View {
        NavigationView{
            if evaluatedClasses.isEmpty{
                VStack{
                    Image(systemName: "xmark.bin.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth / 4)
                    Text("授業が登録されていません．")
                        .font(.body)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                }
                .foregroundColor(.gray)
                .toolbar{
                    ToolbarItem(placement: .principal){
                        Text("成績評価")
                            .font(.title2)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }else{
                ScrollView{
                    VStack(spacing: 20){
                        HStack{
                            Text("平均GPA")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(width: screenWidth * 0.9)
                        Text(String(format: "%.1f", aveGPA))
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(gpacolor)
                            .padding()
                        
                        ForEach(evaluatedClasses, id: \.self){classdata in
                            NavigationLink(destination: {
                                MissedTimeSetting(selectedclass: classdata)
                            }){
                                EvaluatedCard(classData: classdata)
                            }
                        }
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .principal){
                        Text("成績評価")
                            .font(.title2)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
        }
    }
}

struct ShowAllEvaluatedCards_Previews: PreviewProvider {
    static var previews: some View {
        ShowAllEvaluatedCards()
    }
}

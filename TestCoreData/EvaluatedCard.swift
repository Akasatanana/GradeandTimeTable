//
//  EvaluatedCard.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/10.
//

import SwiftUI

struct EvaluatedCard: View {
    @EnvironmentObject var setting: UserSettings
    @ObservedObject var classData: ClassData
    var body: some View {
        let missedgradient = Gradient(stops: [
            .init(color: Color(classData.unwrappedColor), location: 0.0),
            .init(color: Color(classData.unwrappedColor), location: CalcgotRatio(classdata: classData) / 100.0),
            .init(color: .gray, location: CalcgotRatio(classdata: classData) / 100.0),
            .init(color: .gray, location: 1.0)
        ])
        VStack(){
            VStack(alignment: .leading){
                Text(classData.unwrappedName)
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                HStack{
                    VStack(alignment: .leading){
                        Spacer()
                        Text("\(classData.unwrappedCredit)単位")
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Spacer()
                        if let data = classData.attendlikeEvalItems{
                            let evalitems = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [AttendlikeEvalItem]
                            
                            ForEach(evalitems, id: \.self){evalitem in
                                Text(evalitem.name + "：\(Int(evalitem.evalRatio))％")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                        
                        if let data = classData.testlikeEvalItems{
                            let evalitems = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TestlikeEvalItem]
                            
                            ForEach(evalitems, id: \.self){evalitem in
                                Text(evalitem.name + "：\(Int(evalitem.evalRatio))％")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                    }
                }
            }
            .frame(width: screenWidth * 0.85, height: screenHeight / 3.5)
            
        }
        .padding()
        .background(LinearGradient(gradient: missedgradient, startPoint: .bottom, endPoint: .top))
        .cornerRadius(8)
        .clipped()
        .shadow(color: .gray.opacity(0.7), radius: 10)
    }
}
/*
struct EvaluatedCard_Previews: PreviewProvider {
    static var previews: some View {
        EvaluatedCard()
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
 */

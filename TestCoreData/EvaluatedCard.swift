//
//  EvaluatedCard.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/10.
//

import SwiftUI

struct EvaluatedCard: View {
    @EnvironmentObject var setting: UserSettings
    @State var classData: ClassData
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(classData.unwrappedName)
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                    Text("\(classData.unwrappedCredit)単位")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                }
                Spacer()
                VStack(alignment: .trailing){
                    Spacer()
                    if let data = classData.evalItems{
                        let evalitems = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [EvalItem]
                        
                        ForEach(evalitems, id: \.self){evalitem in
                            Text(evalitem.name + "：\(Int(evalitem.evalRatio))％")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .frame(width: setting.screenWidth * 0.85, height: setting.screenHeight / 4)
            .padding()
            .background(Color(classData.unwrappedColor))
            .cornerRadius(8)
            .clipped()
            .shadow(color: .gray.opacity(0.7), radius: 10)
            Spacer()
        }
        .padding()
        //.background(Color(white: 0.9))
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

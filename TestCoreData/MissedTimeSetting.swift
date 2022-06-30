//
//  MissedTimeSetting.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/10.
//

import SwiftUI

struct MissedTimeSetting: View {
    @ObservedObject var selectedclass: ClassData
    @Environment(\.managedObjectContext) private var viewContext
    
    var evalitems: [EvalItem] {
        if let data = selectedclass.evalItems{
            let items = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [EvalItem]
            return items
        }else{return []}
    }//読み取り専用
    
    @State var newEvalItems: [EvalItem] = []
    
    var body: some View {
        ScrollView{
            VStack(){
                HStack{
                    Text("現状の成績評価")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                Text(JudgeGrade(classdata: selectedclass) ?? "")
                    .font(.largeTitle)
                    .padding()
                HStack{
                    Text("落とした割合")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                Text(String(format: "%.2f", CalcMissedRatio(classdata: selectedclass)) + "％")
                    .font(.largeTitle)
                    .padding()
                
                HStack{
                    Text("落とした回数")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                VStack{
                    if newEvalItems.count == evalitems.count{
                        ForEach(evalitems.indices, id: \.self){index in
                            VStack{
                                HStack{
                                    Text(evalitems[index].name)
                                    Spacer()
                                    VStack{
                                        Button(action: {
                                            if evalitems[index].evalTime > newEvalItems[index].missedTime{
                                                newEvalItems[index].missedTime += 1
                                            }

                                            let data = try? NSKeyedArchiver.archivedData(withRootObject: newEvalItems, requiringSecureCoding: false)
                                            selectedclass.evalItems = data
                                            try? viewContext.save()
                                        }, label: {
                                            Image(systemName: "play.fill")
                                                .rotationEffect(.degrees(-90))
                                        })
                                        .buttonStyle(.borderless)
                                        .foregroundColor(.red)
                                        .padding(.top)
                                        
                                        Text(String(format: "%02d", newEvalItems[index].missedTime) + "/" + String(format: "%02d", evalitems[index].evalTime))
                                            .font(.title)
                                        
                                        Button(action: {
                                            if newEvalItems[index].missedTime > 0{
                                                newEvalItems[index].missedTime -= 1
                                            }
                                            
                                            let data = try? NSKeyedArchiver.archivedData(withRootObject: newEvalItems, requiringSecureCoding: false)
                                            selectedclass.evalItems = data
                                            try? viewContext.save()
                                        }, label: {
                                            Image(systemName: "play.fill")
                                                .rotationEffect(.degrees(90))
                                        })
                                        .buttonStyle(.borderless)
                                        .padding(.bottom)
                                    }
                                    Text("回")
                                        .font(.title)
                                }
                                .frame(width: screenWidth * 0.8, height: screenHeight * 0.1)
                                if index != evalitems.count - 1{
                                    Divider()
                                }
                            }
                            
                            .fixedSize()
                            }
                    }
                }
                .frame(width: screenWidth * 0.85)
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
            }
            .frame(width: screenWidth * 0.95)
        }
        
        .onAppear{
            newEvalItems = evalitems
        }
    }
}
/*
struct MissedTimeSetting_Previews: PreviewProvider {
    static var previews: some View {
        MissedTimeSetting()
    }
}
 */

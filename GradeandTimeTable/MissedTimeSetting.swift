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
    
    var attendlikeEvalItems: [AttendlikeEvalItem] {
        if let data = selectedclass.attendlikeEvalItems{
            let items = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [AttendlikeEvalItem]
            return items
        }else{return []}
    }//読み取り専用
    
    var testlikeEvalItems: [TestlikeEvalItem] {
        if let data = selectedclass.testlikeEvalItems{
            let items = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TestlikeEvalItem]
            return items
        }else{return []}
    }//読み取り専用
    
    @State var newAttendlikeEvalItems: [AttendlikeEvalItem] = []
    @State var newTestlikeEvalItems: [TestlikeEvalItem] = []
    @State var currentTestlikeEvalItemIndex : Int = -1
    @State var forInputMissedRatio: Int = 0
    @State var unproperratio: Bool = false
    
    var tofocus: [Int] {
        var forindex: Int = 1
        var res: [Int] = []
        for index in testlikeEvalItems.indices{
            for mindex in testlikeEvalItems[index].gotRatios.indices{
                if mindex != (testlikeEvalItems[index].gotRatios.endIndex - 1){
                    res.append(forindex)
                }else{
                    res.append(-(forindex))
                }
                forindex += 1
            }
        }
        return res
    }
    
    @FocusState var focus: Int?
    
    var body: some View {
        ScrollView{
            VStack(){
                HStack{
                    Text("成績評価")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                Text(JudgeGrade(classdata: selectedclass) ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(JudgeGradecolor(selectedclass: selectedclass))
                    .padding()
                HStack{
                    Text("割合")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                VStack(alignment: .trailing){
                    ForEach(attendlikeEvalItems.indices, id: \.self){index in
                        HStack{
                            Text(attendlikeEvalItems[index].name)
                            Spacer()
                            Text(String(format: "%.2f", CalcRatio(item: attendlikeEvalItems[index])) + "％")
                                .font(.largeTitle)
                        }
                    }
                    
                    ForEach(testlikeEvalItems.indices, id: \.self){index in
                        HStack{
                            Text(testlikeEvalItems[index].name)
                            Spacer()
                            Text(String(format: "%.2f", CalcRatio(item: testlikeEvalItems[index])) + "％")
                                .font(.largeTitle)
                        }
                    }
                    
                    Divider()
                    
                    Text(String(format: "%.2f", CalcgotRatio(classdata: selectedclass)) + "％")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(JudgeGradecolor(selectedclass: selectedclass))
                }
                .frame(width: screenWidth * 0.8)
                .fixedSize()
                
                HStack{
                    Text("評価項目")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                VStack{
                    if newAttendlikeEvalItems.count == attendlikeEvalItems.count{
                        ForEach(attendlikeEvalItems.indices, id: \.self){index in
                            VStack{
                                HStack{
                                    Text(attendlikeEvalItems[index].name)
                                    Spacer()
                                    VStack{
                                        Button(action: {
                                            if attendlikeEvalItems[index].evalTime > newAttendlikeEvalItems[index].gotTime{
                                                newAttendlikeEvalItems[index].gotTime += 1
                                            }

                                            let data = try? NSKeyedArchiver.archivedData(withRootObject: newAttendlikeEvalItems, requiringSecureCoding: false)
                                            selectedclass.attendlikeEvalItems = data
                                            try? viewContext.save()
                                        }, label: {
                                            Image(systemName: "play.fill")
                                                .rotationEffect(.degrees(-90))
                                        })
                                        .buttonStyle(.borderless)
                                        .foregroundColor(.red)
                                        .padding(.top)
                                        
                                        Text(String(format: "%02d", newAttendlikeEvalItems[index].gotTime) + "/" + String(format: "%02d", attendlikeEvalItems[index].evalTime))
                                            .font(.title)
                                        
                                        Button(action: {
                                            if newAttendlikeEvalItems[index].gotTime > 0{
                                                newAttendlikeEvalItems[index].gotTime -= 1
                                            }
                                            
                                            let data = try? NSKeyedArchiver.archivedData(withRootObject: newAttendlikeEvalItems, requiringSecureCoding: false)
                                            selectedclass.attendlikeEvalItems = data
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
                                .frame(width: screenWidth * 0.8, height: screenHeight * 0.12)
                                if index != attendlikeEvalItems.count - 1 || testlikeEvalItems != []{
                                    Divider()
                                }
                            }
                            .fixedSize()
                            }
                    }
                    
                    if newTestlikeEvalItems.count == testlikeEvalItems.count{
                        ForEach(testlikeEvalItems.indices, id: \.self){index in
                            Button(action: {
                                if currentTestlikeEvalItemIndex == index{
                                    currentTestlikeEvalItemIndex = -1
                                }else{
                                    currentTestlikeEvalItemIndex = index
                                }
                            }, label: {
                                HStack{
                                    Text(testlikeEvalItems[index].name)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(currentTestlikeEvalItemIndex == index ? "↑" : "↓")
                                }
                                .frame(width: screenWidth * 0.8, height: screenHeight * 0.1)
                            })
                            if currentTestlikeEvalItemIndex == index {
                                VStack{
                                    ForEach(newTestlikeEvalItems[index].gotRatios.indices, id: \.self){mindex in
                                        HStack(){
                                            Spacer()
                                            VStack{
                                                HStack{
                                                    Text("\(mindex + 1)回目：")
                                                    Spacer()
                                                    TextField("100", value: $newTestlikeEvalItems[index].gotRatios[mindex], formatter: NumberFormatter())
                                                        .frame(width: screenWidth * 0.25)
                                                    .keyboardType(.numberPad)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .multilineTextAlignment(TextAlignment.center)
                                                    .focused($focus, equals: tofocus[index + mindex])
                                                    .shadow(color: focus == tofocus[index + mindex] ? .blue : .clear, radius: 1.0)
                                                    .onTapGesture{
                                                        focus = tofocus[index + mindex]
                                                    }
                                                    Text("％")
                                                }
                                                if mindex != newTestlikeEvalItems[index].gotRatios.endIndex - 1{
                                                    Divider()
                                            }
                                            }
                                            .frame(width: screenWidth * 0.7)
                                        }
                                        .frame(width: screenWidth * 0.8)
                                        
                                    }
                                }
                                .frame(width: screenWidth * 0.8)
                                .padding()
                                .fixedSize()
                                
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        for item in newTestlikeEvalItems {
                                            for ratio in item.gotRatios {
                                                if ratio < 0 || ratio > 100{
                                                    unproperratio = true
                                                }
                                            }
                                        }
                                        if !unproperratio {
                                            let data = try? NSKeyedArchiver.archivedData(withRootObject: newTestlikeEvalItems, requiringSecureCoding: false)
                                            selectedclass.testlikeEvalItems = data
                                            try? viewContext.save()
                                            currentTestlikeEvalItemIndex = -1
                                        }
                                    }, label: {
                                        Text("保存")
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding()
                                            .background{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundColor(.blue)
                                            }
                                    })
                                }
                                .frame(width: screenWidth * 0.8)
                            }
                            if index != testlikeEvalItems.endIndex - 1 {
                                Divider()
                            }
                        }
                }
                }
                .frame(width: screenWidth * 0.85)
                
            }
            .frame(width: screenWidth * 0.95)
            
            .alert("注意", isPresented: $unproperratio, actions: {
                Button("了解", role: .cancel){
                    unproperratio = false
                }
            }, message: {
                Text("0〜100％の間の値を入力してください．")
            })
        }
        .onTapGesture{
            focus = nil
        }
        
        .onAppear{
            newAttendlikeEvalItems = attendlikeEvalItems
            newTestlikeEvalItems = testlikeEvalItems
        }
        .toolbar{
            ToolbarItem(placement: .keyboard){
                HStack{
                    Spacer()
                    Button(action: {
                        if let _ = focus {
                            if focus! < 0{
                                focus = nil
                            }else{
                                var flg = false
                                for num in tofocus {
                                    if focus == num{
                                        flg = true
                                    }else if flg {
                                        focus = num
                                        flg = false
                                    }
                                }
                            }
                        }
                    }, label: {
                        Text("完了")
                    })
                }
            }
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

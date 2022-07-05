//
//  ClassSetting.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/08.
//

import SwiftUI

struct ClassSetting: View {
    let day: day
    let time: Int
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var setting: UserSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    @State var newName: String = ""
    @State var newRoom: String = ""
    @State var newTeacherName: String = ""
    @State var noPropertySet: Bool = false
    @State var newCredit: Int = 2
    @State var newColor: classColor = .gray
    @State var willDeleteEvalItems: Bool = false
    @State var willDeleteClass: Bool = false
    
    @State var buttonexploded: Bool = false
    @State var confirmSaveclass: Bool = false
    
    var selectedclass: ClassData? {
        return classes.filter({
            $0.unwrappedDay == day.rawValue &&
            $0.unwrappedTime == time
        }).first
    }
    var existsclass: Bool {selectedclass != nil}
    //ボタンのアクションの分岐，trueならnavigationlinkをactivate，falseならalertをactivate
    @State var goEvalSetting: Bool = false
    //navigationlinkにバインドする，
    @State var showNoClassAlart: Bool = false

    var attendlikeEvalItems: [AttendlikeEvalItem]? {
        if let data = selectedclass?.attendlikeEvalItems {
            let evalitem = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [AttendlikeEvalItem]
            return evalitem
        }else{
            return nil
        }
    }
    
    var testlikeEvalItems: [TestlikeEvalItem]? {
        if let data = selectedclass?.testlikeEvalItems {
            let evalitem = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TestlikeEvalItem]
            return evalitem
        }else{
            return nil
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    enum Field: Hashable{
        case name
        case room
        case teacher
    }
    
    @FocusState var focus: Field?
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 20){
                    VStack(alignment: .center, spacing: 20){
                        HStack{
                            Image(systemName: "book.closed.fill")
                                .foregroundColor(focus == .name ? .blue : .black)
                                
                            Text(":")
                                .foregroundColor(focus == .name ? .blue : .black)
                                
                            TextField(newName, text: $newName, prompt: Text("授業名"))
                                .multilineTextAlignment(.leading)
                                .focused($focus, equals: .name)
                                .onSubmit{
                                    focus = .room
                                }
                                .onTapGesture{
                                    focus = .name
                                }
                        }
                        .frame(width: screenWidth * 0.75,
                               height: screenHeight * 0.03)
                        Divider()
                        
                        HStack{
                            Image(systemName: "mappin")
                                .foregroundColor(focus == .room ? .blue : .black)
                                
                                
                            Text(":")
                                .foregroundColor(focus == .room ? .blue : .black)
                                
                            TextField(newRoom, text: $newRoom, prompt: Text("教室名"))
                                .multilineTextAlignment(.leading)
                                .focused($focus, equals: .room)
                                .onSubmit{
                                    focus = .teacher
                                }
                                .onTapGesture{
                                    focus = .room
                                }
                        }
                        .frame(width: screenWidth * 0.75,
                               height: screenHeight * 0.03)
                        Divider()
                        
                        HStack{
                            Image(systemName: "person.fill")
                                .foregroundColor(focus == .teacher ? .blue : .black)
                                
                            Text(":")
                                .foregroundColor(focus == .teacher ? .blue : .black)
                                
                            TextField(newTeacherName, text: $newTeacherName, prompt: Text("教員名"))
                                .multilineTextAlignment(.leading)
                                .focused($focus, equals: .teacher)
                                .onTapGesture{
                                    focus = .teacher
                                }
                        }
                        .frame(width: screenWidth * 0.75,
                               height: screenHeight * 0.03)
                        Divider()
                        Stepper("単位数：\(newCredit)", value: $newCredit)
                            .frame(width: screenWidth * 0.8,
                                   height: screenHeight * 0.02)
                        Divider()
                        
                        HStack{
                            Text("色：")
                            Spacer()
                            HStack(){
                                ForEach(classColor.all, id: \.self){color in
                                    Button(action: {
                                        newColor = color
                                        
                                    }, label: {
                                        color.toColor()
                                            .frame(width: 30, height: 30)
                                            .cornerRadius(75)
                                                            
                                            .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.black, lineWidth: newColor == color ? 4 : 0))
                                                    })
                                    .buttonStyle(.plain)
                                    
                                }
                            }
                        }
                        .frame(width: screenWidth * 0.2)
                    }
                    .fixedSize()
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 2)
                    }
                    
                    HStack{
                        Text("現在の評価項目：")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    if attendlikeEvalItems != nil || testlikeEvalItems != nil{
                        VStack{
                            if let evalitems = attendlikeEvalItems {
                                ForEach(evalitems, id: \.self){evalitem in
                                    HStack{
                                        Text(evalitem.name)
                                        Spacer()
                                        Text("\(Int(evalitem.evalRatio))％")
                                    }
                                    .frame(width: screenWidth * 0.8 , height: screenHeight * 0.05)
                                    if evalitem != evalitems.last || testlikeEvalItems != []{
                                        Divider()
                                    }
                                }
                            }
                            
                            if let evalitems = testlikeEvalItems {
                                ForEach(evalitems, id: \.self){evalitem in
                                    HStack{
                                        Text(evalitem.name)
                                        Spacer()
                                        Text("\(Int(evalitem.evalRatio))％")
                                    }
                                    .frame(width: screenWidth * 0.8 , height: screenHeight * 0.05)
                                    if evalitem != evalitems.last{
                                        Divider()
                                    }
                                }
                            }
                        }
                        .fixedSize()
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                                .background(.white)
                        }
                    }else{
                        VStack(spacing: 20){
                            Image(systemName: "xmark.bin.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth / 8)
                            Text("評価項目無し")
                        }
                        .foregroundColor(.gray)
                        
                    }
                    NavigationLink(destination: EvalItemSetting(selectedclass: selectedclass),
                                   isActive: $goEvalSetting,
                                   label: {EmptyView()})
                }
                .frame(width: screenWidth * 0.9)
                .disabled(buttonexploded)
            }
            
            if buttonexploded{
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
            }
            
            ParentalButton(position: (x: screenWidth * 0.75, y: screenHeight * 0.8),
                           offset: 80.0,
                           childrenButtonsInfo: [
                            (color: .blue, image: Image(systemName: "square.and.arrow.down"), content: {
                                if newName == "" && newRoom == ""{
                                    noPropertySet = true
                                }else{
                                    if let selectedclass = selectedclass{
                                        selectedclass.name = newName
                                        selectedclass.room = newRoom
                                        selectedclass.teacherName = newTeacherName
                                        selectedclass.credit = newCredit as NSNumber
                                        selectedclass.color = newColor.rawValue
                                    }else{
                                        let selectedclass = ClassData(context: viewContext)
                                        selectedclass.name = newName
                                        selectedclass.room = newRoom
                                        selectedclass.teacherName = newTeacherName
                                        selectedclass.color = newColor.rawValue
                                        selectedclass.credit = newCredit as NSNumber
                                        selectedclass.day = self.day.rawValue
                                        selectedclass.time = self.time as NSNumber
                                    }
                                    try? viewContext.save()
                                    confirmSaveclass = true
                                }
                            }, Text("授業の保存")),
                            (color: .red, image: Image(systemName: "graduationcap"), content: {
                                if existsclass{
                                    goEvalSetting = true
                                }else{
                                    showNoClassAlart = true
                                }
                                buttonexploded = false
                            }, Text("評価項目の設定")),
                            (color: .green, image: Image(systemName: "multiply"), content: {
                                willDeleteEvalItems = true
                            }, Text("評価項目の削除")),
                            (color: .yellow, image: Image(systemName: "multiply"), content: {
                                willDeleteClass = true
                            }, Text("授業の削除"))
                           ],
                           isexploded: $buttonexploded
                           )
            
            .alert("確認", isPresented: $noPropertySet, actions: {
                Button("了解", role: .cancel){
                    noPropertySet = false
                }
            }, message: {
                Text("授業名か教室名を入力してください．")
            })
            
            .alert("確認", isPresented: $confirmSaveclass, actions: {
                Button("了解", role: .cancel){
                    confirmSaveclass = false
                    buttonexploded = false
                }
            }, message: {
                Text("授業を保存しました．")
            })
            
            .alert("確認", isPresented: $showNoClassAlart, actions: {
                Button("了解", role: .cancel){
                    showNoClassAlart = false
                }
            }, message: {
                Text("授業を登録してから評価項目を設定して下さい．")
            })
            
            .alert("確認", isPresented: $willDeleteEvalItems){
                Button("削除", role: .destructive){
                    if let selectedclass = selectedclass{
                        selectedclass.attendlikeEvalItems = nil
                        selectedclass.testlikeEvalItems = nil
                    }
                    try? viewContext.save()
                    buttonexploded = false
                }
                
                Button("戻る", role: .cancel){
                }
            }message: {
                Text("評価項目を全て削除します．宜しいですか？")
            }
            
            .alert("確認", isPresented: $willDeleteClass){
                Button("削除", role: .destructive){
                    if let selectedclass = selectedclass{
                        viewContext.delete(selectedclass)
                        try? viewContext.save()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                
                Button("戻る", role: .cancel){
                }
            }message: {
                Text("この授業を削除します．宜しいですか？")
            }
        }
        
        .onAppear{
            if let selectedclass = selectedclass{
                newName = selectedclass.unwrappedName
                newRoom = selectedclass.unwrappedRoom
                newTeacherName = selectedclass.unwrappedTeacherName
                newCredit = selectedclass.unwrappedCredit
                newColor = classColor(rawValue: selectedclass.unwrappedColor) ?? .gray
            }
        }
    }
}
/*
struct ClassSetting_Previews: PreviewProvider {
    static var previews: some View {
        ClassSetting(day: .monday, time: 1)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(UserSettings())
    }
}
 */

struct Previews_ClassSetting_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

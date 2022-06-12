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
    
    @State var newName: String = "授業名"
    @State var newRoom: String = "教室名"
    @State var newCredit: Int = 2
    @State var newColor: classColor = .gray
    @State var willDeleteEvalItems: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var selectedClass: ClassData? {classes.filter({
        $0.day == day.rawValue &&
        $0.time == time as NSNumber
    }).first
    }
    
    var evalItems: [EvalItem]? {
        if let data = selectedClass?.evalItems{
            let evalitem = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [EvalItem]
            return evalitem
        }else{
            return nil
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            Form{
                TextField("授業名", text: $newName)
                    .padding(.all)
                
                TextField("教室名",  text: $newRoom)
                    .padding(.all)
                
                Stepper("単位数：\(newCredit)", value: $newCredit, in: 1 ... 10)
                
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
                
                NavigationLink(destination: EvalItemSetting(day: day, time: time)){
                    Text("評価項目の設定")
                        .foregroundColor(.blue)
                        .bold()
                        .padding()
                }
                
                Section{
                    if let items = evalItems{
                        ForEach(items, id: \.self){item in
                            HStack{
                                Text(item.name)
                                Spacer()
                                Text("\(Int(item.evalRatio))％")
                            }
                        }
                    }else{
                        Text("評価項目は設定されていません．")
                    }
                }header: {
                    Text("評価項目")
                        .bold()
                }
                Button(action: {
                    willDeleteEvalItems = true
                }){
                    Spacer()
                    Text("評価項目の削除")
                        .bold()
                        .foregroundColor(.red)
                    Spacer()
                }
            }//form ends here
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("＜back")
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .buttonStyle(.plain)
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        if let selectedclass = selectedClass{
                            selectedclass.name = newName
                            selectedclass.room = newRoom
                            selectedclass.credit = newCredit as NSNumber
                            selectedclass.color = newColor.rawValue
                        }else{
                            let selectedclass = ClassData(context: viewContext)
                            selectedclass.name = newName
                            selectedclass.room = newRoom
                            selectedclass.color = newColor.rawValue
                            selectedclass.credit = newCredit as NSNumber
                            selectedclass.day = self.day.rawValue
                            selectedclass.time = self.time as NSNumber
                        }
                        
                        try? viewContext.save()
                        
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("授業を登録")
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .buttonStyle(.plain)
                }
            }
            .onAppear{
                if let selectedclass = selectedClass{
                    newName = selectedclass.unwrappedName
                    newRoom = selectedclass.unwrappedRoom
                    newCredit = selectedclass.unwrappedCredit
                    newColor = classColor(rawValue: selectedclass.unwrappedColor) ?? .gray
                }
                else{
                    newName = "授業名"
                    newRoom = "教室名"
                    newCredit = 2
                    newColor = .gray
                }
            }
        }//navigationview ends here
        .navigationBarHidden(true)
        
        .alert("警告", isPresented: $willDeleteEvalItems){
            Button(action: {
                if let selectedclass = selectedClass{
                    selectedclass.evalItems = nil
                }
                try? viewContext.save()
            }){
                Text("了解")
            }
        }message: {
            Text("評価項目を全て削除します．宜しいですか？")
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

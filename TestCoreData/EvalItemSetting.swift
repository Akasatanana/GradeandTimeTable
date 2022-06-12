//
//  EvalItemSetting.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/01.
//

import SwiftUI

struct EvalItemSetting: View {
    let day: day
    let time: Int
    
    @Environment(\.presentationMode) var presentationMode
    @State var newEvalItems: [EvalItem] = []
    @State var newName: String = "出席"
    @State var newRatio: Double = 60
    @State var newTime: Int = 15
    @State var notHaveEnoughItems: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var selectedClass: ClassData? {classes.filter({
        $0.day == day.rawValue &&
        $0.time == time as NSNumber
    }).first
    }
    
    var sumOfRatio: Double {
        var res :Double = 0
        newEvalItems.forEach{
            res += $0.evalRatio
        }
        return res
    }
    
    var body: some View {
        Form{
            Section{
                TextField("", text: $newName)
                    .padding()
                
                VStack{
                    Text("評価割合：\(Int(newRatio))%")
                    Slider(value: $newRatio, in: 1 ... 100, step: 1)
                }
                Stepper("評価回数：\(newTime)", value: $newTime, in: 1 ... 20)
                
                Button(action: {
                    let newitem = EvalItem(newname: newName, newratio: newRatio, newtime: newTime)
                    newEvalItems.append(newitem)
                }){
                    HStack{
                        Spacer()
                        Text("項目を追加")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
               
            }header: {
                Text("追加する項目の設定")
            }
            
            Section{
                ForEach(newEvalItems, id: \.self){evalitem in
                    HStack{
                        Text(evalitem.name)
                        Spacer()
                        VStack(alignment: .leading){
                            Text("評価割合：\(Int(evalitem.evalRatio))％")
                            Text("評価回数：\(evalitem.evalTime)回")
                        }
                    }
                }
            }header: {
                HStack(){
                    Text("現在の評価項目")
                    Spacer()
                    Text("残り\(Int(100 - sumOfRatio))%")
                        .bold()
                }
            }
            
        }//Form ends here
        .alert("注意",
               isPresented: $notHaveEnoughItems){
            Button(action: {
                
            }){
                Text("了解")
            }
        }message: {
            Text("評価割合の合計が100%になるように設定して下さい．")
        }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        if sumOfRatio == 100{
                            if let selectedclass = selectedClass{
                                do{
                                    if let data: Data? = try NSKeyedArchiver.archivedData(withRootObject: newEvalItems, requiringSecureCoding: false) as Data{
                                        selectedclass.evalItems = data
                                    }else{
                                        selectedclass.evalItems = nil
                                    }
                                }catch let errror{
                                    print(errror.localizedDescription)
                                }
                            }else{
                                let selectedclass = ClassData(context: viewContext)
                                selectedclass.day = self.day.rawValue
                                selectedclass.time = self.time as NSNumber
                                do{
                                    if let data: Data? = try NSKeyedArchiver.archivedData(withRootObject: newEvalItems, requiringSecureCoding: false) as Data{
                                        selectedclass.evalItems = data
                                    }else{
                                        selectedclass.evalItems = nil
                                    }
                                }catch let errror{
                                    print(errror.localizedDescription)
                                }
                            }
                            try? viewContext.save()
                            presentationMode.wrappedValue.dismiss()
                        }else{
                            notHaveEnoughItems = true
                        }
                        
                    }){
                        Text("評価項目を保存")
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .buttonStyle(.plain)
                }
        }
            .onAppear{
                
            }
    }
}

struct EvalItemSetting_Previews: PreviewProvider {
    static var previews: some View {
        EvalItemSetting(day: .monday, time: 1)
    }
}

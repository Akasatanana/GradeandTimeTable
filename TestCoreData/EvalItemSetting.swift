//
//  EvalItemSetting.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/01.
//

import SwiftUI

struct EvalItemSetting: View {
    @OptionalObservedObject var selectedclass: ClassData?
    
    @Environment(\.presentationMode) var presentationMode
    @State var newEvalItems: [EvalItem] = []
    @State var newName: String = ""
    @State var isEditingName: Bool = false
    @State var newRatio: Double = 60
    @State var isEditingRatio: Bool = false
    @State var newTime: Int = 1
    @State var notHaveEnoughItems: Bool = false
    @State var noEvalItems: Bool = false
    @State var noName: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var sumOfRatio: Double {
        var res :Double = 0
        newEvalItems.forEach{
            res += $0.evalRatio
        }
        return res
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                HStack{
                    Text("追加する評価項目の設定")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                VStack(alignment: .center, spacing: 20){
                    HStack{
                        Image(systemName: "a.circle.fill")
                            .foregroundColor(isEditingName ? .blue : .black)
                            .shadow(color: isEditingName ? .blue : .clear, radius: 0.2)
                        Text(":")
                            .foregroundColor(isEditingName ? .blue : .black)
                            .shadow(color: isEditingName ? .blue : .clear, radius: 0.2)
                        TextField("項目名", text: $newName,
                                  onEditingChanged: {begin in
                            if begin {
                                isEditingName = true
                                newName = ""
                            }else{
                                isEditingName = false
                            }
                            
                        })
                            .multilineTextAlignment(.leading)
                    }
                    .frame(width: screenWidth * 0.75,
                           height: screenHeight * 0.03)
                    Divider()
                    
                    VStack{
                        Text("評価割合：\(Int(newRatio))%")
                            .foregroundColor(isEditingRatio ? .blue : .black)
                        Slider(value: $newRatio, in: 1 ... 100, step: 1, onEditingChanged: {begin in
                            if begin {
                                isEditingRatio = true
                            }else{
                                isEditingRatio = false
                            }
                        })
                    }
                    .frame(width: screenWidth * 0.75,
                           height: screenHeight * 0.06)
                    Divider()
                    Stepper("評価回数：\(newTime)", value: $newTime, in: 1 ... 20)
                        .frame(width: screenWidth * 0.75,
                               height: screenHeight * 0.03)
                }
                .fixedSize()
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                
                Button(action: {
                    if newName == ""{
                        noName = true
                    }else if sumOfRatio + newRatio > 100{
                        notHaveEnoughItems = true
                    }else{
                        let newitem = EvalItem(newname: newName, newratio: newRatio, newtime: newTime)
                        newEvalItems.append(newitem)
                    }
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: screenWidth / 2 , height: screenHeight * 0.08, alignment: .center)
                        .foregroundColor(.blue)
                        .overlay{
                            Text("項目を追加")
                                .bold()
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: (screenWidth / 2) * 0.8)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                    }
                }
                .alert("注意",
                       isPresented: $noName){
                    Button("了解", role: .cancel){
                        noName = false
                    }
                }message: {
                    Text("評価項目の名前を設定して下さい．")
                }
                
                HStack{
                    Text("現在の評価項目")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("残り\(100 - Int(sumOfRatio))％")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                VStack{
                    if newEvalItems != []{
                        ForEach(newEvalItems, id: \.self){evalitem in
                            HStack{
                                Text(evalitem.name)
                                Spacer()
                                VStack(alignment: .leading){
                                    Text("評価割合：\(Int(evalitem.evalRatio))％")
                                    Text("評価回数：\(evalitem.evalTime)回")
                                }
                            }
                            .frame(width: screenWidth * 0.75,
                                   height: screenHeight * 0.06)
                            if evalitem != newEvalItems.last{
                                Divider()
                            }
                        }
                    }else{
                        Text("評価項目が未設定です．")
                            .frame(width: screenWidth * 0.75,
                                   height: screenHeight * 0.06)
                    }
                }
                .fixedSize()
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                        .background(.white)
                }
            }
            .frame(width: screenWidth * 0.9)
        }
        .navigationBarBackButtonHidden(true)
        .alert("注意",
               isPresented: $notHaveEnoughItems){
            Button("了解", role: .cancel){
                notHaveEnoughItems = false
            }
        }message: {
            Text("評価割合の合計が100%になるように設定して下さい．")
        }
        .alert("注意", isPresented: $noEvalItems){
            Button("了解", role: .destructive){
                presentationMode.wrappedValue.dismiss()
                noEvalItems = false
            }
            
            Button("設定に戻る", role: .cancel){
                noEvalItems = false
            }
        }message: {
            Text("評価項目が保存されていませんが，宜しいですか？")
        }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        if sumOfRatio == 100{
                            if let selectedclass = selectedclass {
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
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        noEvalItems = true
                    }, label: {
                        Text("＜戻る")
                    })
                }
        }
    }
}
/*
struct EvalItemSetting_Previews: PreviewProvider {
    static var previews: some View {
        EvalItemSetting(day: .monday, time: 1)
    }
}
 */

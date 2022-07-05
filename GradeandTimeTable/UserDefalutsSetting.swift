//
//  UserDefalutsSetting.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/09.
//

import SwiftUI

struct UserDefalutsSetting: View {
    @EnvironmentObject var setting: UserSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var willDeleteClasses: Bool = false
    var sumOfCredit: Int {
        var res = 0
        for classdata in classes{
            res += classdata.unwrappedCredit
        }
        return res
    }
    
    var body: some View {
        Form{
            Section{
                HStack{
                    Spacer()
                    Text("\(sumOfCredit)単位")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            }header: {
                Text("合計単位数")
            }
            Section{
                HStack(){
                    Spacer()
                    VStack{
                        Button(action: {
                            setting.lastClassTime += 1
                            setting.classStartsEndsTimes.append([0, 0, 0, 0])
                        }, label: {
                            Image(systemName: "play.fill")
                                .rotationEffect(.degrees(-90))
                        })
                        .buttonStyle(.borderless)
                        .foregroundColor(.red)
                        
                        Text("\(setting.lastClassTime)")
                            .font(.title)
                        Button(action: {
                            if setting.lastClassTime - 1 > 0  {
                                setting.classStartsEndsTimes.removeLast()
                                setting.lastClassTime -= 1
                            }
                        }, label: {
                            Image(systemName: "play.fill")
                                .rotationEffect(.degrees(90))
                        }).buttonStyle(.borderless)
                    }
                    Text("時限目まで")
                        .font(.title2)
                    Spacer()
                }
            }header: {
                Text("授業時間の設定")
            }
            Section{
                TextField("時間割名", text: $setting.timeTableName)
                    .padding()
            }header: {
                Text("時間割名の変更")
            }
            Section{
                Toggle("授業時間を表示する", isOn: $setting.showClassStartsEndsTimes)
                ForEach(setting.classStartsEndsTimes.indices, id: \.self){index in
                    HStack{
                        Text("\(index + 1)時限目")
                        Spacer()
                        
                        ForEach(setting.classStartsEndsTimes[index].indices, id: \.self){idx in
                            if idx % 2 == 0{
                                Picker("", selection: $setting.classStartsEndsTimes[index][idx]){
                                    ForEach(1 ... 23, id: \.self){num in
                                        Text("\(num)")
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                Text("：")
                            }else{
                                Picker("", selection: $setting.classStartsEndsTimes[index][idx]){
                                    ForEach(0 ... 59, id: \.self){num in
                                        Text("\(num)")
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                if idx == 1{Text("〜")}
                            }
                        }
                    }
                }
            }header: {
                Text("授業時間の設定")
            }
            HStack{
                Spacer()
                Button(action: {
                    willDeleteClasses = true
                }){
                    Text("時間割の削除")
                        .bold()
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .alert("警告",
                   isPresented: $willDeleteClasses){
                Button("削除",role: .destructive){
                    setting.lastClassTime = 5
                    setting.timeTableName = "時間割"
                    
                    for classdata in classes{
                        viewContext.delete(classdata)
                    }
                    try? viewContext.save()
                    willDeleteClasses = false
                    presentationMode.wrappedValue.dismiss()
                }
                
                Button("了解", role: .cancel){
                    willDeleteClasses = false
                }
                
            }message: {
                Text("登録した時間割を消去します．宜しいですか？")
            }
        }
    }
}
struct UserDefalutsSetting_Previews: PreviewProvider {
    static var previews: some View {
        UserDefalutsSetting()
            .environmentObject(UserSettings())
    }
}

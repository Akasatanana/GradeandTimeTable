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
    
    var body: some View {
        Form{
            Section{
                HStack(){
                    Spacer()
                    VStack{
                        Button(action: {
                            setting.firstClassTime += 1
                        }, label: {
                            Image(systemName: "play.fill")
                                .rotationEffect(.degrees(-90))
                        }).buttonStyle(.borderless)
                        Text("\(setting.firstClassTime)")
                            .font(.title)
                        Button(action: {
                            setting.firstClassTime -= 1
                        }, label: {
                            Image(systemName: "play.fill")
                                .rotationEffect(.degrees(90))
                        }).buttonStyle(.borderless)
                    }
                    Text("〜")
                        .font(.title2)
                    VStack{
                        Button(action: {
                            setting.lastClassTime += 1
                        }, label: {
                            Image(systemName: "play.fill")
                                .rotationEffect(.degrees(-90))
                        }).buttonStyle(.borderless)
                        Text("\(setting.lastClassTime)")
                            .font(.title)
                        Button(action: {
                            setting.lastClassTime -= 1
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
                Button(action: {
                    setting.firstClassTime = 1
                    setting.lastClassTime = 5
                    setting.timeTableName = "時間割"
                    
                    for classdata in classes{
                        viewContext.delete(classdata)
                    }
                    try? viewContext.save()
                    willDeleteClasses = false
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("了解")
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

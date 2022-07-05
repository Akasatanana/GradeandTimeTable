//
//  ClassMatrix.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import SwiftUI

struct ClassMatrix: View {
    @EnvironmentObject var setting: UserSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var body: some View {
        NavigationView{
            ScrollView(){
                HStack(alignment: .bottom, spacing: setting.classBoxSpaceWidth){
                    TimeIndex()
                    VStack(alignment: .center, spacing: setting.classBoxSpaceHeight){
                        DayIndex()
                        HStack(spacing: setting.classBoxSpaceWidth){
                            ForEach(day.all, id: \.self){day in
                                VStack(spacing: setting.classBoxSpaceHeight){
                                    ForEach(setting.classRange, id: \.self){time in
                                        let selectedclass = classes.filter({
                                            $0.unwrappedDay == day.rawValue &&
                                            $0.unwrappedTime == time
                                        }).first
                                        
                                        NavigationLink(destination: {ClassSetting(day: day, time: time)}){
                                            ClassBox(selectedclass: selectedclass)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(destination: {
                        UserDefalutsSetting()
                    }){
                        Image(systemName: "gearshape")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
                
                ToolbarItem(placement: .principal){
                    Text(setting.timeTableName)
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
    }
}

struct Previews_ClassMatrix_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

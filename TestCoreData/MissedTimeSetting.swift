//
//  MissedTimeSetting.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/10.
//

import SwiftUI

struct MissedTimeSetting: View {
    let day: day
    let time: Int
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var setting: UserSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var body: some View {
        VStack{
            TextField("授業名", text: $newName)
            Button(action: {
                classData.name = newName
                try? viewContext.save()
            }){
                Text("てすと")
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

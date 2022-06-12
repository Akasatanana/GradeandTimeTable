//
//  ContentView.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    init(){
        UserDefaults.standard.register(defaults: ["firstClassTime": 1,
                                                  "lastClassTime": 6,
                                                  "timeTableName": "時間割!!"])
    }
    var body: some View {
        TabView{
            ClassMatrix()
                .tabItem{
                    Image(systemName: "rectangle.grid.3x2.fill")
                    Text("時間割")
                }
            ShowAllEvaluatedCards()
                .tabItem{
                    Image(systemName: "square.stack.fill")
                    Text("評価")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

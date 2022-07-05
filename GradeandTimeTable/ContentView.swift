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
        UserDefaults.standard.register(defaults: ["lastClassTime": 5,
                                                  "timeTableName": "時間割",
                                                  "classStartsEndsTimes": Array(repeating: [0, 0, 0, 0], count: 5),
                                                  "showClassStartsEndsTimes": false
                                                 ])
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

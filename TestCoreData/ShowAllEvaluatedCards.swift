//
//  ShowAllEvaluatedCards.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/10.
//

import SwiftUI

struct ShowAllEvaluatedCards: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var setting: UserSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var evaluatedClasses: [ClassData] {
        return classes.filter({
            $0.evalItems != nil
        })
    }
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    ForEach(evaluatedClasses, id: \.self){classdata in
                        NavigationLink(destination: {
                            MissedTimeSetting(classData: classdata)
                        }){
                            EvaluatedCard(classData: classdata)
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("成績評価")
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
    }
}

struct ShowAllEvaluatedCards_Previews: PreviewProvider {
    static var previews: some View {
        ShowAllEvaluatedCards()
    }
}

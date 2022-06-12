//
//  EvalatedCards.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/06/10.
//

import SwiftUI

struct EvalatedCards: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var setting: UserSettings

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        predicate: NSPredicate(format: "evalItems != %@", nil),
        animation: .)
    )
    private var classes: FetchedResults<ClassData>
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EvalatedCards_Previews: PreviewProvider {
    static var previews: some View {
        EvalatedCards()
    }
}

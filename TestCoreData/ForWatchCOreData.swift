//
//  ForWatchCOreData.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/19.
//

import SwiftUI

struct ForWatchCOreData: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    var body: some View {
        VStack(){
            ForEach(classes, id: \.self){classdata in
                Text(classdata.unwrappedDay + classdata.unwrappedTime.description + classdata.unwrappedColor)
            }
        }
    }
}

struct ForWatchCOreData_Previews: PreviewProvider {
    static var previews: some View {
        ForWatchCOreData()
    }
}

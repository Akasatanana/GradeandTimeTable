//
//  classBox.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import SwiftUI

struct ClassBox: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var setting: UserSettings

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClassData.time, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<ClassData>
    
    let day: day
    let time: Int
    
    var body: some View {
        if let classdata = classes.filter({
            $0.unwrappedDay == day.rawValue &&
            $0.unwrappedTime == time
        }).first{
            ZStack(alignment: .center){
                Rectangle()
                    .frame(width: setting.classBoxWidth, height: setting.classBoxHeight)
                    .foregroundColor(Color(classdata.unwrappedColor))
                
                VStack(alignment: .center, spacing: 1){
                    Text(classdata.unwrappedName)
                        .frame(width: setting.classBoxWidth * 0.8)
                        .font(.body)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                    Text(classdata.unwrappedRoom)
                        .frame(width: setting.classBoxWidth * 0.8)
                        .font(.body)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                }
                .frame(width: setting.classBoxWidth, height: setting.classBoxHeight)
            }
        }else{
            ZStack(alignment: .center){
                Rectangle()
                    .frame(width: setting.classBoxWidth, height: setting.classBoxHeight)
                    .foregroundColor(classColor.gray.toColor())
                
                VStack(alignment: .center, spacing: 1){
                    Text("")
                        .font(.body)
                    Text("")
                        .font(.body)
                }
                .frame(width: setting.classBoxWidth, height: setting.classBoxHeight)
            }
        }
    }
}

/*
struct ClassBoxPreview: PreviewProvider{
    static var previews: some View {
        ClassBox(classData: <#T##ClassData#>)
    }
}
 */

//
//  classBox.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import SwiftUI

struct ClassBox: View {
    @EnvironmentObject var setting: UserSettings

    @OptionalObservedObject var selectedclass: ClassData?
    var body: some View {
        if let classdata = selectedclass{
            ZStack(alignment: .center){
                Rectangle()
                    .frame(width: setting.classBoxWidth, height: setting.classBoxHeight)
                    .foregroundColor(Color(classdata.unwrappedColor))
                
                VStack(alignment: .center, spacing: 1){
                    Text(classdata.unwrappedName)
                        .frame(width: setting.classBoxWidth * 0.9)
                        .font(.body)
                        .lineLimit(2)
                        .minimumScaleFactor(0.2)
                        .foregroundColor(.white)
                    Text(classdata.unwrappedRoom)
                        .frame(width: setting.classBoxWidth * 0.9)
                        .font(.body)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .foregroundColor(.white)
                }
                .frame(width: setting.classBoxWidth, height: setting.classBoxHeight)
            }
        }else{
            Rectangle()
                .frame(width: setting.classBoxWidth, height: setting.classBoxHeight)
                .foregroundColor(classColor.gray.toColor())
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

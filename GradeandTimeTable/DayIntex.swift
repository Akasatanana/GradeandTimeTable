//
//  DayIntex.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import SwiftUI

struct DayIndex: View {
    @EnvironmentObject var setting: UserSettings
    var body: some View {
        HStack(spacing: setting.classBoxSpaceWidth){
            ForEach(day.all, id: \.self){day in
                ZStack(){
                    Rectangle()
                        .frame(width: setting.classBoxWidth, height: setting.indexBoxHeight)
                        .foregroundColor(.white)
                    
                    Text(day.rawValue)
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }
        }
    }
}

struct DayIndex_Previews: PreviewProvider {
    static var previews: some View {
        DayIndex()
    }
}

//
//  TimeIntex.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import SwiftUI

struct TimeIndex: View {
    @EnvironmentObject var setting: UserSettings
    var body: some View {
        VStack(spacing: setting.classBoxSpaceHeight){
            ForEach(0 ... setting.lastClassTime - 1, id: \.self){time in
                ZStack(){
                    Rectangle()
                        .frame(width: setting.indexBoxWidth, height: setting.classBoxHeight)
                        .foregroundColor(.white)
                    
                    VStack(){
                        if setting.showClassStartsEndsTimes{
                            Text(String(format: "%02d", setting.classStartsEndsTimes[time][0]) + "：" + String(format: "%02d", setting.classStartsEndsTimes[time][1]))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding(.top)
                        }
                        Spacer()
                        Text("\(time + 1)")
                            .font(.title3)
                            .foregroundColor(.black)
                        Spacer()
                        if setting.showClassStartsEndsTimes{
                            Text(String(format: "%02d", setting.classStartsEndsTimes[time][2]) + "：" + String(format: "%02d", setting.classStartsEndsTimes[time][3]))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding(.bottom)
                        }
                    }
                    .frame(height: setting.classBoxHeight)
                }
            }
        }
    }
}

struct ClassTimeIndex_Previews: PreviewProvider {
    static var previews: some View {
        TimeIndex()
    }
}

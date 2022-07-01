//
//  ParentalButton.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/07/01.
//

import SwiftUI

struct ParentalButton: View {
    @State var childrenButtonsInfo: [(color: Color, image: Image, content: () -> (), message: String)]
    @State var isexploded: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            ForEach(childrenButtonsInfo.indices, id: \.self){index in
                HStack{
                    ChildButton(color: childrenButtonsInfo[index].color,
                                image: childrenButtonsInfo[index].image,
                                flg: $isexploded,
                                offset: CGFloat(-80 * (index + 1)),
                                message: childrenButtonsInfo[index].message,
                                content: childrenButtonsInfo[index].content)
                }
            }
            
            Button(action: {
                isexploded.toggle()
            }, label: {
                ZStack{
                    Circle()
                        .fill()
                        .foregroundColor(.gray)
                        .frame(width: 50, height: 50)
                    Image(systemName: "menucard")
                        .foregroundColor(.black)
                }
                .shadow(color: .gray.opacity(0.8), radius: 10)
            })
        }
    }
}

struct ParentalButton_Previews: PreviewProvider {
    static var previews: some View {
        ParentalButton(childrenButtonsInfo: [
            (color: .blue, image: Image(systemName: "pencil"), content: {}, "青"),
            (color: .red, image: Image(systemName: "pencil"), content: {}, "赤"),
            (color: .green, image: Image(systemName: "pencil"), content: {}, "緑")
        ])
    }
}

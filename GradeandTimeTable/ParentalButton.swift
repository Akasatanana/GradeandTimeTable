//
//  ParentalButton.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/07/01.
//

import SwiftUI

struct ParentalButton: View {
    var position: (x: CGFloat, y: CGFloat)
    var offset: CGFloat = 80.0
    @State var childrenButtonsInfo: [(color: Color, image: Image, content: () -> (), message: Text)]
    @Binding var isexploded: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            ForEach(childrenButtonsInfo.indices, id: \.self){index in
                HStack{
                    ChildButton(color: childrenButtonsInfo[index].color,
                                image: childrenButtonsInfo[index].image,
                                flg: $isexploded,
                                offset: CGFloat(-(offset) * CGFloat((index + 1))),
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
                        .frame(width: 60, height: 60)
                    Image(systemName: isexploded ? "menucard" : "menucard.fill")
                        .foregroundColor(.black)
                }
            })
        }
        .position(x: position.x, y: position.y)
    }
}

struct ParentalButton_Previews: PreviewProvider {
    @State static var flg = false
    static var previews: some View {
        ParentalButton(position: (x:screenWidth * 0.9 ,y: screenHeight * 0.5),
                       offset: 60.0,
                       childrenButtonsInfo: [
            (color: .blue, image: Image(systemName: "pencil"), content: {}, Text("青")),
            (color: .red, image: Image(systemName: "pencil"), content: {}, Text("赤")),
            (color: .green, image: Image(systemName: "pencil"), content: {}, Text("緑"))
        ],
        isexploded: $flg)
    }
}

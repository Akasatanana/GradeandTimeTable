//
//  ChildButton.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/07/01.
//

import SwiftUI

struct ChildButton: View {
    @State var color: Color
    @State var image: Image
    @Binding var flg: Bool
    @State var offset: CGFloat
    @State var message: String?
    var content: () -> ()
    var body: some View {
        HStack{
            if let message = message{
                Text(message)
                    .foregroundColor(.gray)
                    .opacity(flg ? 1.0 : 0.0)
                    .animation(.linear(duration: 0.5), value: flg)
            }
            Button(action: content){
                ZStack{
                    Circle()
                        .fill()
                        .foregroundColor(color)
                        .frame(width: 50, height: 50)
                    image
                        .foregroundColor(.black)
                }
                .shadow(color: .gray.opacity(0.8), radius: 10)
            }
        }
        .offset(x: 0.0, y: flg ? offset : 0)
        .animation(.easeOut(duration: 0.5), value: flg)
    }
}

struct ChildButton_Previews: PreviewProvider {
    @State static var flg = false
    static var previews: some View {
        ChildButton(color: .blue, image: Image(systemName: "menucard"), flg: $flg, offset: 100.0){
            
        }
    }
}

//
//  Data.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import Foundation
import CoreData
import SwiftUI

class UserSettings: ObservableObject{
    @Published var firstClassTime: Int {
        didSet{
            UserDefaults.standard.set(firstClassTime, forKey: "firstClassTime")
        }
    }

    @Published var lastClassTime: Int {
        didSet{
            UserDefaults.standard.set(lastClassTime, forKey: "lastClassTime")
        }
    }

    @Published var timeTableName: String {
        didSet{
            UserDefaults.standard.set(timeTableName, forKey: "timeTableName")
        }
    }
    init(){
        self.firstClassTime = UserDefaults.standard.integer(forKey: "firstClassTime")
        self.lastClassTime = UserDefaults.standard.integer(forKey: "lastClassTime")
        self.timeTableName = UserDefaults.standard.string(forKey: "timeTableName") ?? "時間割"
    }
    
    var classRange:ClosedRange<Int> {firstClassTime ... lastClassTime}

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height * 0.85


    var classBoxWidth: CGFloat {screenWidth / (CGFloat(Float(classRange.count)) + 0.5)}
    var classBoxHeight: CGFloat {screenHeight / (CGFloat(Float(classRange.upperBound)) + 0.35)}

    var indexBoxWidth: CGFloat {screenWidth / 16}
    var indexBoxHeight: CGFloat {screenHeight / 20}

var classBoxSpaceWidth: CGFloat {(screenWidth - (classBoxWidth * CGFloat(Float(classRange.count)) + indexBoxWidth)) / CGFloat(Float(classRange.count))}
var classBoxSpaceHeight: CGFloat {(screenHeight - (classBoxHeight * (CGFloat(Float(classRange.upperBound))) + indexBoxHeight)) / (CGFloat(Float(classRange.upperBound)))}
    
}


enum day : String, Comparable{
    case monday = "月"
    case tuesday = "火"
    case wednesday = "水"
    case thursday = "木"
    case friday = "金"
    
    static var all: [day] = [monday,
                             tuesday,
                             wednesday,
                             thursday,
                             friday]
    
    static func < (lhs: day, rhs: day) -> Bool {
            return lhs.order < rhs.order
        }

        var order: Int {
            return day.all.firstIndex(of: self) ?? 0
        }
}

enum classColor: String{
    case pink
    case violet
    case blue
    case green
    case orange
    case gray
    
    func toColor() -> Color{
        return Color(self.rawValue)
    }
    
    static var all: [classColor] = [pink,
                                    violet,
                                    blue,
                                    green,
                                    orange,
                                    gray]
}

class EvalItem: NSObject, NSCoding, Codable{
    var name: String
    var evalRatio: Double
    var evalTime: Int
    var missedTime: Int = 0
    init(newname: String, newratio: Double, newtime: Int){
        self.name = newname
        self.evalRatio = newratio
        self.evalTime = newtime
    }
    
    
    required init?(coder: NSCoder){
        self.name = (coder.decodeObject(forKey: "name") as? String) ?? ""
        self.evalRatio = coder.decodeDouble(forKey: "evalRatio")
        self.evalTime = coder.decodeInteger(forKey: "evalTime")
        self.missedTime = coder.decodeInteger(forKey: "missedTime")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.evalRatio, forKey: "evalRatio")
        coder.encode(self.evalTime, forKey: "evalTime")
        coder.encode(self.missedTime, forKey: "missedTime")
    }
}

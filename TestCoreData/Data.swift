//
//  Data.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//

import Foundation
import CoreData
import SwiftUI
import Combine

let screenWidth = UIScreen.main.bounds.size.width * 0.95
let screenHeight = UIScreen.main.bounds.size.height * 0.85

class UserSettings: ObservableObject{
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
    @Published var classStartsEndsTimes: [[Int]]{
        didSet{
            UserDefaults.standard.set(classStartsEndsTimes, forKey: "classStartsEndsTimes")
        }
    }
    @Published var showClassStartsEndsTimes: Bool{
        didSet{
            UserDefaults.standard.set(showClassStartsEndsTimes, forKey: "showClassStartsEndsTimes")
        }
    }
    
    init(){
        self.lastClassTime = UserDefaults.standard.integer(forKey: "lastClassTime")
        self.timeTableName = UserDefaults.standard.string(forKey: "timeTableName") ?? "時間割"
        self.classStartsEndsTimes = UserDefaults.standard.array(forKey: "classStartsEndsTimes") as? [[Int]] ?? [[]]
        self.showClassStartsEndsTimes = UserDefaults.standard.bool(forKey: "showClassStartsEndsTimes")
    }
    
    var classRange:ClosedRange<Int> {1 ... lastClassTime}

    var classBoxWidth: CGFloat {screenWidth / (CGFloat(Float(day.all.count)) + 0.5)}
    var classBoxHeight: CGFloat {screenHeight / (CGFloat(Float(5)) + 0.35)}

    var indexBoxWidth: CGFloat {screenWidth / 16}
    var indexBoxHeight: CGFloat {screenHeight / 20}

    var classBoxSpaceWidth: CGFloat = 2
    var classBoxSpaceHeight: CGFloat = 2
    
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

protocol EvalItem {
    var name: String {get set}
    var evalRatio: Double {get set}
    var evalTime: Int {get set}
}

class AttendlikeEvalItem: NSObject, NSCoding, Codable{
    var name: String
    var evalRatio: Double
    var evalTime: Int
    var gotTime: Int = 0
    init(newname: String, newratio: Double, newtime: Int){
        self.name = newname
        self.evalRatio = newratio
        self.evalTime = newtime
    }
    
    
    required init?(coder: NSCoder){
        self.name = (coder.decodeObject(forKey: "name") as? String) ?? ""
        self.evalRatio = coder.decodeDouble(forKey: "evalRatio")
        self.evalTime = coder.decodeInteger(forKey: "evalTime")
        self.gotTime = coder.decodeInteger(forKey: "missedTime")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.evalRatio, forKey: "evalRatio")
        coder.encode(self.evalTime, forKey: "evalTime")
        coder.encode(self.gotTime, forKey: "missedTime")
    }
}

class TestlikeEvalItem: NSObject, NSCoding, Codable{
    var name: String
    var evalRatio: Double
    var evalTime: Int
    var gotRatios: [Int] = []
    init(newname: String, newratio: Double, newtime: Int){
        self.name = newname
        self.evalRatio = newratio
        self.evalTime = newtime
    }
    
    
    required init?(coder: NSCoder){
        self.name = (coder.decodeObject(forKey: "name") as? String) ?? ""
        self.evalRatio = coder.decodeDouble(forKey: "evalRatio")
        self.evalTime = coder.decodeInteger(forKey: "evalTime")
        self.gotRatios = (coder.decodeObject(forKey: "missedRatios") as? [Int]) ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.evalRatio, forKey: "evalRatio")
        coder.encode(self.evalTime, forKey: "evalTime")
        coder.encode(self.gotRatios, forKey: "missedRatios")
    }
}



/// A wrapper of the underlying optional observable object
/// that will emit a notification when the optional state or the observable object changes.
public class OptionalWrapper<ObjectType: ObservableObject>: ObservableObject {
    
    /// The subscrption of underlying observable object.
    private var cancellable: AnyCancellable?
    
    /// The underlying optional observable object.
    public var optionalObject: ObjectType? {
        willSet { observe(newValue) }
    }
    
    /// Creates an OptionalWrapper with an optional observable object.
    public init(optionalObject: ObjectType?) {
        self.optionalObject = optionalObject
        observe(optionalObject)
    }
    
    /// Observe the new observable object.
    private func observe(_ newObject: ObjectType?) {
        objectWillChange.send()
        cancellable = newObject?.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}

/// A property wrapper type that subscribes to an optional observable object and
/// invalidates a view whenever the optional state or the observable object changes.
@propertyWrapper
public struct OptionalObservedObject<ObjectType: ObservableObject>: DynamicProperty {

    @dynamicMemberLookup
    public struct Wrapper {

        internal let optionalWrapper: OptionalWrapper<ObjectType>

        public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Optional<Subject>> {
            Binding<Optional<Subject>>.init {
                optionalWrapper.optionalObject?[keyPath: keyPath]
            } set: { subject in
                if let subject = subject {
                    optionalWrapper.optionalObject?[keyPath: keyPath] = subject
                }
            }
        }
    }
    
    /// The underlying wrapper for the optional observable object.
    @ObservedObject private var objectWrapper: OptionalWrapper<ObjectType>

    public init(wrappedValue: ObjectType?) {
        _objectWrapper = .init(initialValue: OptionalWrapper(optionalObject: wrappedValue))
    }

    public var wrappedValue: ObjectType? {
        get { objectWrapper.optionalObject }
        nonmutating set { objectWrapper.optionalObject = newValue }
    }
    public var projectedValue: OptionalObservedObject<ObjectType>.Wrapper {
        Wrapper(optionalWrapper: objectWrapper)
    }
}

func CalcgotRatio(classdata: ClassData) -> Double{
    var gotRatio: Double = 0.0
    if let data = classdata.attendlikeEvalItems{
        let evalitems = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [AttendlikeEvalItem]
        for item in evalitems{
            gotRatio += (Double(item.evalRatio) / Double(item.evalTime)) * Double(item.gotTime)
        }
    }
    
    if let data = classdata.testlikeEvalItems{
        let evalitems = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TestlikeEvalItem]
        for item in evalitems{
            for ratio in item.gotRatios{
                gotRatio += (Double(item.evalRatio) / Double(item.evalTime)) * Double(ratio / 100)
            }
        }
    }
    return gotRatio
}

enum grade: Int{
    case S = 90
    case A = 80
    case B = 70
    case C = 60
    case D = 0
    
    static var all: [grade] = [S,
                             A,
                             B,
                             C,
                             D]
}

func JudgeGrade(classdata: ClassData) -> String?{
    switch  CalcgotRatio(classdata: classdata){
    case Double(grade.D.rawValue) ..< Double(grade.C.rawValue):
        return "D"
    case Double(grade.C.rawValue) ..< Double(grade.B.rawValue):
        return "C"
    case Double(grade.B.rawValue) ..< Double(grade.A.rawValue):
        return "B"
    case Double(grade.A.rawValue) ..< Double(grade.S.rawValue):
        return "A"
    case Double(grade.S.rawValue) ..< Double(100):
        return "S"
    default:
        return nil
    }
}

func JudgeGradePoint(classdata: ClassData) -> Double?{
    switch  CalcgotRatio(classdata: classdata){
    case Double(grade.D.rawValue) ..< Double(grade.C.rawValue):
        return 0.0
    case Double(grade.C.rawValue) ..< Double(grade.B.rawValue):
        return 1.0
    case Double(grade.B.rawValue) ..< Double(grade.A.rawValue):
        return 2.0
    case Double(grade.A.rawValue) ..< Double(grade.S.rawValue):
        return 3.0
    case Double(grade.S.rawValue) ..< Double(100):
        return 4.0
    default:
        return nil
    }
}

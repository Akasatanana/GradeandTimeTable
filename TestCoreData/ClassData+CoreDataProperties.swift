//
//  ClassData+CoreDataProperties.swift
//  TestCoreData
//
//  Created by Akasatanana on 2022/05/07.
//
//

import Foundation
import CoreData


extension ClassData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassData> {
        return NSFetchRequest<ClassData>(entityName: "ClassData")
    }

    @NSManaged public var color: String?
    @NSManaged public var day: String?
    @NSManaged public var attendlikeEvalItems: Data?
    @NSManaged public var testlikeEvalItems: Data?
    @NSManaged public var name: String?
    @NSManaged public var room: String?
    @NSManaged public var time: NSNumber?
    @NSManaged public var credit: NSNumber?
    @NSManaged public var teacherName: String?

}

extension ClassData : Identifiable {

}

extension ClassData {
    public var unwrappedColor: String {color ?? classColor.gray.rawValue}
    public var unwrappedDay: String {day ?? ""}
    public var unwrappedName: String {name ?? ""}
    public var unwrappedRoom: String {room ?? ""}
    public var unwrappedTime: Int {time?.intValue ?? -1}
    public var unwrappedCredit: Int {credit?.intValue ?? 0}
    public var unwrappedTeacherName: String {teacherName ?? ""}
    
}

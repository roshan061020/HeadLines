//
//  NamedNSManagedObject+Extensions.swift
//  ShortNews
//
//  Created by Roshan yadav on 18/09/24.
//

import Foundation
import CoreData

// MARK: - NamedNSManagedObject Protocol
protocol NamedNSManagedObject: AnyObject {
    associatedtype Entity: NSManagedObject
    var name: String? { get set }
    static func fetchRequest() -> NSFetchRequest<Entity>
    init(context: NSManagedObjectContext)
}

extension SourceEntity: NamedNSManagedObject {}
extension CategoryEntity: NamedNSManagedObject {}

extension NamedNSManagedObject {
    static func fetchOrSave(name: String, from context: NSManagedObjectContext) throws -> Self {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        let objects = try context.fetch(fetchRequest)
        if let object = objects.first as? Self {
            return object
        }
        let newObject = Self.init(context: context)
        newObject.name = name
        return newObject
    }
}

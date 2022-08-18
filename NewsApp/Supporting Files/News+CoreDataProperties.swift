//
//  News+CoreDataProperties.swift
//  
//
//  Created by Kavya on 18/08/22.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var name: String?
    @NSManaged public var title: String?
    @NSManaged public var image: String?

}

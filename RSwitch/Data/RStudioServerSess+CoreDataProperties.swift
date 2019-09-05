//
//  RStudioServerSess+CoreDataProperties.swift
//  
//
//  Created by hrbrmstr on 9/5/19.
//
//

import Foundation
import CoreData


extension RStudioServerSess {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RStudioServerSess> {
        return NSFetchRequest<RStudioServerSess>(entityName: "RStudioServerSess")
    }

    @NSManaged public var menuTitle: String?
    @NSManaged public var url: String?

}

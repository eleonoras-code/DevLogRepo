//
//  WinModel.swift
//  commit
//
//  Created by Eleonora Persico on 06/11/25.
//

import Foundation
import SwiftData

@Model //conforms to Identifiable, makes it Observable and Persistent > blueprint of the objects stored in the database
class Win {
    var title: String //each property > column in the database
    var text: String
    var date: Date
    var tag: Tag?
    var imageData: Data?


    init(title: String = "" , text: String = "" , date: Date = .now, tag: Tag? = nil, imageData: Data? = nil) {
        self.title = title
        self.text = text
        self.date = date
        self.tag = tag
        self.imageData = imageData
    }
}


@Model
class Tag {
    @Attribute(.unique) var title: String
    var accessibleRepresentation: String
    
    @Relationship(inverse: \Win.tag) var wins: [Win] = []   // links between models > ONE TO MANY 
    
    init(title: String, accessibleRepresentation: String = "") {
        self.title = title
        self.accessibleRepresentation = accessibleRepresentation
    }
}

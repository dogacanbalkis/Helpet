//
//  anasayfaCell.swift
//  hel_pet
//
//  Created by Doğa Balkış on 26.11.2020.
//


import Foundation
import Firebase

struct Post {
    
    // MARK: Properties
    var id: String = ""
    var createdAt = Date()
    
    var ownerEmail: String
    var comment: String
    var imageURL: String
    var location: GeoPoint
    var helped: Bool = false
    
    // MARK: - Life Cycle
    init(ownerEmail: String, comment: String, imageURL: String = "", location: GeoPoint, helped: Bool) {
        self.ownerEmail = ownerEmail
        self.comment = comment
        self.imageURL = imageURL
        self.location = location
        self.helped = helped
    }
    
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String, 
              let createdAt = dictionary["createdAt"] as? Timestamp,
              let ownerEmail = dictionary["ownerEmail"] as? String,
              let comment = dictionary["comment"] as? String,
              let imageURL = dictionary["imageURL"] as? String,
              let location = dictionary["location"] as? GeoPoint,
              let helped = dictionary["helped"] as? Bool else {
            return nil
        }
        
        self.id = id
        self.createdAt = createdAt.dateValue()
        self.ownerEmail = ownerEmail
        self.comment = comment
        self.imageURL = imageURL
        self.location = location
        self.helped = helped
    }
    
    // MARK: - Functions
    func toDictionary() -> [String : Any] {
        return ["imageURL": imageURL, "ownerEmail": ownerEmail, "comment": comment, "location": location, "createdAt": createdAt, "helped" : helped]
    }
}

//
//  Exercise.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/10/20.
//

import SwiftUI
import Firebase

class Exercise: Identifiable {
    var id: String = ""
    
    var image: UIImage?
//        = UIImage(systemName: "rectangle.and.paperclip")!
    var imageLocation: String?
    var name: String = ""
    var reference: DocumentReference {
        return FBManager.shared.database.collection("exercise").document(id)
    }
    var type: ExerciseType = .duration
    
    init(snapshot: DocumentSnapshot) {
        self.id = snapshot.documentID
        self.process(snapshot.data()!)
    }
    
    private func process(_ dict: [String : Any]) {
        self.imageLocation = dict[Key.imageLocation.rawValue] as? String
        self.name = dict[Key.name.rawValue] as! String
        self.type = ExerciseType(rawValue: dict[Key.type.rawValue] as! String)!
    }
    
    func image(_ completion: @escaping (UIImage?, Error?) -> Void) {
        if let image = image {
            completion(image, nil)
        } else {
            // TODO: get image from storage
        }
    }
}

extension Exercise: Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Exercise {
    enum ExerciseType: String, Codable {
        case duration
        case weighted
    }
}

extension Exercise {
    enum Key: String {
        case id
        case imageLocation
        case name
        case type
    }
}

extension Array where Element == Exercise {
    func exercise(forReference ref: DocumentReference) -> Exercise {
        return self.first(where: { $0.reference == ref })!
    }
}

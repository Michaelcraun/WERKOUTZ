//
//  Exercise.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/10/20.
//

import SwiftUI
import Firebase

class Exercise: Identifiable {
    var id: String?
    
    var image: UIImage? {
        didSet {
            print("Exercise - \(#function) for id: \(id ?? "nil")", image?.description ?? "nil")
        }
    }
    var name: String = ""
    var type: ExerciseType = .duration
    
    private var dict: [String : Any] {
        return [
            "name" : name,
            "type" : type.rawValue]
    }
    private var storageReference: StorageReference {
        let reference = FBManager.shared.storage.reference(withPath: "exercise").child("\(id!).jpeg")
        print("Exercise - \(#function)", reference.fullPath)
        return reference
    }
    var reference: DocumentReference {
        let collection = FBManager.shared.database.collection("exercise")
        return id == nil ? collection.document() : collection.document(id!)
    }
    
    init(snapshot: DocumentSnapshot) {
        self.id = snapshot.documentID
        self.process(snapshot.data()!)
        self.getImage()
    }
    
    init(_ name: String, image: UIImage?, type: ExerciseType) {
        self.id = UUID().uuidString
        self.image = image
        self.name = name
        self.type = type
    }
    
    private func getImage() {
        if image == nil {
            let maxSize = Int64(5 * 1024 * 1024)
            storageReference.getData(maxSize: maxSize) { (data, error) in
                if let error = error {
                    if error.localizedDescription.contains("does not exist") {
                        FBManager.shared.storage.reference(withPath: "exercise").child("default.jpeg").getData(maxSize: maxSize) { (data, _) in
                            self.image = UIImage(data: data!)
                        }
                    } else {
                        print("Exercise - \(#function) encountered an error:", error.localizedDescription)
                    }
                } else if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
    
    private func process(_ dict: [String : Any]) {
        self.name = dict[Key.name.rawValue] as! String
        self.type = ExerciseType(rawValue: dict[Key.type.rawValue] as! String)!
    }
    
    private func putImage(_ completion: @escaping (Error?) -> Void) {
        if let image = image, let data = image.jpegData(compressionQuality: 0.5) {
            storageReference.putData(data, metadata: nil) { (_, error) in
                completion(error)
            }
        } else {
            completion(nil)
        }
    }
    
    func put(_ completion: @escaping (Error?) -> Void) {
        putImage { (error) in
            if let error = error {
                completion(error)
            } else {
                self.reference.setData(self.dict) { (error) in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
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

//
//  User.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 9/12/20.
//

import SwiftUI
import Firebase

class User: ObservableObject {
    private var dict: [String : Any] {
        return ["exercises" : exercises.map({ $0.reference })]
    }
    
    @Published var exercises: [Exercise] = []
    var id: String = ""
    var reference: DocumentReference {
        return FBManager.shared.database.collection("user").document(id)
    }
    
    init() {  }
    
    init(user: Firebase.User) {
        self.id = user.uid
    }
    
    private func process(_ snapshot: DocumentSnapshot) {
        if let data = snapshot.data(), let exercises = data["exercises"] as? [DocumentReference] {
            self.exercises = exercises.compactMap({ FBManager.shared.exercises.exercise(forReference: $0) })
        }
    }
    
    private func update(_ completion: ((Error?) -> Void)? = nil) {
        reference.setData(dict, merge: true) { (error) in
            completion?(error)
        }
    }
    
    func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
        update()
    }
    
    func addListener() {
        reference.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("User - \(#function) encountered an error:", error.localizedDescription)
            } else if let snapshot = snapshot {
                print("User - \(#function) user was updated.")
                self.process(snapshot)
            }
        }
    }
    
    func removeExercise(_ exercise: Exercise) {
        exercises = exercises.filter({ $0.reference != exercise.reference })
        update()
        
        let records = FBManager.shared.records.records(forExercise: exercise)
        records.forEach({ $0.reference.delete() })
    }
}

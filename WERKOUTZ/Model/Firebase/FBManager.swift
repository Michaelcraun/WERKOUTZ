//
//  FBManager.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/30/20.
//

import Foundation
import Firebase

class FBManager {
    static let shared = FBManager()
    
    private var exerciseQuery: Query {
        database.collection("exercise")
    }
    private var recordQuery: Query {
        database.collection("record")
            .whereField("user", isEqualTo: user?.uid as Any)
    }
    
    let database = Firestore.firestore()
    var exercises: [Exercise] = []
    var records: [Record] = []
    var user: User?
    
    func checkAuth(_ completion: ((Error?) -> Void)? = nil) {
        if let user = Auth.auth().currentUser {
            print("FBManager - \(#function) user is signed in")
            self.user = user
            completion?(nil)
        } else {
            Auth.auth().signInAnonymously { (result, error) in
                print("FBManager - \(#function) signing in anonymously...")
                if let error = error {
                    print("FBManager - \(#function) encountered an error:", error.localizedDescription)
                    completion?(error)
                } else if let result = result {
                    self.user = result.user
                    completion?(nil)
                }
            }
        }
    }
    
    func addExerciseListener(_ completion: (([Exercise]?, Error?) -> Void)? = nil) {
        exerciseQuery.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("FBManager - \(#function) encountered an error:", error.localizedDescription)
                completion?(nil, error)
            } else if let snapshot = snapshot {
                for document in snapshot.documents {
                    let exercise = Exercise(snapshot: document)
                    if !self.exercises.contains(exercise) {
                        self.exercises.append(exercise)
                    }
                }
                completion?(self.exercises, nil)
            }
        }
    }
    
    func addRecordListener(_ completion: (([Record]?, Error?) -> Void)? = nil) {
        recordQuery.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("FBManager - \(#function) encountered an error:", error.localizedDescription)
                completion?(nil, error)
            } else if let snapshot = snapshot {
                for document in snapshot.documents {
                    let record = Record(snapshot: document)
                    if !self.records.contains(record) {
                        self.records.append(record)
                    }
                }
                completion?(self.records, nil)
            }
        }
    }
}

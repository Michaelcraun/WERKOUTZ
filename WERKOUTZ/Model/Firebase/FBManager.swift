//
//  FBManager.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/30/20.
//

import SwiftUI
import Firebase

class FBManager: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var records: [Record] = []
    @Published var searchedExercisees: [Exercise]?
    @Published var user: User = User()
    
    static let shared = FBManager()
    
    private var exerciseQuery: Query {
        database.collection("exercise")
    }
    private var recordQuery: Query {
        database.collection("record")
            .whereField("user", isEqualTo: user.reference as Any)
    }
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    func checkAuth(_ completion: ((Error?) -> Void)? = nil) {
        if let user = Auth.auth().currentUser {
            print("FBManager - \(#function) user is signed in")
            self.user = User(user: user)
            completion?(nil)
        } else {
            Auth.auth().signInAnonymously { (result, error) in
                print("FBManager - \(#function) signing in anonymously...")
                if let error = error {
                    print("FBManager - \(#function) encountered an error:", error.localizedDescription)
                    completion?(error)
                } else if let result = result {
                    self.user = User(user: result.user)
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
                DispatchQueue.main.async {
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
    }
    
    func addRecordListener(_ completion: (([Record]?, Error?) -> Void)? = nil) {
        recordQuery.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("FBManager - \(#function) encountered an error:", error.localizedDescription)
                completion?(nil, error)
            } else if let snapshot = snapshot {
                DispatchQueue.main.async {
                    snapshot.documentChanges.forEach { (change) in
                        let record = Record(snapshot: change.document)
                        switch change.type {
                        case .added:
                            if !self.records.contains(record) {
                                self.records.append(record)
                            }
                        case .modified:
                            if !self.records.contains(record) {
                                self.records.append(record)
                            }
                        case .removed:
                            if let index = self.records.firstIndex(of: record) {
                                self.records.remove(at: index)
                            }
                        }
                    }
                    completion?(self.records, nil)
                }
            }
        }
    }
    
    func searchExercises(_ searchText: String) {
        searchedExercisees = exercises.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
    }
}

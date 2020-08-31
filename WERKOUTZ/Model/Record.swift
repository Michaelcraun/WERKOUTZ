//
//  Record.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/10/20.
//

import Foundation
import Firebase

class Record: Identifiable {
    var id: String = ""
    
    var date: Date = Date()
    var duration: String?
    var exerciseRef: DocumentReference!
    var reps: Int?
    var weight: Double?
    
    var description: String {
        switch exercise.type {
        case .duration: return duration!.userRepresentableTime
        case .weighted: return "\(reps!) reps @ \(weight!) lbs"
        }
    }
    var exercise: Exercise {
        return FBManager.shared.exercises.exercise(forReference: exerciseRef)
    }
    var reference: DocumentReference {
        return FBManager.shared.database.collection("record").document(id)
    }
    var weightedTotal: Double? {
        if let reps = reps, let weight = weight {
            return Double(reps) * weight
        }
        return nil
    }
    
    init(snapshot: DocumentSnapshot) {
        self.id = snapshot.documentID
        self.process(snapshot.data()!)
    }
    
    init(exercise: Exercise, duration: String? = nil, reps: Int? = nil, weight: Double? = nil) {
        self.exerciseRef = exercise.reference
        self.duration = duration
        self.reps = reps
        self.weight = weight
    }
    
    func process(_ dict: [String : Any]) {
        self.date = (dict[Key.date.rawValue] as! Timestamp).dateValue()
        self.duration = dict[Key.duration.rawValue] as? String
        self.exerciseRef = dict[Key.exercise.rawValue] as? DocumentReference
        self.reps = dict[Key.reps.rawValue] as? Int
        self.weight = dict[Key.weight.rawValue] as? Double
    }
    
    func set(_ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
}

extension Record {
    enum Key: String {
        case date
        case duration
        case exercise
        case reps
        case weight
    }
}

extension Record: Equatable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Array where Element == Record {
    func best() -> Record {
        let exercise = self.first!.exercise
        switch exercise.type {
        case .duration: return self.sorted(by: { $0.duration! >= $1.duration! }).first!
        case .weighted: return self.sorted(by: { $0.weightedTotal! >= $1.weightedTotal! }).first!
        }
    }
    
    func records(forExercise exercise: Exercise) -> [Record] {
        self.filter({ $0.exercise == exercise })
    }
}

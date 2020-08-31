//
//  EntryCell.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/13/20.
//

import SwiftUI

struct EntryCell: View {
    let type: Exercise.ExerciseType
    @Binding var duration: String
    @Binding var reps: String
    @Binding var weight: String
    
    var body: some View {
        HStack {
            switch type {
            case .duration:
                DurationPicker(duration: $duration)
            case .weighted:
                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
                TextField("Weight", text: $weight)
                    .keyboardType(.numberPad)
            }
        }.padding(.all, 5)
    }
    
    init(_ type: Exercise.ExerciseType, duration: Binding<String>, reps: Binding<String>, weight: Binding<String>) {
        self._duration = duration
        self._reps = reps
        self._weight = weight
        self.type = type
    }
}

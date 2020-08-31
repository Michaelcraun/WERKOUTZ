//
//  ExerciseSearchField.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/13/20.
//

import SwiftUI

struct ExerciseSearchField: View {
    @State private var searchText: String = ""
    @State private var exercises: [Exercise] = [
        // MARK: Temporary
//        Exercise(name: "Elipitical", type: .duration),
//        Exercise(name: "Leg Press", type: .weighted),
//        Exercise(name: "Overhead Press", type: .weighted)
    ]
    
    var body: some View {
        VStack {
            TextField("Exercise Name", text: $searchText)
                .onChange(of: searchText, perform: { _ in search() })
            VStack {
                ForEach(exercises) { exercise in
                    ExerciseCell(exercise: exercise, records: [])
                        .onTapGesture { select(exercise) }
                }
            }
        }.padding(.all, 5)
    }
}

extension ExerciseSearchField {
    private func search() {
        // MARK: Temporary
        exercises = exercises.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
    }
    
    private func select(_ exercise: Exercise) {
        searchText = exercise.name
    }
}

struct ExerciseSearchField_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSearchField()
    }
}

//
//  ExerciseCell.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/11/20.
//

import SwiftUI

struct ExerciseCell: View {
    let exercise: Exercise
    let records: [Record]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(exercise.name)
                    .bold()
                    .font(.headline)
                Spacer()
            }.padding(.leading, 5)
            HStack {
                Text(records.count == 0 ? "" : "Best: \(records.best().description)")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            }.padding(.leading, 5)
//            Text("Targeted Area: ???")
//                .font(.caption)
//                .foregroundColor(.gray)
//                .italic()
        }.padding(.trailing)
    }
}

//struct ExerciseCell_Previews: PreviewProvider {
//    static var previews: some View {
//        let legPress = Exercise(name: "Leg Press", type: .weighted)
//        ExerciseCell(
//            exercise: legPress,
//            records: [
//                Record(exercise: legPress, reps: 5, weight: 100),
//                Record(exercise: legPress, reps: 2, weight: 225),
//                Record(exercise: legPress, reps: 10, weight: 200),
//                Record(exercise: legPress, reps: 8, weight: 250)
//            ])
//    }
//}

//
//  HistoryCell.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/11/20.
//

import SwiftUI

struct HistoryCell: View {
    @State private var actionSheetIsPresented: Bool = false
    let record: Record
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                Text(record.description)
                    .font(.headline)
                Text(record.date.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }.padding(2)
        }.actionSheet(isPresented: $actionSheetIsPresented, content: {
            ActionSheet(
                title: Text(""),
                message: Text("What would you like to do?"),
                buttons: [
                    ActionSheet.Button.default(Text("Edit"), action: { handleEdit(record: record) }),
                    ActionSheet.Button.destructive(Text("Delete"), action: { handleDelete(record: record) }),
                    ActionSheet.Button.cancel()
                ])
        })
        .onTapGesture(perform: { actionSheetIsPresented = !actionSheetIsPresented })
    }
}

extension HistoryCell {
    private func handleDelete(record: Record) {
        
    }
    
    private func handleEdit(record: Record) {
        
    }
}

//struct HistoryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        let legPress = Exercise(name: "Leg Press", type: .weighted)
//        HistoryCell(record: Record(exercise: legPress, reps: 5, weight: 100))
//            .frame(width: 400, height: 100, alignment: .leading)
//    }
//}

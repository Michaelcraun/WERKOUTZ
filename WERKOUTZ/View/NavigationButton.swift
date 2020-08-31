//
//  NavigationButton.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/13/20.
//

import SwiftUI

struct NavigationButton: View {
    var action: () -> Void
    var image: String
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: image)
                .font(.title)
        })
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(action: {  }, image: "checkmark")
    }
}

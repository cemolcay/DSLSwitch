//
//  DSLButton.swift
//  DSLSwitch
//
//  Created by Cem Olcay on 6/18/22.
//

import SwiftUI

struct DSLButton: View {
    var title: String
    var action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundColor(.primary)
        })
    }
}

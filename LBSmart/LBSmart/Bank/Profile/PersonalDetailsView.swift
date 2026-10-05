//
//  PersonalDetailsView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct PersonalDetailsView: View {
    @StateObject private var viewModel: PersonalDetailsViewModel

    init(viewModel: PersonalDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            LabeledContent("Name", value: viewModel.name)
            LabeledContent("Email", value: viewModel.email)
            Button("Back", action: viewModel.close)
        }
        .navigationTitle("Personal details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

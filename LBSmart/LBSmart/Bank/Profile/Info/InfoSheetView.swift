//
//  InfoSheetView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

struct InfoSheetView: View {
    @StateObject private var viewModel: InfoSheetViewModel

    init(viewModel: InfoSheetViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.usesDynamicHeight {
                sheetContent.dynamicSheetSize()
            } else {
                ScrollView { sheetContent }
                    .presentationDetents([.medium, .large])
            }
        }
        .presentationDragIndicator(.visible)
    }

    private var sheetContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            Image(systemName: "info.circle.fill").font(.largeTitle).foregroundStyle(.teal)
            Text(viewModel.info.title).font(.title.bold())
            Text(viewModel.info.message).foregroundStyle(.secondary)
            if viewModel.usesDynamicHeight {
                Button(viewModel.isExpanded ? "Show less" : "Learn more", action: viewModel.toggleDetails)
                if viewModel.isExpanded {
                    Text(viewModel.additionalInformation).foregroundStyle(.secondary)
                }
            }
            Button("Done", action: viewModel.close)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(28)
    }
}

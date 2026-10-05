//
//  ProfileView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct ProfileDetailsView: View {
    @StateObject private var viewModel: ProfileDetailsViewModel

    init(viewModel: ProfileDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 48)).foregroundStyle(.teal)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.displayName).font(.headline)
                        Text("LB SMART member").foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 12)
                Button("Personal details", action: viewModel.showPersonalDetails)
            }
            Section("Information") {
                ForEach(viewModel.infoLinks, id: \.self) { info in
                    Button {
                        viewModel.showInfo(info)
                    } label: {
                        HStack {
                            Text(info.title)
                            Spacer()
                            Image(systemName: "info.circle")
                        }
                    }
                }
            }
            Section {
                Button("Sign out", role: .destructive, action: viewModel.signOut)
                    .accessibilityIdentifier("bank.signOut")
            }
        }
        .navigationTitle("Profile")
    }
}

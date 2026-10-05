//
//  LoginView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            Image(systemName: "building.columns.fill")
                .font(.system(size: 56))
                .foregroundStyle(.teal)
            Text("Welcome to\nLB SMART")
                .font(.largeTitle.bold())
            Text("Your money, in one place.")
                .foregroundStyle(.secondary)
            Spacer()
            Button(action: viewModel.signIn) {
                Text("Sign in to demo")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("bank.signIn")
            Button("Contact us", action: viewModel.showContactUs)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier("bank.contactUs")
            Text("Sample accounts and cards. No credentials required.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(28)
    }
}

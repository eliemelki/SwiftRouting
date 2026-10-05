import Combine
import Foundation

/// One model created by Details and passed by reference through the transfer flow.
@MainActor
final class TransferDraft: ObservableObject, Hashable {
    @Published var sourceAccount = BankAccount.samples[0]
    @Published var recipient = ""
    @Published var amountText = ""
    @Published var reference = ""
    @Published var receipt: TransferReceipt?

    nonisolated static func == (lhs: TransferDraft, rhs: TransferDraft) -> Bool {
        lhs === rhs
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

}

struct TransferReceipt: Hashable, Sendable {
    let id: UUID
    let sourceAccount: BankAccount
    let recipient: String
    let amount: Decimal
    let reference: String
}

import Foundation

/// Shared form logic composed by independent screen ViewModels.
@MainActor
struct TransferDraftEditor {
    let draft: TransferDraft

    var amount: Decimal? {
        let text = draft.amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.range(of: #"^[0-9]+(?:\.[0-9]{1,2})?$"#, options: .regularExpression) != nil else {
            return nil
        }
        return Decimal(string: text, locale: Locale(identifier: "en_US_POSIX"))
    }

    var validationMessage: String? {
        guard !draft.recipient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Enter a recipient name."
        }
        guard let amount, amount > 0 else {
            return "Enter an amount greater than zero with up to two decimal places."
        }
        guard amount <= Decimal(draft.sourceAccount.balance) else {
            return "The amount exceeds the available balance."
        }
        return nil
    }

    init(draft: TransferDraft) {
        self.draft = draft

    }

    func resetDraft() {
        draft.sourceAccount = BankAccount.samples[0]
        draft.recipient = ""
        draft.amountText = ""
        draft.reference = ""
        draft.receipt = nil
    }
}

//
//  ContentView.swift
//  CustomFileSample
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/07/24.
//

import SwiftUI
import CryptoKit

struct ContentView: View {
	/// View Properties
	@State private var transactions: [Transaction] = []
	@State private var importTransactions: Bool = false
	
	var body: some View {
		NavigationStack {
			List(transactions) { transaction in
				HStack(spacing: 10) {
					VStack(alignment: .leading, spacing: 6) {
						Text(transaction.title)
						
						Text(transaction.date.formatted(date: .numeric, time: .shortened))
							.font(.caption)
							.foregroundStyle(.gray)
					}
					
					Spacer(minLength: 0)
					
					Text("$\(Int(transaction.amount))")
						.font(.callout.bold())
					
					
				}
			}
			.navigationTitle("Transactions")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("", systemImage: "square.and.arrow.down.fill") {
						importTransactions.toggle()
					}
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button("", systemImage: "plus") {
						// Adding dummy items
						transactions.append(.init())
					}
				}
				
				ToolbarItem(placement: .topBarLeading) {
					// Share link
					ShareLink(item: Transactions(transactions: transactions), preview: SharePreview("Share", image: "square.and.arrow.up.fill"))
				}
			}
		}
		.fileImporter(isPresented: $importTransactions, allowedContentTypes: [.trnExportType]) { result in
			switch result {
			case .success(let URL):
				do {
					let encryptedData = try Data(contentsOf: URL)
					// Decrypting Data
					let decryptedData = try AES.GCM.open(.init(combined: encryptedData), using: .trnKey)
					// Decoding Data
					let decodedTransactions = try JSONDecoder().decode(Transactions.self, from: decryptedData)
					// Adding Transactions
					self.transactions = decodedTransactions.transactions
				} catch {
					print(error.localizedDescription)
				}
			case .failure(let failure):
				print(failure.localizedDescription)
			}
		}
	}
}

#Preview {
	ContentView()
}

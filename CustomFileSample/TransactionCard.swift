//
//  TransactionCard.swift
//  CustomFileSample
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/07/24.
//

import Foundation
import SwiftUI

struct TransactionCard: View {
	let transaction: Transaction
	
	var body: some View {
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
}

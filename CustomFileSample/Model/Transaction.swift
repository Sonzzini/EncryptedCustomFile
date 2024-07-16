//
//  Transaction.swift
//  CustomFileSample
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/07/24.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers
import CryptoKit

struct Transaction: Identifiable, Codable {
	var id: UUID = .init()
	var title: String
	var date: Date
	var amount: Double
	
	/// FOR EXAMPLE PURPOSE
	init() {
		self.title = "Sample text"
		self.amount = .random(in: 5000...10000)
		let calendar = Calendar.current
		self.date = calendar.date(byAdding: .day, value: .random(in: 1...100), to: .now) ?? .now
	}
}

struct Transactions: Codable, Transferable {
	var transactions: [Transaction]
	static var transferRepresentation: some TransferRepresentation {
		DataRepresentation(exportedContentType: .trnExportType) {
			let data = try JSONEncoder().encode($0)
			guard let encryptedData = try AES.GCM.seal(data, using: .trnKey).combined else {
				throw EncryptionError.failed
			}
			return encryptedData
		}
		.suggestedFileName("Micher")
	}
	
	enum EncryptionError: Error {
		case failed
	}
}

extension SymmetricKey {
	static var trnKey: SymmetricKey {
		let key = "Dondos".data(using: .utf8)!
		let sha256 = SHA256.hash(data: key)
		
		return .init(data: sha256)
	}
}

extension UTType {
	static var trnExportType = UTType(exportedAs: "PauloSonzzini.CustomFileSample.trn")
}

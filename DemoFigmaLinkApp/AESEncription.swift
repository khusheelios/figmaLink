//
//  AESEncription.swift
//  DemoColorCodeApp
//
//  Created by CG App Mac on 07/04/22.
//

import Foundation
import CommonCrypto
struct AES {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let ivValue: Data

    // MARK: - Initialzier
    init?(key: String? = AESEncryptionKey) {
        guard key?.count == kCCKeySizeAES128 || key?.count == kCCKeySizeAES256 || key?.count == kCCKeySizeAES192,
            let keyData = key?.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        self.key = keyData
        self.ivValue  = keyData
    }

    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }

    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }

        let cryptLength = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128).count
        var cryptData   = Data(count: cryptLength)

        let keyLength = [UInt8](repeating: 0, count: kCCBlockSizeAES128).count
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                ivValue.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes,
                                keyLength, ivBytes,
                                dataBytes, data.count, cryptBytes, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

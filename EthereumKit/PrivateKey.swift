//
//  privateKey.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/16.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation

public final class PrivateKey: Hashable, CustomStringConvertible {
    /// Validates that raw data is a valid private key.
    static public func isValid(data: Data) -> Bool {
        // Check length
        if data.count != 32 {
            return false
        }
        
        // Check for zero address
        guard data.contains(where: { $0 != 0 }) else {
            return false
        }
        
        return true
    }
    
    /// Raw representation of the private key.
    public private(set) var data: Data
    
    /// Creates a new private key.
    public init() {
        let privateAttributes: [String: Any] = [
            kSecAttrIsExtractable as String: true,
            ]
        let parameters: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String: 256,
            kSecPrivateKeyAttrs as String: privateAttributes,
            ]
        
        guard let privateKey = SecKeyCreateRandomKey(parameters as CFDictionary, nil) else {
            fatalError("Failed to generate key pair")
        }
        guard var keyRepresentation = SecKeyCopyExternalRepresentation(privateKey, nil) as Data? else {
            fatalError("Failed to extract new private key")
        }
        defer {
            keyRepresentation.clear()
        }
        data = Data(keyRepresentation.suffix(32))
    }
    
    public init?(data: Data) {
        if !PrivateKey.isValid(data: data) {
            return nil
        }
        self.data = Data(data)
    }
    
    deinit {
        data.clear()
    }
    
    public func publicKey() -> PublicKey {
        return PublicKey(data: Crypto.getPublicKey(from: data))!
    }
    
    public var description: String {
        return data.hexEncodedString()
    }
    
    public var hashValue: Int {
        return data.hashValue
    }
    
    public static func == (lhs: PrivateKey, rhs: PrivateKey) -> Bool {
        return lhs.data == rhs.data
    }
}

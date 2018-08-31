//
//  Address.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/16.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation

public enum AddressError: Error {
    case invalid
}

public struct Address {
    let raw: Data
    
    public init(_ data: Any) throws {
        if let raw = data as? Data {
            self.raw = raw
        } else if let hex = data as? String {
            self.raw = Data(hex: hex)
        } else {
            throw AddressError.invalid
        }
    }
}

extension Address: CustomStringConvertible {
    public var description: String {
        return Address.computeEIP55String(for: self.raw)
    }
}

extension Address {
    /// Converts the address to an EIP55 checksumed representation.
    fileprivate static func computeEIP55String(for data: Data) -> String {
        let addressString = data.toHexString()
        let hashInput = addressString.data(using: .ascii)!
        let hash = Crypto.hash(hashInput).toHexString()
        
        var string = "0x"
        for (a, h) in zip(addressString, hash) {
            switch (a, h) {
            case ("0", _), ("1", _), ("2", _), ("3", _), ("4", _), ("5", _), ("6", _), ("7", _), ("8", _), ("9", _):
                string.append(a)
            case (_, "8"), (_, "9"), (_, "a"), (_, "b"), (_, "c"), (_, "d"), (_, "e"), (_, "f"):
                string.append(contentsOf: String(a).uppercased())
            default:
                string.append(contentsOf: String(a).lowercased())
            }
        }
        
        return string
    }
}

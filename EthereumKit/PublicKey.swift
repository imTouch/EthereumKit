
//
//  publicKey.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/16.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation

public class PublicKey {
    static public func isValid(data: Data) -> Bool {
        if data.count != 65 {
            return false
        }
        return data[0] == 4
    }
    
    public let data: Data
    
    public var address: Address {
        let hash = Crypto.hash(data[1...])
        return try! Address(hash.suffix(20))
    }
    
    public init?(data: Data) {
        if !PublicKey.isValid(data: data) {
            return nil
        }
        self.data = data
    }
    
    public var description: String {
        return data.hexEncodedString()
    }
}

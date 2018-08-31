//
//  Signature.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/16.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation
import CryptoSwift

public struct Signature {
    public let v: Data
    public let r: Data
    public let s: Data
    
    public init(_ hash: Data, privateKey: Data) throws {
        let sig = Crypto.sign(hash: hash, privateKey: privateKey);
        self.v = Data(hex: String(format:"%02X", sig[64] + 27))
        self.r = sig[0..<32]
        self.s = sig[32..<64]
    }
    
    public init(_ sig: Data) throws {
        self.v = Data(hex: String(format:"%02X", sig[64] + 27))
        self.r = sig[0..<32]
        self.s = sig[32..<64]
    }
}

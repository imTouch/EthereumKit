//
//  Transaction.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/31.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation

/*
 * @property {Data} raw The raw rlp encoded transaction
 * @param {Data} data.nonce nonce number
 * @param {Data} data.gasLimit transaction gas limit
 * @param {Data} data.gasPrice transaction gas price
 * @param {Data} data.to to the to address
 * @param {Data} data.value the amount of ether sent
 * @param {Data} data.data this will contain the data of the message or the init of a contract
 * @param {Data} data.v EC recovery ID
 * @param {Data} data.r EC signature parameter
 * @param {Data} data.s EC signature parameter
 * @param {Data} data.chainId EIP 155 chainId - mainnet: 1, ropsten: 3
 * */
public struct Transaction {
    public let raw: Data
    
    var nonce: Data { return try! RLP.decode(raw)[0] }
    var gasLimit: Data { return try! RLP.decode(raw)[1] }
    var gasPrice: Data { return try! RLP.decode(raw)[2] }
    var to: Data { return try! RLP.decode(raw)[3] }
    var value: Data { return try! RLP.decode(raw)[4] }
    var data: Data { return try! RLP.decode(raw)[5] }
    var v: Data { return try! RLP.decode(raw)[6] }
    var r: Data { return try! RLP.decode(raw)[7] }
    var s: Data { return try! RLP.decode(raw)[8] }
    
    public init(_ data: [Data], privateKey: Data) throws {
        let txHash = RLP.encode(data).sha3(.keccak256)
        
        let sig = try Signature(txHash, privateKey: privateKey)
        
        self.raw = RLP.encode(data + [sig.v, sig.r, sig.s])
    }
    
    public init(_ serialized: Data, privateKey: Data) throws {
        var decoded = try RLP.decode(serialized)
        decoded = Array(decoded[0..<6])
        
        let txHash = RLP.encode(decoded).sha3(.keccak256)
        
        let sig = try Signature(txHash, privateKey: privateKey)
        
        decoded.append(sig.v);
        decoded.append(sig.r)
        decoded.append(sig.s);
        
        self.raw = RLP.encode(decoded)
    }
    
    public func isValid(addressTo: String, amount: Decimal) -> Bool {
        if (Data(hex: addressTo) == to) {
            return amount == Decimal(self.value.toHexString(), base: 16)
        }
        
        let regex = try! NSRegularExpression(pattern: "^a9059cbb000000000000000000000000[a-fA-F0-9]{40}[a-fA-F0-9]{64}$", options: .caseInsensitive)
        
        let input = self.data.toHexString()
        let isMatch = regex.numberOfMatches(in: input, options: [], range: NSRange(location: 0, length: input.count)) > 0
        if (isMatch) {
            let toStartIndex = input.index(input.startIndex, offsetBy: 32)
            let toEndIndex = input.index(toStartIndex, offsetBy: 39)
            let tokenTo = Data(hex: String(input[toStartIndex...toEndIndex]))
            
            let tokenAmount = Decimal(String(input[toEndIndex...]), base: 16)
            
            return tokenTo == Data(hex: addressTo) && tokenAmount == amount
        }
        return false
    }
}

public extension Decimal {
    init(_ string: String, base: Int) {
        var decimal: Decimal = 0
        
        let digits = string
            .map { String($0) }
            .map { Int($0, radix: base)! }
        
        for digit in digits {
            decimal *= Decimal(base)
            decimal += Decimal(digit)
        }
        
        self.init(string: decimal.description)!
    }
}

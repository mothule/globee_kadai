//
//  String+Extension.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension String {
    var toURL: URL? { URL(string: self) }
    var isAny: Bool { isEmpty == false }
    var hasMultiByteString: Bool { self.canBeConverted(to: .ascii) == false }
    var toDouble: Double? { Double(self) }
    
    func truncating(length: Int, trailing: String = "…") -> String {
        guard length < count else { return self }
        let range = startIndex..<index(startIndex, offsetBy: length)
        return self[range] + trailing
    }
}

extension Optional where Wrapped == String {
    var orEmpty: Wrapped { self ?? "" }
}

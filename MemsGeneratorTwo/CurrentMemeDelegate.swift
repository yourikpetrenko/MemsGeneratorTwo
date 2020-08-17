//
//  ProtocolCurrentMeme.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 07.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

// MARK: - Protocol for delegate, at transporting data

protocol CurrentMemeDelegate: class {
    func transmittingIdMeme(identifierName: String)
}

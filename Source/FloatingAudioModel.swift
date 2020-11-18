//
//  FloatingAudioModel.swift
//  FloatingAudioPlayer
//
//  Created by Zhangali Pernebayev on 11/17/20.
//

import Foundation

public struct FloatingAudioModel {
    public let name: String
    public let author: String?
    public let imageURL: String?
    public let audioProgress: Float
    
    public init(name: String, author: String?, imageURL: String?, audioProgress: Float) {
        self.name = name
        self.author = author
        self.imageURL = imageURL
        self.audioProgress = audioProgress
    }
}

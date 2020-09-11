//
//  Imgur.swift
//  Imgur
//
//  Created by Marcio Izar Bastos de Oliveira on 08/09/20.
//  Copyright © 2020 Marcio Izar Bastos de Oliveira. All rights reserved.
//

import Foundation

struct Imgur: Codable {
    var success: Bool
    var status: Int
    var data: [data]
    
    init() {
        self.status = 0
        self.success = false
        self.data = []
    }
    
    struct data: Codable {
        var type: String?
        var link: String?
        var gifv: String?
        var ups: Int?
        var downs: Int?
        var points: Int?
        var comment_count: Int?
        var views: Int?
        var images: [image]?
        
        struct image: Codable {
            var id: String?
            var type: String?
            var link: String?
            var gifv: String?
            
        }
        
    }
}

struct ImgurError: Codable {
    struct data: Codable {
        var error: String?
        var request: String?
        var method: String?
    }
    var success: Bool
    var status: Int
    var data: data
}

//
//  Post.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation

struct Post {
    var kind: String
    var date: Date
    var content: PostContent
    var metadata: Metadata
}

extension Post {
    struct PostContent {
        var images: [Image]
        var body: String
    }
    
    struct Image {
        // define a reusable Image type for posts here.
    }
    
    struct Metadata {
        // define reusable Metadata for posts here.
    }
}

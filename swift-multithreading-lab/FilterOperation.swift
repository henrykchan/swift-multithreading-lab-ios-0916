//
//  FilterOperation.swift
//  swift-multithreading-lab
//
//  Created by Henry Chan on 11/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class FilterOperation: Operation {
    
    var flatigram: Flatigram
    var filter: String
    
    init (flatigram: Flatigram, filter: String) {
    
    self.flatigram = flatigram
    self.filter = filter
    }
    
    
    override func main() {
        
        if let filteredImage = self.flatigram.image?.filter(with: filter) {
            self.flatigram.image = filteredImage
        }
    }
}

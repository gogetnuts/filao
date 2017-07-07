//
//  LayerClass.swift
//  Filao
//
//  Created by Ben on 03/07/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import SpriteKit

class Layer : SKNode {
    var grid:Grid?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

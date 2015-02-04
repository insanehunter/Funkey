//
//  FunkeyTests.swift
//  FunkeyTests
//
//  Created by Сергей Черепанов on 04.02.15.
//  Copyright (c) 2015 Kotiki. All rights reserved.
//

import UIKit
import XCTest
import Funkey

class FunkeyTests: XCTestCase {
    func testPerformanceExample() {
        var diffs = [ArrayDifferenceOperation<TableViewCellState>]()
        
        self.measureMetrics(self.dynamicType.defaultPerformanceMetrics(), automaticallyStartMeasuring:false) {
            srand(123123)
            let N = 1
            let states = map(0...N) { _ in randomViewControllerState(minCount: 100, maxCount: 200) }
            
            self.startMeasuring()
            for i in 0..<N {
                let oldState = states[i]
                let newState = states[i]
                let diff = differenceBetween(oldArray: oldState.cells, andNewArray: newState.cells)
                diffs.extend(diff)
            }
            self.stopMeasuring()
        }
        print(diffs.count)
    }
}

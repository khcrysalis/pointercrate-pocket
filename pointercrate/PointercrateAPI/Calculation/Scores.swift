//
//  Scores.swift
//  pointercrate
//
//  Created by samara on 4/6/24.
//

import Foundation

public func score(progress: Int16, position: Double, requirement: Int16) -> String {
	var beatenScore: Double = 0.0
	
	if 55 < position && position <= 150 {
		let b: Double = 6.273
		let exponent = (54.147 - (position + 3.2)) * ((log(50.0)) / 99.0)
		beatenScore = 56.191 * pow(2, exponent)
		beatenScore += b
	} else if 35 < position && position <= 55 {
		let g: Double = 1.036
		let h: Double = 25.071
		beatenScore = 212.61 * pow(g, (1 - position)) + h
	} else if 20 < position && position <= 35 {
		let c: Double = 1.0099685
		let d: Double = 31.152
		beatenScore = (250 - 83.389) * pow(c, (2 - position)) - d
	} else if 0 < position && position <= 20 {
		let e: Double = 1.168
		let f: Double = 100.39
		beatenScore = (250 - f) * pow(e, (1 - position)) + f
	} else {
		beatenScore = 0
	}
	
	if progress != 100 {
		let score = (beatenScore * pow(5, (Double(progress) - Double(requirement)) / (100 - Double(requirement)))) / 10
		return String(format: "%.2f", score)
	} else {
		return String(format: "%.2f", beatenScore)
	}
}


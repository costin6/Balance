//
//  GameState.swift
//  ios-individual-case-costin-burlacioiu
//
//  Created by Costin Burlacioiu on 26/09/2023.
//
import CoreMotion
import Foundation
import UIKit
class GameState: ObservableObject {
    @Published var ballPosition: CGPoint
    @Published var ballVerticalVelocity: CGFloat = 0.0
    @Published var isGameStarted: Bool = false
    @Published var isGameActive: Bool = false
    @Published var isGameOver: Bool = false
    @Published var isBallFalling: Bool = false
    @Published var tilt: Double = 0.0
    @Published var countdown: Int? = nil
    @Published var score: Int = 0
    
    let platformYPosition: CGFloat = UIScreen.main.bounds.height * 3/4
    let platformHeight: CGFloat = 20
    let platformWidth: CGFloat = 200
    let ballRadius: CGFloat = 15
    
    var motionManager: CMMotionManager?
    
    init() {
        self.ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: platformYPosition - ballRadius - platformHeight / 2)
        setupMotionManager()
    }
    
    func setupMotionManager() {
        motionManager = CMMotionManager()
        motionManager?.deviceMotionUpdateInterval = 0.1
        
        if motionManager?.isDeviceMotionAvailable == true {
            motionManager?.startDeviceMotionUpdates(to: .main) { (data, error) in
                guard let data = data else { return }
                self.tilt = data.gravity.x
            }
        }
    }
    
    func resetGame() {
        self.ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: platformYPosition - ballRadius - platformHeight / 2)
        self.ballVerticalVelocity = 0.0
        self.isGameOver = false
        self.isGameStarted = false
        self.isGameActive = false
        self.isBallFalling = false
        self.tilt = 0.0
        self.score = 0
    }
}

//
//  GameView.swift
//  ios-individual-case-costin-burlacioiu
//
//  Created by Costin Burlacioiu on 26/09/2023.
//

import Foundation
import SwiftUI
struct GameView: View {
    @ObservedObject var gameState: GameState
    let platformWidth: CGFloat = 200
    let platformHeight: CGFloat = 20
    let ballRadius: CGFloat = 15
    let platformYPosition = UIScreen.main.bounds.height * 3/4
    let blueGradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color("LightBlue")]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(blueGradient)
                .edgesIgnoringSafeArea(.all)
            if gameState.isGameStarted || gameState.isGameActive {
                // Ball
                Circle()
                    .fill(Color.blue)
                    .frame(width: gameState.ballRadius * 2, height: gameState.ballRadius * 2)
                    .position(gameState.ballPosition)
                
                // Platform
                Rectangle()
                    .fill(Color.green)
                    .frame(width: platformWidth, height: platformHeight)
                    .position(x: UIScreen.main.bounds.width / 2, y: gameState.platformYPosition)
                VStack {
                    Text("Score")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text("\(gameState.score)")
                        .font(.system(size: 60))  // You can adjust this font size as needed.
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4)
                
                if gameState.isGameOver {
                    VStack(spacing: 20) {
                        Text("Game Over")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        
                        Button(action: {
                            self.gameState.resetGame()
                        }) {
                            Text("Try Again")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }            } else if let countdownValue = gameState.countdown {
                    // Show the countdown
                    Text("\(countdownValue)")
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    if !gameState.isGameStarted && gameState.countdown == nil {
                        Text("Balance")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/4 - 80) // Adjust the positioning as desired
                        Button(action: {
                            self.startCountdown()
                        }) {
                            Text("Play")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                    }
                }
        }
    }
    
    func startCountdown() {
        gameState.ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: gameState.platformYPosition - gameState.ballRadius - gameState.platformHeight / 2)
        gameState.countdown = 3
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if gameState.countdown! > 1 {
                gameState.countdown! -= 1
            } else {
                gameState.countdown = nil
                gameState.isGameStarted = true
                gameState.isGameActive = true
                timer.invalidate()
                
                startGameLogic()
            }
        }
    }
    
    // Adjust the ball's position based on tilt ONLY if the game is active
    func startGameLogic() {
        //        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
        //            // Adjust ball position based on tilt ONLY if the game is active AND game is not over
        //            if self.gameState.isGameActive && !self.gameState.isGameOver {
        //                self.gameState.ballPosition.x += CGFloat(self.gameState.tilt * 10)
        //            }
        //
        //            // Check if the ball is off the platform
        //            let ballLeftEdge = self.gameState.ballPosition.x - self.ballRadius
        //            let ballRightEdge = self.gameState.ballPosition.x + self.ballRadius
        //
        //            let platformLeftEdge = UIScreen.main.bounds.width / 2 - self.gameState.platformWidth / 2
        //            let platformRightEdge = UIScreen.main.bounds.width / 2 + self.gameState.platformWidth / 2
        //
        //            if ballLeftEdge < platformLeftEdge || ballRightEdge > platformRightEdge {
        //                self.gameState.isGameOver = true
        //            }
        //        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.gameState.isGameActive && !self.gameState.isGameOver {
                self.gameState.score += 1
            } else if self.gameState.isGameOver {
                timer.invalidate()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                // Adjust ball position based on tilt ONLY if the ball is not falling
                if self.gameState.isGameActive && !self.gameState.isGameOver && !self.gameState.isBallFalling {
                    self.gameState.ballPosition.x += CGFloat(self.gameState.tilt * 10)
                }
                
                // Check if the ball is off the platform
                let ballLeftEdge = self.gameState.ballPosition.x
                let ballRightEdge = self.gameState.ballPosition.x
                
                let platformLeftEdge = UIScreen.main.bounds.width / 2 - self.gameState.platformWidth / 2 - self.ballRadius
                let platformRightEdge = UIScreen.main.bounds.width / 2 + self.gameState.platformWidth / 2 + self.ballRadius
                
                if ballLeftEdge < platformLeftEdge || ballRightEdge > platformRightEdge {
                    self.gameState.isGameOver = true
                    self.gameState.isGameActive = false
                    self.gameState.isBallFalling = true

                    // Increase vertical velocity to simulate falling
                    self.gameState.ballVerticalVelocity += 1
                    self.gameState.ballPosition.y += self.gameState.ballVerticalVelocity
                }
            }
    }
    
    var ballStartPosition: CGFloat {
        platformYPosition - ballRadius - platformHeight / 2
    }
}

//
//  ContentView.swift
//  ios-individual-case-costin-burlacioiu
//
//  Created by Costin Burlacioiu on 26/09/2023.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        GameView(gameState: GameState(startPosition: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 3/4)))
//    }
//}

struct ContentView: View {
    var body: some View {
        GameView(gameState: GameState())
    }
}



#Preview {
    ContentView()
}

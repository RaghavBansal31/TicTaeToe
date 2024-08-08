//
//  ContentView.swift
//  TicTaeToe Watch App
//
//  Created by Raghav Bansal on 8/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var  viewModel = ViewModel()
    var body: some View {
        GeometryReader{geometry in
            VStack {
                Text("Tic Tae Toe")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .frame(alignment:.topTrailing).padding(-30)

                
                 
                LazyVGrid(columns:viewModel.columns){
                ForEach(0..<9){ i in
                    ZStack{
                        
                        Circle()
                            .foregroundColor(.orange).opacity(0.8)
                            .frame(width:geometry.size.width/3, height: geometry.size.height/3)
                        
                        Image(systemName: viewModel.moves[i]?.indicator ?? " ")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        
                        
                    }.onTapGesture {
                        viewModel.processPlayerMoves(for: i)
                    }
                }
            }
                
               
                
        }
            
    }
    
    .disabled(viewModel.isGameBoardDisabled)
    .padding()
    .alert(item: $viewModel.alertproduct, content: { alertproduct in
        Alert(title: alertproduct.title, message: alertproduct.message,
              dismissButton: .default(alertproduct.buttonTitle, action: {viewModel.resetGame()}))
    })
}

}
enum Player{
    case human
    case computer
}

struct move{
    let player:Player
    let boardIndex:Int
    var indicator:String{
        return player == .human ? "xmark" : "circle"
    }
}

#Preview {
    ContentView()
}

//
//  ViewModel.swift
//  TicTaeToe Watch App
//
//  Created by Raghav Bansal on 8/7/24.
//

import Foundation
import SwiftUI

final class ViewModel:ObservableObject{
    
    let columns:[GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    
    @Published var moves: [move?] = Array(repeating: nil, count: 9)
    @Published var  isGameBoardDisabled = false
    @Published var alertproduct:AlertProduct?
    
    
    //---------- To process the moves of the players either human or computer to find the result of the game
    func processPlayerMoves(for position:Int){
        if isSqaureOccupied(in: moves, forIndex: position){return}
        moves[position] = move(player: .human, boardIndex: position)
        
        //check for win or draw
        
        if checkWinCondition(for: .human, in: moves){
            alertproduct = AlertHuman.humanWin
            return
        }
        if checkDraw(in: moves){
            alertproduct = AlertHuman.drawGame
            return
        }
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){ [self] in
            let computerPosition = checkComputerPosition(in: moves)
            moves[computerPosition] = move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            if checkWinCondition(for: .computer, in:moves){
                alertproduct = AlertHuman.computerWin
                return
            }
            
            if checkDraw(in: moves){
                alertproduct = AlertHuman.drawGame
                return
            }
            
            
        }
    }
    
    //------- To check whether any of the 9 spaces are occupied or not and check the squares a move can be made by the players
    
    func isSqaureOccupied(in moves:[move?], forIndex index:Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    //---------- To make sure that the computer gives a tough competition to the human player but making moves which leads the computer victory
    
    func checkComputerPosition(in moves:[move?]) -> Int{
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let computerMoves = moves.compactMap({$0}).filter{$0.player == .computer }
        let computerPosition = Set(computerMoves.map({$0.boardIndex}))
        for pattern in winPattern {
            let winPosition = pattern.subtracting(computerPosition)
            if winPosition.count == 1{
                let isAvailable = !isSqaureOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable{return winPosition.first!}
            }
        }
        //-if the computer can win, make a move accordingly
       
        let humanMoves = moves.compactMap({$0}).filter{$0.player == .human }
        let humanPosition = Set(humanMoves.map({$0.boardIndex}))
        for pattern in winPattern {
            let winPosition = pattern.subtracting(humanPosition)
            if winPosition.count == 1{
                let isAvailable = !isSqaureOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable{return winPosition.first!}
            }
        }
        //--- if the computer cannot win then block the human player
        let centerSquare = 4
        if !isSqaureOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        //- if no move is possible then take the center square
        var moveComputerPosition = Int.random(in: 0..<9)
        
        while isSqaureOccupied(in: moves, forIndex: moveComputerPosition){
            moveComputerPosition = Int.random(in: 0..<9)
        }
        
        return moveComputerPosition
        //- if no option left then make a random move
    }
    
    //---------- to check the winning conditions of the tic tae toee game
    
    func checkWinCondition(for player:Player, in moves:[move?]) -> Bool{
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap({$0}).filter{$0.player == player }
        let playerPositon = Set(playerMoves.map({$0.boardIndex}))
        
        for pattern in winPattern where pattern.isSubset(of: playerPositon) {
            return true
        }

        return false
    }
    //---------- to check a draw
    
    func checkDraw(in moves:[move?]) -> Bool{
        return moves.compactMap{$0}.count ==  9
    }
    
    //---------- to reset a game
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
    
}

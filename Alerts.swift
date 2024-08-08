//
//  Alerts.swift
//  TicTaeToe Watch App
//
//  Created by Raghav Bansal on 8/7/24.
//

import Foundation
import SwiftUI


struct AlertProduct:Identifiable{
    let id = UUID()
    let title:Text
    let message:Text
    let buttonTitle:Text
}

struct AlertHuman{
   static let humanWin = AlertProduct( title: Text("You Won"), message: Text("Please play again"), buttonTitle: Text("Try Again"))
    
    static let computerWin = AlertProduct( title: Text("You have Lost"), message: Text("Please play again"), buttonTitle: Text("Try Again"))
    
    static let drawGame = AlertProduct( title: Text("The Game is a Draw"), message: Text("Please play again"), buttonTitle: Text("Try Again"))
}

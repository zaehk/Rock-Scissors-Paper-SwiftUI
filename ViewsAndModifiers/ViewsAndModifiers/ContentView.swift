//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Borja Saez de Guinoa Vilaplana on 17/6/21.
//

import SwiftUI

struct BlurredLabel: View {
    var blurTitle: String
    
    var body: some View {
        Text(blurTitle)
            .blur(radius: 3.0)
            .foregroundColor(.blue)
    }
}

enum RockScissorsPaper: String {
    case rock = "Rock"
    case scissors = "Scissors"
    case paper = "Paper"
    
    var icon: UIImage? {
        UIImage.init(named: self.rawValue)
    }
    
    func winsOver(game: RockScissorsPaper) -> GameState {
        switch (self, game) {
        case (.rock, .rock):     return .draw
        case (.rock, .paper):    return .lose
        case (.rock, .scissors): return .win
            
        case (.paper, .rock):     return .win
        case (.paper, .paper):    return .draw
        case (.paper, .scissors): return .lose
            
        case (.scissors, .rock):     return .lose
        case (.scissors, .paper):    return .win
        case (.scissors, .scissors): return .draw
        }
    }
}

enum GameState {
    case win
    case lose
    case draw
    
    func result(shouldWin: Bool)-> Int {
        switch self {
        
        case .win:
            return shouldWin ? 1 : -1
        case .lose:
            return shouldWin ? -1 : 1
        case .draw:
            return 0
        }
    }
}


struct ContentView: View {
    
    let choices : [RockScissorsPaper] = [ .rock, .scissors, .paper]
    
    @State var shouldWin: Bool = .random()
    @State var cpuChoice : Int = Int.random(in: 0...2)
    
    @State var points: Int = 0
    @State var game: Int = 0
    
    var body: some View {
        NavigationView{
            Form{
                
                Section(header: Text("Machine choice")) {
                    BlurredLabel(blurTitle: choices[cpuChoice].rawValue)
                }.font(.headline)
                
                
                Section(header: Text("The user must")) {
                    Text(shouldWin ? "WIN" : "LOSE")
                        .frame(width: 100, height: 50, alignment: .center)
                        .background(shouldWin ? Color.green : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }.font(.headline)
                
                Section(header: Text("User selection")) {
                    List{
                        ForEach(choices, id: \.self, content: { userChoice in
                            Button(action: {
                                
                                points += userChoice.winsOver(game: choices[cpuChoice]).result(shouldWin: shouldWin)
                                
                                game += 1
                                cpuChoice = Int.random(in: 0...2)
                                shouldWin = Bool.random()
                            }, label: {
                                HStack{
                                    Image(userChoice.rawValue.lowercased())
                                    Text(userChoice.rawValue).foregroundColor(.black)
                                }
                            })
                        })
                    }
                }.font(.headline)
                
                HStack{
                    Text("Total Points:")
                    Text("\(points)")
                    
                }
                .font(.title2)
                HStack{
                    Text("Current game:")
                    Text("\(game)")
                }
                .font(.title2)
            }
        }
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

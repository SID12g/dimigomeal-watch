//
//  ContentView.swift
//  DimigoMealWatch Watch App
//
//  Created by 조성민 on 9/13/24.
//

import SwiftUI
import AVFoundation
import AVKit

struct OverlayPlayerForTimeRemove: View {
    var body: some View {
        VideoPlayer(player: nil, videoOverlay: { })
            .focusable(false)
            .disabled(true)
            .opacity(0)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

struct ContentView: View {
    var meal = (
        breakfast: "햄사라다모닝빵/쌀밥/소고기만두전골/가마보꼬강정/건파래무침/배추겉절이/아보카도베이컨샐러드&유자d/시리얼2종/우유,저지방우유,두유,과채주스2종1택/유산균",
        dinner: "짜장제육볶음/수수밥/쌀밥/감자옹심이국/애송이짬뽕소스조림/청경채겉절이/포기김치/초코생크림와플/비빔코너/샐러드바/영양밥",
        lunch: "백미밥&김자반/등뼈국물김치찜/오코노미계란말이/참나물샐러드/섞박지/딸기바나나우유",
        date: "2024-09-12"
    )
    
    func splitString(input: String) -> [String] {
        let separatedArray = input.split(separator: "/").map { String($0) }
        return separatedArray
    }
    
    var body: some View {
        ZStack {
            Image("bg").brightness(-0.05)
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.white)
                .opacity(0.3)
                .overlay(
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("아침")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(meal.date).font(.system(size: 14)).padding(.trailing, 12)
                                }.padding(.bottom, 4).padding(.top, 10)
                                
                                ForEach(splitString(input: meal.breakfast), id: \.self) { item in
                                    Text("- \(item)")
                                        .font(.system(size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.leading, 12)
                        }.clipped()
                    }
                        .padding()
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.white.opacity(0.4), lineWidth: 0.6)
                )
                .frame(width: 172, height: 220)
                .padding()
                .padding(.top, -24)
        }
        .background(OverlayPlayerForTimeRemove())
    }
}


#Preview {
    ContentView()
}

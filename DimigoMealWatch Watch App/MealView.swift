//
//  MealView.swift
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


struct MealView: View {
    var time: String
    var meal: [String]
    var date: String
    @State private var watchDisplayHeight: CGFloat = WKInterfaceDevice.current().screenBounds.height
    @State private var watchDisplayWidth: CGFloat = WKInterfaceDevice.current().screenBounds.width
    
    var body: some View {
        ZStack {
            Image(time).resizable().frame(width: watchDisplayWidth, height: watchDisplayHeight + 24).brightness(-0.1).padding(.top, -24)
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .opacity(0.4).brightness(-0.1)
                .overlay(
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(
                                        time == "breakfast" ? "아침"
                                        :time == "lunch" ? "점심" : "저녁"                               )
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    Spacer()
                                    Text(date).font(.system(size: 12)).padding(.trailing, 8)
                                }.padding(.bottom, 4).padding(.top, 10)
                                
                                if(!meal.isEmpty) {
                                    ForEach(meal, id: \.self) { item in
                                        Text("- \(item)")
                                            .font(.system(size: 16))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                } else {
                                    Text("급식 정보가 없습니다")
                                }
                            }
                            .padding(.leading, 8)
                        }.clipped()
                    }
                        .padding()
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.4), lineWidth: 0.6)
                )
                .padding(12)
                .frame(width: watchDisplayWidth, height: watchDisplayHeight)
                .padding(.top, -24)
        }
        .background(OverlayPlayerForTimeRemove())
    }
}


#Preview {
    MealView(time: "breakfast", meal: ["햄사라다모닝빵","쌀밥","소고기만두전골","가마보꼬강정","건파래무침","배추겉절이","아보카도베이컨샐러드&유자d","시리얼2종","우유,저지방우유,두유,과채주스2종1택","유산균"], date: "2024-09-12")
}

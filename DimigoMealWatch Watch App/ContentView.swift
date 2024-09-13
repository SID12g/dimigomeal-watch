//
//  ContentView.swift
//  DimigoMealWatch Watch App
//
//  Created by 조성민 on 9/13/24.
//

import SwiftUI


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
        TabView {
            MealView(time: "breakfast", meal: splitString(input: meal.breakfast), date: meal.date)
            MealView(time: "lunch", meal: splitString(input: meal.lunch), date: meal.date)
            MealView(time: "dinner", meal: splitString(input: meal.dinner), date: meal.date)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}



#Preview {
    ContentView()
}

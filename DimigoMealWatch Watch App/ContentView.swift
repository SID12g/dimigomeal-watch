//
//  ContentView.swift
//  DimigoMealWatch Watch App
//
//  Created by 조성민 on 9/13/24.
//

import SwiftUI
import Foundation
import Combine


struct MealData: Codable {
    let breakfast: String
    let lunch: String
    let dinner: String
    let date: String
}


class MealViewModel: ObservableObject {
    @Published var meal: MealData?
    @Published var isLoading = false
    
    let date = Date()
    
    func formatDateToYYYYMMDD(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func fetchMeal() {
        guard let url = URL(string: "https://api.xn--299a1v27nvthhjj.com/meal/\(formatDateToYYYYMMDD(date: date))") else {
            print("잘못된 Request")
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(MealData.self, from: data)
                    DispatchQueue.main.async {
                        self.meal = decodedData
                        self.isLoading = false
                    }
                } catch {
                    print("JSON 변환 실패: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } else if let error = error {
                print("오류: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = MealViewModel()
    @State private var selectedTab = 0
    let date = Date()
    
    func formatDateToYYYYMMDD(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func splitString(input: String) -> [String] {
        let separatedArray = input.split(separator: "/").map { String($0) }
        return separatedArray
    }
    
    func determineInitialTabIndex() -> Int {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        
        if currentHour >= 0 && currentHour < 9 {
            return 0 // 아침
        } else if currentHour >= 9 && currentHour < 14 {
            return 1 // 점심
        } else {
            return 2 // 저녁
        }
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("로딩중...")
            } else if let meal = viewModel.meal {
                TabView(selection: $selectedTab) {
                    MealView(time: "breakfast", meal: splitString(input: meal.breakfast), date: meal.date)
                        .tag(0)
                    MealView(time: "lunch", meal: splitString(input: meal.lunch), date: meal.date)
                        .tag(1)
                    MealView(time: "dinner", meal: splitString(input: meal.dinner), date: meal.date)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    selectedTab = determineInitialTabIndex()
                }
            } else {
                Text("급식 정보가 없습니다")
                Text("\(formatDateToYYYYMMDD(date: date))")
            }
        }
        .onAppear {
            viewModel.fetchMeal()
        }
    }
}



#Preview {
    ContentView()
}

//
//  ContentView.swift
//  DimigoMealWatch Watch App
//
//  Created by 조성민 on 9/13/24.
//

import SwiftUI
import Foundation
import Combine

// 1. 모델 정의
struct MealData: Codable {
    let breakfast: String
    let lunch: String
    let dinner: String
    let date: String
}

// 2. ViewModel (API 요청 및 데이터 관리)
class MealViewModel: ObservableObject {
    @Published var meal: MealData?
    @Published var isLoading = false
    
    func fetchMeal() {
        guard let url = URL(string: "https://api.xn--299a1v27nvthhjj.com/meal/2024-09-13") else {
            print("Invalid URL")
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
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

// 3. ContentView
struct ContentView: View {
    @StateObject var viewModel = MealViewModel()
    
    func splitString(input: String) -> [String] {
        let separatedArray = input.split(separator: "/").map { String($0) }
        return separatedArray
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...") // 로딩 중일 때 표시할 UI
            } else if let meal = viewModel.meal {
                TabView {
                    MealView(time: "breakfast", meal: splitString(input: meal.breakfast), date: meal.date)
                    MealView(time: "lunch", meal: splitString(input: meal.lunch), date: meal.date)
                    MealView(time: "dinner", meal: splitString(input: meal.dinner), date: meal.date)
                }
                .tabViewStyle(PageTabViewStyle())
            } else {
                Text("No meal data available") // 데이터가 없을 때 표시할 메시지
            }
        }
        .onAppear {
            viewModel.fetchMeal() // 뷰가 나타날 때 API 요청 시작
        }
    }
}

// 5. Preview
#Preview {
    ContentView()
}

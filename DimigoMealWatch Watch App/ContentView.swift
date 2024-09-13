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
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("로딩중...")
            } else if let meal = viewModel.meal {
                TabView {
                    MealView(time: "breakfast", meal: splitString(input: meal.breakfast), date: meal.date)
                    MealView(time: "lunch", meal: splitString(input: meal.lunch), date: meal.date)
                    MealView(time: "dinner", meal: splitString(input: meal.dinner), date: meal.date)
                }
                .tabViewStyle(PageTabViewStyle())
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

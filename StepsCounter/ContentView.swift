//
//  ContentView.swift
//  StepsCounter
//
//  Created by Froy on 9/17/21.
//  Based on https://www.youtube.com/watch?v=ohgrzM9gfvM

import SwiftUI
import HealthKit

struct ContentView: View {
    private var healthStore: HealthStore?
    @State private var steps: [Step] = [Step]()

    init(){
        healthStore = HealthStore()

    }

    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){

        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()

        statisticsCollection.enumerateStatistics(from: startDate, to: endDate){ (statistics, stop) in

            let count = statistics.sumQuantity()?.doubleValue(for: .count())

            let step = Step(count: Int(count ?? 0), date: statistics.startDate)

            steps.append(step)

        }
    }

    var body: some View {

        Spacer()

        Text("Walking App")
            .font(.title)
            .foregroundColor(.green).bold()

        Text("This app counts your daily number of steps given")
            .foregroundColor(.white)
            .font(.footnote)
            .frame(width: 500, alignment: .center)
        NavigationView {
        List(steps, id: \.id){ step in


            VStack (alignment: .leading){

                Text("\(step.count) steps")

                Text(step.date, style: .date)
                    .opacity(0.5)
            }
        }
//        .navigationTitle("Waking App")



        }
            .onAppear{
                if let healthStore = healthStore{ healthStore.requestAuthorization{
                    success in
                    if success{
                        healthStore.calculateSteps{statisticsCollection in
                            if let statisticsCollection = statisticsCollection{
                                //Update UI
                                print(statisticsCollection)
                                updateUIFromStatistics(statisticsCollection)
                            }

                        }
                    }
                }

                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

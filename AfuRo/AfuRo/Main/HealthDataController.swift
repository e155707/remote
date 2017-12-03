

import Foundation
import HealthKit

class HealthDataController{
    var storage:HKHealthStore = HKHealthStore()
    init() {
        checkAuthorization()
    }
    @discardableResult
    func checkAuthorization() -> Bool {
        var isEnabled = true
        
        // 利用しているデバイスでHealthKitが利用可能か調べる
        if HKHealthStore.isHealthDataAvailable()
        {
            // 歩数の取得をリクエスト
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) ?? 0)
            
            print(steps)
            // 許可されているかどうかを確認
            storage.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    

    
    // 歩数をHealthKitから取得する
    func getStepsHealthKit(startDate: Date, endDate: Date) -> Int {
        // セマフォアの作成.
        let semaphore = DispatchSemaphore(value: 0)
        print("self = \(self.checkAuthorization())")
        // startDateから, endDateまでの歩数を取得する
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: [])
        
        // HKSampleから歩数の取得をリクエスト
        let typeOfStep = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        var steps: Int = 0
        
        
        // 指定期間内のデータを取得する
        let query = HKSampleQuery(sampleType: typeOfStep!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            

            if let results = results{
            // 指定期間で取得できた歩数の合計を計算
                if results.count > 0
                {
                    for result in results as! [HKQuantitySample]
                    {
                        steps += Int(result.quantity.doubleValue(for: HKUnit.count()))
                    }
                
                }
                
            }else{
                print(error ?? "results = nil")
            }

            // セマフォアの解除. データ取得の完了
            semaphore.signal()
        }
        
        self.storage.execute(query)
        
        // stepsが計算し終わるまでwaitする.
        semaphore.wait()
        return steps
    }
    
    
    // --- ダミーの値を返す関数群 --- //
    
    let dummySteps = 0
    func getDummyStepsData() -> Int{
        
        return dummySteps
    }

    
}

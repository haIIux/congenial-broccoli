
import SwiftUI
import Combine // Used for the JUST functions.

/*
 Mifflin-St. Jeor equation
 
 GET TDEE :
 Men: calories/day = 10 x weight (kg) + 6.25 x height (cm) – 5 x age (y) + 5
 Women: calories/day = 10 x weight (kg) + 6.25 x height (cm) – 5 x age (y) – 161
 
 ACTIVITY:
 Sedentary: x 1.2 (limited exercise)
 Lightly active: x 1.375 (light exercise less than three days per week)
 Moderately active: x 1.55 (moderate exercise most days of the week)
 Very active: x 1.725 (hard exercise every day)
 Extra active: x 1.9 (strenuous exercise two or more times per day)
 
 RESULT:
 TDEE

 */
enum GenderPickerSelector: String, CaseIterable {
    case male
    case female
}

enum ActivityLevelSelector: Double, CaseIterable {
    case sedentary = 1.2
    case lightlyActive = 1.375
    case moderatelyActive = 1.55
    case veryActive = 1.725
    
    var description: String {
        switch self {
        case .sedentary:
            return "Sedentary"
        case .lightlyActive:
            return "Lightly Active"
        case .moderatelyActive:
            return "Moderately Active"
        case .veryActive:
            return "Very Active"
        }
    }
}

enum GoalSelector: Double, CaseIterable {
    
    case maintainWeight = 0.0 // No weight loss or gain.
    case mildWeightLoss = 0.18 // 18% deficit.
    case moderateWeightLoss = 0.25 // 25% deficit.
    case mildWeightGain = 0.1 // 10% gain.
    case moderateWeightGain = 0.2 // 20% gain.
    
    var description: String {
        switch self {
        case .maintainWeight:
            return "Maintain Weight"
        case .mildWeightLoss:
            return "Mild Weight Loss"
        case .moderateWeightLoss:
            return "Moderate Weight Loss"
        case .mildWeightGain:
            return "Mild Weight Gain"
        case .moderateWeightGain:
            return "Moderate Weight Gain"
        }
    }
}

struct MacroCalculatorView: View {
    
    @State  var chosenGender: GenderPickerSelector = .male
    @State  var chosenActivityLevel: ActivityLevelSelector
    @State  var chosenGoal:  GoalSelector = .maintainWeight
    @State  var showactivityAlert: Bool
    //    @State  var goalAlert: Bool
    
    @State var ageInput = ""
    @State var heightInFeet = ""
    @State var heightInInches = ""
    @State var weightInput = ""
    @State var dailyCalories: Int = 0
    
    let genderSelector: GenderPickerSelector
    let activitySelector: ActivityLevelSelector

//    let goalSelector: GoalSelectorq
    
    
    func ConvertHeight() -> Double {
        let convertHeight = Double(heightInFeet)! * 12
        let addInches = convertHeight + Double(heightInInches)!
        
        let centimetersReturn = addInches * 2.54
        
        // Returns height in centimeters.
        return centimetersReturn
    }
    
    func ConvertPoundsToKg() -> Double {
        guard let userWeightInput = Double(weightInput) else { return 0.0 }
        let performConversion = userWeightInput / 2.2046 // Number is the conversion number.
        
        return Double(performConversion)
    }
    
    func CaloriesMen() -> Double {
        let heightConversionFunction = ConvertHeight()
        let weightConversionFunction = ConvertPoundsToKg()
        
        let stepOne = 10 * weightConversionFunction
        let stepTwo = 6.25 * heightConversionFunction
        let stepThree = 5 * Double(ageInput)! // Age in Years.
        let stepFour = stepOne + stepTwo - stepThree + 5
        let stepFive = stepFour - chosenGoal.rawValue
        
        return Double(stepFive)
    }
    
    func CaloriesWomen() -> Double {
        let heightConversionFunction = ConvertHeight()
        let weightConversionFunction = ConvertPoundsToKg()
        
        let stepOne = 10 * weightConversionFunction
        let stepTwo = 6.25 * heightConversionFunction
        let stepThree = 5 * Double(ageInput)! // Age in Years.
        let stepFour = stepOne + stepTwo - stepThree - 161
        
        return Double(stepFour)
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Macro Calculator")
                    .bold()
                    .font(.title2)
                    .padding(.bottom)
                Divider()
                    .frame(width: 350)
                    .padding(.bottom)
                Text("This calculator will provide you with a guideline for a daily macronutrient intake. Please be sure to consult with your primary care physician prior to starting any form of diet or physical exercise.")
                    .padding(.bottom)
                    .padding(.horizontal)
                    .font(.caption)
            }
        
            VStack {
                Text("Please select your gender.")
                    .font(.caption)
                Picker("Gender", selection: $chosenGender) {
                    ForEach(GenderPickerSelector.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 350)
                .padding(.bottom)
            
                Text("Please enter the following information.")
                    .font(.caption)
                HStack {
                    TextField("Age", text: $ageInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(ageInput)) { newAgeInput in
                            let filtered = newAgeInput.filter { "0123456789".contains($0) }
                            if filtered != newAgeInput {
                                self.ageInput = filtered
                            }
                        }
                    TextField("Weight (Lbs)", text: $weightInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(weightInput)) { newWeightInput in
                            let filtered = newWeightInput.filter { "0123456789".contains($0) }
                            if filtered != newWeightInput {
                                self.weightInput = filtered
                            }
                        }
                }
                
                HStack {
                    TextField("Feet", text: $heightInFeet)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(heightInFeet)) { newFeetInput in
                            let filtered = newFeetInput.filter { "0123456789".contains($0) }
                            if filtered != newFeetInput {
                                self.heightInFeet = filtered
                            }
                        }
                    
                    TextField("Inches", text: $heightInInches)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(heightInInches)) { newInchesInput in
                            let filtered = newInchesInput.filter { "0123456789".contains($0) }
                            if filtered != newInchesInput {
                                self.heightInInches = filtered
                            }
                        }
                }
            }
            .frame(width: 350)
            .padding(.bottom)
            
            
            VStack {
                Text("Please select your activity level.")
                    .font(.caption)
                Picker("Activity Level", selection: $chosenActivityLevel) {
                    ForEach(ActivityLevelSelector.allCases, id: \.self) {
                        Text($0.description.capitalized)
                    }
                }
                .frame(width: 350, height: 75)
                .clipped()
            }
            .padding(.bottom)
            
            VStack {
                Text("Please select your goal.")
                    .font(.caption)
                
                Picker("Goal", selection: $chosenGoal) {
                    ForEach(GoalSelector.allCases, id: \.self) {
                        Text($0.description.capitalized)
                    }
                }
                .frame(width: 350, height: 65)
                .clipped()
        }
            .padding(.bottom)
            HStack {
                Text("Daily Calorie Intake :")
                    .font(.title3)
                Text(" \(dailyCalories)")
                    .bold()
                    .font(.title3)

            }

            ZStack {
                Rectangle()
                    .frame(width: 150, height: 50)
                    .foregroundColor(.green)
                    .cornerRadius(10)
                Text("Calculate")
            }
            .padding(.top)
            /*
             Female version not completed.
             Issues : Math is not working properly when selecting various activity levels with the goal set to the weight gain selections. App performs initial calculation upon selection then fails to recalculate. 
             */
            .onTapGesture {
                switch chosenGender {
                case .male:
                    if chosenGoal.description.contains("Mild Weight Gain") {
                        let caloriesBeforeCalculation = CaloriesMen()
                        let mildWeightGainGoalMath = Int(CaloriesMen() * chosenGoal.rawValue)
                        let mildWeightGainAddingOfGoal = Int(CaloriesMen() + Double(mildWeightGainGoalMath))
                        let mildWeightGainActivityMath = mildWeightGainAddingOfGoal * Int(chosenActivityLevel.rawValue)
                        let mildWeightGainCalculation = mildWeightGainAddingOfGoal + mildWeightGainGoalMath
                        dailyCalories = mildWeightGainCalculation
                        print("Calories Before Calc : \(caloriesBeforeCalculation), \(chosenGoal.description) : \(chosenGoal.rawValue), Amount after Addition : \(mildWeightGainActivityMath), \(chosenActivityLevel.description) : \(chosenActivityLevel.rawValue), Final : \(dailyCalories)")
                       
                    } else if chosenGoal.description.contains("Moderate Weight Gain") {
                        let caloriesBeforeCalculation = CaloriesMen()
                        let moderateWeightGainGoalMath = Int(CaloriesMen() * chosenGoal.rawValue)
                        let moderateWeightGainAddingOfGoal = Int(CaloriesMen() + Double(moderateWeightGainGoalMath))
                        let moderateWeightGainActivityMath = moderateWeightGainAddingOfGoal * Int(chosenActivityLevel.rawValue)
                        let moderateWeightGainCalculation = moderateWeightGainAddingOfGoal + moderateWeightGainGoalMath
                        dailyCalories = moderateWeightGainCalculation
                        print("Calories Before Calc : \(caloriesBeforeCalculation), \(chosenGoal.description) : \(chosenGoal.rawValue), Amount To Add : \(moderateWeightGainActivityMath), \(chosenActivityLevel.description) : \(chosenActivityLevel.rawValue),  Final : \(dailyCalories)")
                    } else {
                    let caloriesBeforeCalculation = CaloriesMen()
                    let chosenGoalMath = Int(CaloriesMen() * chosenGoal.rawValue)
                    let completedGoalMathNowSubtractCaloriesForWeightLoss = Int(CaloriesMen() - Double(chosenGoalMath))
                    dailyCalories = Int(Double(completedGoalMathNowSubtractCaloriesForWeightLoss) * chosenActivityLevel.rawValue)
                        print("Calories Before Calc : \(caloriesBeforeCalculation), \(chosenGoal.description) : \(chosenGoal.rawValue), Final : \(dailyCalories)")
                    }
                case .female:
                    if chosenGoal.description.contains("Mild Weight Gain") {
                        print("Mild Wieght Gain")
                        let mildWeightGainMathMultiply = Int(CaloriesWomen() * chosenGoal.rawValue)
                        let mildWeightGainMathAddition = Int(CaloriesWomen() + Double(mildWeightGainMathMultiply))
                        let mildDailyCalories = mildWeightGainMathAddition * Int(chosenActivityLevel.rawValue)
                        dailyCalories = mildDailyCalories
                        print("Mild Weight Gain Calories : \(dailyCalories)")
                    } else if chosenGoal.description.contains("Moderate Weight Gain") {
                        print("Moderate Weight Gain")
                        let moderateWeightGainMathMulitply = Int(CaloriesWomen() * chosenGoal.rawValue)
                        let moderateWeightGainMathAddition = Int(CaloriesWomen() + Double(moderateWeightGainMathMulitply))
                        let moderateDailyCalories = moderateWeightGainMathAddition * Int(chosenActivityLevel.rawValue)
                        dailyCalories = moderateDailyCalories
                        print("Moderate Weight Gain Calories : \(moderateDailyCalories)") // 2229
                    } else {
                    let chosenGoalMath = Int(CaloriesWomen() * chosenGoal.rawValue)
                    let completedGoalMathNowSubtractCaloriesForWeightLoss = Int(CaloriesWomen() - Double(chosenGoalMath))
                    dailyCalories = Int(Double(completedGoalMathNowSubtractCaloriesForWeightLoss) * chosenActivityLevel.rawValue)
                    print("Calories times Goal = \(chosenGoalMath)")
                    print("New Calories after subtracting goal = \(completedGoalMathNowSubtractCaloriesForWeightLoss)")
                    }
                  }
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            Spacer()
        }
    }
}


struct MacroCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        MacroCalculatorView(chosenActivityLevel: .sedentary, showactivityAlert: false , genderSelector: GenderPickerSelector.male, activitySelector: .sedentary)
    }
}


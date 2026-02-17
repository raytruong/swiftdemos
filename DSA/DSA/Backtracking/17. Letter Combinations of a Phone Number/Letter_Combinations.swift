import Playgrounds

struct LetterCombinations {
    static let digitToLetters: [Character: [String]] = [
        "2": ["a", "b", "c"],
        "3": ["d", "e", "f"],
        "4": ["g", "h", "i"],
        "5": ["j", "k", "l"],
        "6": ["m", "n", "o"],
        "7": ["p", "q", "r", "s"],
        "8": ["t", "u", "v"],
        "9": ["w", "x", "y", "z"]
    ]

    static func backtracking(_ digits: String) -> [String] {
        var result: [String] = []

        func backtrack(remaining: ArraySlice<Character>, path: String) {
            guard let nextDigit = remaining.first else {
                if !path.isEmpty {
                    result.append(path)
                }
                return
            }

            let nextPossibleLetter = digitToLetters[nextDigit] ?? []

            for nextLetter in nextPossibleLetter {
                backtrack(
                    remaining: remaining.dropFirst(),
                    path: path + nextLetter
                )
            }
        }

        backtrack(remaining: ArraySlice(digits), path: "")
        return result
    }
}

import Foundation

// MARK: - Tax Models

struct FederalTaxBracket {
    let rate: Double
    let lowerBound: Double
    let upperBound: Double?

    static let brackets2025Single: [FederalTaxBracket] = [
        FederalTaxBracket(rate: 0.10, lowerBound: 0, upperBound: 11_600),
        FederalTaxBracket(rate: 0.12, lowerBound: 11_600, upperBound: 47_150),
        FederalTaxBracket(rate: 0.22, lowerBound: 47_150, upperBound: 100_525),
        FederalTaxBracket(rate: 0.24, lowerBound: 100_525, upperBound: 191_950),
        FederalTaxBracket(rate: 0.32, lowerBound: 191_950, upperBound: 243_725),
        FederalTaxBracket(rate: 0.35, lowerBound: 243_725, upperBound: 609_350),
        FederalTaxBracket(rate: 0.37, lowerBound: 609_350, upperBound: nil)
    ]
}

enum FilingStatus {
    case single
    case married
}

struct JobCompensation {
    let baseSalary: Double
    let bonus: Double
    let rsuVesting: Double
    let employerMatch: Double
    let megaBackdoorRoth: Double

    var totalCash: Double {
        baseSalary + bonus + rsuVesting
    }

    var totalComp: Double {
        baseSalary + bonus + rsuVesting + employerMatch + megaBackdoorRoth
    }

    var taxableIncome: Double {
        baseSalary + bonus + rsuVesting
    }
}

struct InvestmentGrowth {
    let capitalGains: Double
    let dividends: Double

    var total: Double {
        capitalGains + dividends
    }
}

// MARK: - Financial Report Generator

class FinancialReportGenerator {

    // MARK: - Input Properties
    let baseSalary: Double
    let vtiBalance: Double
    let stockGrant: Double
    let yearsToProject: Int

    // MARK: - Rate Settings
    let bonusRate: Double
    let employerMatchRate: Double
    let capitalGainsRate: Double
    let dividendYield: Double
    let stateTaxRate: Double
    let megaBackdoorRothContribution: Double

    // MARK: - Tax Settings
    let filingStatus: FilingStatus
    let standardDeduction: Double

    // MARK: - Validation Error
    enum ValidationError: Error, CustomStringConvertible {
        case negativeSalary
        case negativeBalance
        case negativeStockGrant
        case invalidBonusRate
        case invalidMatchRate
        case invalidCapitalGainsRate
        case invalidDividendYield
        case invalidStateTaxRate
        case invalidYearsToProject
        case invalidMegaBackdoorAmount

        var description: String {
            switch self {
            case .negativeSalary: return "Base salary must be positive"
            case .negativeBalance: return "VTI balance must be non-negative"
            case .negativeStockGrant: return "Stock grant must be non-negative"
            case .invalidBonusRate: return "Bonus rate must be between 0 and 1"
            case .invalidMatchRate: return "Employer match rate must be between 0 and 1"
            case .invalidCapitalGainsRate: return "Capital gains rate must be between 0 and 1"
            case .invalidDividendYield: return "Dividend yield must be between 0 and 1"
            case .invalidStateTaxRate: return "State tax rate must be between 0 and 1"
            case .invalidYearsToProject: return "Years to project must be positive"
            case .invalidMegaBackdoorAmount: return "Mega backdoor Roth contribution must be non-negative and <= 69,000"
            }
        }
    }

    // MARK: - Initializer
    init(
        baseSalary: Double,
        vtiBalance: Double = 0,
        stockGrant: Double = 0,
        yearsToProject: Int = 1,
        bonusRate: Double = 0.07,
        employerMatchRate: Double = 0.03,
        capitalGainsRate: Double = 0.046,
        dividendYield: Double = 0.014,
        stateTaxRate: Double = 0.0,
        filingStatus: FilingStatus = .single,
        standardDeduction: Double = 14_600,
        megaBackdoorRothContribution: Double = 0
    ) throws {
        // Validate inputs
        guard baseSalary > 0 else { throw ValidationError.negativeSalary }
        guard vtiBalance >= 0 else { throw ValidationError.negativeBalance }
        guard stockGrant >= 0 else { throw ValidationError.negativeStockGrant }
        guard yearsToProject > 0 else { throw ValidationError.invalidYearsToProject }
        guard (0...1).contains(bonusRate) else { throw ValidationError.invalidBonusRate }
        guard (0...1).contains(employerMatchRate) else { throw ValidationError.invalidMatchRate }
        guard (0...1).contains(capitalGainsRate) else { throw ValidationError.invalidCapitalGainsRate }
        guard (0...1).contains(dividendYield) else { throw ValidationError.invalidDividendYield }
        guard (0...1).contains(stateTaxRate) else { throw ValidationError.invalidStateTaxRate }
        guard megaBackdoorRothContribution >= 0 && megaBackdoorRothContribution <= 69_000 else {
            throw ValidationError.invalidMegaBackdoorAmount
        }

        self.baseSalary = baseSalary
        self.vtiBalance = vtiBalance
        self.stockGrant = stockGrant
        self.yearsToProject = yearsToProject
        self.bonusRate = bonusRate
        self.employerMatchRate = employerMatchRate
        self.capitalGainsRate = capitalGainsRate
        self.dividendYield = dividendYield
        self.stateTaxRate = stateTaxRate
        self.filingStatus = filingStatus
        self.standardDeduction = standardDeduction
        self.megaBackdoorRothContribution = megaBackdoorRothContribution
    }

    // MARK: - Main Report
    func printFullReport() {
        print("\n" + String(repeating: "=", count: 60))
        print("            COMPREHENSIVE FINANCIAL REPORT")
        print(String(repeating: "=", count: 60))

        let jobComp = calculateJobCompensation()
        printJobCompensationBreakdown(jobComp)

        let investmentGrowth = calculateInvestmentGrowth()
        printInvestmentBreakdown(investmentGrowth)

        let taxes = calculateTaxes(on: jobComp.taxableIncome)
        printTaxBreakdown(taxes)

        let afterTaxIncome = jobComp.taxableIncome - taxes.totalTax
        printAfterTaxSummary(afterTaxIncome: afterTaxIncome, investmentGrowth: investmentGrowth)

        if yearsToProject > 1 {
            printCompoundingProjection()
        }

        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - Job Compensation Calculation
    private func calculateJobCompensation() -> JobCompensation {
        let bonus = baseSalary * bonusRate
        let rsuVesting = stockGrant / 4  // Assumes 4-year vesting
        let employerMatch = baseSalary * employerMatchRate

        return JobCompensation(
            baseSalary: baseSalary,
            bonus: bonus,
            rsuVesting: rsuVesting,
            employerMatch: employerMatch,
            megaBackdoorRoth: megaBackdoorRothContribution
        )
    }

    private func printJobCompensationBreakdown(_ comp: JobCompensation) {
        print("\n📊 JOB COMPENSATION BREAKDOWN")
        print(String(repeating: "-", count: 60))
        print("  Base Salary:                    \(format(comp.baseSalary))")
        print("  Annual Bonus (\(Int(bonusRate * 100))%):             \(format(comp.bonus))")
        print("  RSU Vesting (Year 1):           \(format(comp.rsuVesting))")
        print(String(repeating: "-", count: 60))
        print("  Taxable Cash Comp:              \(format(comp.taxableIncome))")
        print("")
        print("  Employer 401k Match (\(Int(employerMatchRate * 100))%):  \(format(comp.employerMatch))")
        print("  Mega Backdoor Roth:             \(format(comp.megaBackdoorRoth))")
        print(String(repeating: "-", count: 60))
        print("  TOTAL COMPENSATION:             \(format(comp.totalComp))")
        print(String(repeating: "-", count: 60))
    }

    // MARK: - Investment Growth Calculation
    private func calculateInvestmentGrowth() -> InvestmentGrowth {
        let capitalGains = vtiBalance * capitalGainsRate
        let dividends = vtiBalance * dividendYield

        return InvestmentGrowth(
            capitalGains: capitalGains,
            dividends: dividends
        )
    }

    private func printInvestmentBreakdown(_ growth: InvestmentGrowth) {
        print("\n📈 INVESTMENT GROWTH (Year 1)")
        print(String(repeating: "-", count: 60))
        print("  Portfolio Balance:              \(format(vtiBalance))")
        print("  Capital Gains (\(String(format: "%.1f", capitalGainsRate * 100))%):         \(format(growth.capitalGains))")
        print("  Dividends (\(String(format: "%.1f", dividendYield * 100))%):               \(format(growth.dividends))")
        print(String(repeating: "-", count: 60))
        print("  Total Investment Growth:        \(format(growth.total))")
        print(String(repeating: "-", count: 60))
    }

    // MARK: - Tax Calculations
    private func calculateTaxes(on income: Double) -> (federalTax: Double, stateTax: Double, totalTax: Double) {
        let adjustedGrossIncome = max(0, income - standardDeduction)
        let federalTax = calculateFederalTax(on: adjustedGrossIncome)
        let stateTax = income * stateTaxRate
        let totalTax = federalTax + stateTax

        return (federalTax, stateTax, totalTax)
    }

    private func calculateFederalTax(on income: Double) -> Double {
        var tax: Double = 0
        var remainingIncome = income
        let brackets = FederalTaxBracket.brackets2025Single

        for bracket in brackets {
            let taxableInBracket: Double

            if let upperBound = bracket.upperBound {
                let bracketWidth = upperBound - bracket.lowerBound
                taxableInBracket = min(remainingIncome, max(0, bracketWidth))
            } else {
                taxableInBracket = remainingIncome
            }

            tax += taxableInBracket * bracket.rate
            remainingIncome -= taxableInBracket

            if remainingIncome <= 0 {
                break
            }
        }

        return tax
    }

    private func printTaxBreakdown(_ taxes: (federalTax: Double, stateTax: Double, totalTax: Double)) {
        print("\n💰 TAX BREAKDOWN")
        print(String(repeating: "-", count: 60))
        print("  Federal Income Tax:             \(format(taxes.federalTax))")
        if stateTaxRate > 0 {
            print("  State Tax (\(String(format: "%.1f", stateTaxRate * 100))%):                \(format(taxes.stateTax))")
        }
        print(String(repeating: "-", count: 60))
        print("  Total Tax Liability:            \(format(taxes.totalTax))")
        print(String(repeating: "-", count: 60))
    }

    // MARK: - After-Tax Summary
    private func printAfterTaxSummary(afterTaxIncome: Double, investmentGrowth: InvestmentGrowth) {
        let totalEconomicIncome = afterTaxIncome + investmentGrowth.total

        print("\n✅ AFTER-TAX SUMMARY")
        print(String(repeating: "-", count: 60))
        print("  After-Tax Job Income:           \(format(afterTaxIncome))")
        print("  Investment Growth:              \(format(investmentGrowth.total))")
        print(String(repeating: "-", count: 60))
        print("  TOTAL ECONOMIC INCOME:          \(format(totalEconomicIncome))")
        print(String(repeating: "=", count: 60))

        let monthlyIncome = totalEconomicIncome / 12
        let coveragePercent = (monthlyIncome / (baseSalary / 12)) * 100

        print("\n💡 INSIGHTS")
        print(String(repeating: "-", count: 60))
        print("  Monthly Economic Income:        \(format(monthlyIncome))")
        print("  Portfolio covers:               \(String(format: "%.1f", coveragePercent))% of base salary")
    }

    // MARK: - Multi-Year Projection
    private func printCompoundingProjection() {
        print("\n📅 \(yearsToProject)-YEAR COMPOUNDING PROJECTION")
        print(String(repeating: "-", count: 60))

        var currentBalance = vtiBalance
        let totalReturn = capitalGainsRate + dividendYield

        for year in 1...yearsToProject {
            let yearGrowth = currentBalance * totalReturn
            currentBalance += yearGrowth

            print("  Year \(year): Balance = \(format(currentBalance)), Growth = \(format(yearGrowth))")
        }

        print(String(repeating: "-", count: 60))
        print("  Final Balance:                  \(format(currentBalance))")
        print("  Total Growth:                   \(format(currentBalance - vtiBalance))")
        print(String(repeating: "-", count: 60))
    }

    // MARK: - Formatting
    private func format(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}


#Playground {
    // Example: Letter Combinations
    // print(LetterCombinations.backtracking("23"))

    // Example: Financial Report with California taxes and mega backdoor Roth
    do {
        let report = try FinancialReportGenerator(
            baseSalary: 180_000,
            vtiBalance: 450_000,
            stockGrant: 150_000,
            yearsToProject: 5,
            bonusRate: 0.07,
            employerMatchRate: 0.03,
            capitalGainsRate: 0.046,
            dividendYield: 0.014,
            stateTaxRate: 0.093,  // California top bracket
            filingStatus: .single,
            standardDeduction: 14_600,
            megaBackdoorRothContribution: 46_000  // After-tax 401k contributions
        )

        report.printFullReport()

    } catch let error as FinancialReportGenerator.ValidationError {
        print("Validation Error: \(error.description)")
    } catch {
        print("Unexpected error: \(error)")
    }
}

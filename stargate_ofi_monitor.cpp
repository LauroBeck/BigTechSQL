#include <iostream>
#include <atomic>
#include <vector>
#include <iomanip>

// $BN BLOOMBERG LONDON IBM DB2 REPORT | HFT EXTENSION
// Sovereign Risk Engine: HFT Order Flow Imbalance (OFI)
// Target: S&P 500 Rebound Validation (Mission 7500)

struct LevelQuote {
    double bid_price;
    double bid_size;
    double ask_price;
    double ask_size;
};

class StargateOFIMonitor {
private:
    std::atomic<double> cumulative_ofi{0.0};
    LevelQuote last_quote{0, 0, 0, 0};

public:
    void update_imbalance(const LevelQuote& current) {
        double delta_bid = 0, delta_ask = 0;

        if (current.bid_price > last_quote.bid_price) 
            delta_bid = current.bid_size;
        else if (current.bid_price == last_quote.bid_price) 
            delta_bid = current.bid_size - last_quote.bid_size;
        else 
            delta_bid = -last_quote.bid_size;

        if (current.ask_price < last_quote.ask_price) 
            delta_ask = current.ask_size;
        else if (current.ask_price == last_quote.ask_price) 
            delta_ask = current.ask_size - last_quote.ask_size;
        else 
            delta_ask = -last_quote.ask_size;

        double step_ofi = delta_bid - delta_ask;
        
        // Fix: Use operator+= for atomic double
        cumulative_ofi = cumulative_ofi + step_ofi; 
        last_quote = current;
    }

    double get_current_imbalance() const { return cumulative_ofi.load(); }
};

int main() {
    StargateOFIMonitor monitor;
    
    std::cout << "==========================================================" << std::endl;
    std::cout << "  $BN BLOOMBERG LONDON: STARGATE HFT TELEMETRY ACTIVE     " << std::endl;
    std::cout << "  MISSION: S&P 500 REBOUND TO 7500 | PIVOT: 7150          " << std::endl;
    std::cout << "==========================================================" << std::endl;
    
    // Mock Data Test: Simulate Institutional Buy Pressure
    LevelQuote q1 = {7179.25, 100, 7179.50, 100};
    LevelQuote q2 = {7179.25, 250, 7179.50, 50}; // Bid size grows, Ask size shrinks
    
    monitor.update_imbalance(q1);
    monitor.update_imbalance(q2);
    
    std::cout << "[SYSTEM] HFT MONITOR ACTIVE" << std::endl;
    std::cout << "[DATA] CURRENT OFI: " << monitor.get_current_imbalance() << " units" << std::endl;
    
    if (monitor.get_current_imbalance() > 0) {
        std::cout << "[SIGNAL] BUY_SIDE_IMBALANCE: ACCUMULATION DETECTED" << std::endl;
    }

    return 0;
}

#include <iostream>
#include <vector>
#include <string>
#include <iomanip>
#include <numeric>

struct BankNode {
    std::string ticker;
    double value;
    bool is_br;
    bool is_drex_active;
};

int main() {
    // April 2026: DREX Phased Rollout (ITUB and BPAC are Lead Nodes)
    std::vector<BankNode> nodes = {
        {"GS",   51.83, false, false}, 
        {"ITUB", 23.73, true,  true},  
        {"BBD",  16.12, true,  false}, 
        {"BPAC", 10.60, true,  true}
    };

    const double drex_alpha = 1.07; // 7% settlement efficiency gain
    double us_total = 0.0, br_total = 0.0;

    std::cout << "--- STARGATE DREX TELEMETRY (APR 2026) ---" << std::endl;
    
    for (const auto& node : nodes) {
        double current_val = node.value;
        if (node.is_drex_active) {
            current_val *= drex_alpha;
            std::cout << "[DREX ENABLED] ";
        }
        
        std::cout << "Node: " << std::left << std::setw(5) << node.ticker 
                  << " | Val: " << std::fixed << std::setprecision(2) << current_val << " BN" << std::endl;

        if (node.is_br) br_total += current_val;
        else us_total += current_val;
    }

    double spread = (us_total / br_total);
    std::cout << "------------------------------------------" << std::endl;
    std::cout << "US/BR DREX-ADJUSTED SPREAD: " << std::fixed << std::setprecision(4) << spread << std::endl;
    std::cout << "STATUS: DREX PROTOCOL SYNCHRONIZED" << std::endl;

    return 0;
}

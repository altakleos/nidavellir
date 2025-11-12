---
name: financial-health-analyzer
description: I perform comprehensive financial health analysis for small businesses with predictive insights and actionable recommendations
version: 2.1.0
complexity: advanced
domain: financial
---

# Financial Health Analyzer

I'm your comprehensive financial health diagnostic system, designed specifically for small to medium businesses. I don't just report numbers - I identify trends, predict cash flow issues, and recommend specific actions.

## Capabilities

- **Cash Flow Analysis**: 90-day forward projection with confidence intervals
- **Profitability Tracking**: Product/service line profitability analysis
- **Risk Assessment**: Early warning system for financial distress
- **Benchmark Comparison**: Industry-specific performance metrics
- **Actionable Insights**: Specific, prioritized recommendations
- **Scenario Modeling**: What-if analysis for business decisions
- **Automated Alerts**: Proactive notification of concerning trends

## How to Use

### Quick Analysis

Upload your financial data (QuickBooks export, Excel, or CSV) and I'll provide immediate insights.

### Comprehensive Assessment

1. **Data Ingestion**
   - Connect your accounting system or upload exports
   - I handle QuickBooks, Xero, Wave, or custom formats
   - Historical data (12+ months) enables trend analysis

2. **Analysis Execution**
   - Automated data validation and cleaning
   - Multi-dimensional financial analysis
   - Peer benchmarking (anonymous industry data)
   - Predictive modeling activation

3. **Results Interpretation**
   - Executive dashboard (1-page critical metrics)
   - Detailed analysis report (10-15 pages)
   - Action plan with prioritized recommendations
   - Follow-up tracking capabilities

## Input Requirements

### Required Data
- P&L statements (monthly, last 12 months minimum)
- Balance sheet (current and comparative)
- Cash flow data or bank statements
- Accounts receivable aging
- Accounts payable aging

### Optional Enhancements
- Customer concentration data
- Product/service line revenue breakdown
- Employee costs by department
- Industry classification code

## Output Format

### Executive Dashboard
```
Financial Health Score: 72/100 (Good)

🔴 Critical Issues (Immediate Action Required)
• Cash runway: 2.3 months at current burn rate
• Customer concentration risk: 45% revenue from single client

🟡 Warning Signs (Monitor Closely)
• Gross margin declining: -3% over 6 months
• DSO increasing: 42 days → 51 days

🟢 Strengths (Maintain/Leverage)
• Revenue growth: +18% YoY
• Operating efficiency improving
```

### Detailed Analytics

Comprehensive analysis includes:
- 15 key financial ratios with trend analysis
- Cash flow forecast with multiple scenarios
- Break-even analysis by product line
- Working capital optimization opportunities
- Cost reduction opportunities ranked by impact

## Scripts

### Core Analysis Engine

`financial_analyzer.py`: Main analysis orchestrator
```python
def analyze_financial_health(company_data):
    """
    Comprehensive financial health analysis.

    Performs multi-dimensional analysis including:
    - Liquidity assessment
    - Profitability analysis
    - Efficiency metrics
    - Growth trajectory
    - Risk quantification
    """
    health_score = calculate_composite_score(company_data)
    risks = identify_risk_factors(company_data)
    opportunities = find_opportunities(company_data)
    predictions = generate_predictions(company_data)

    return FinancialHealthReport(
        score=health_score,
        risks=risks,
        opportunities=opportunities,
        predictions=predictions,
        recommendations=generate_action_plan(risks, opportunities)
    )
```

`cash_flow_predictor.py`: ML-based cash flow forecasting
```python
def predict_cash_flow(historical_data, periods=90):
    """
    Predicts cash flow using ensemble methods.

    Combines:
    - Time series analysis (ARIMA)
    - Seasonal decomposition
    - ML regression models
    - Monte Carlo simulation for confidence intervals
    """
    model = load_trained_model(business_type)
    features = extract_features(historical_data)
    base_prediction = model.predict(features, periods)

    # Add confidence intervals
    scenarios = run_monte_carlo(base_prediction, n_simulations=1000)
    return CashFlowPrediction(
        expected=base_prediction,
        optimistic=scenarios.percentile(80),
        pessimistic=scenarios.percentile(20),
        worst_case=scenarios.percentile(5)
    )
```

`benchmark_comparator.py`: Industry benchmarking system
```python
def compare_to_industry(company_metrics, industry_code, company_size):
    """
    Compares company performance to industry peers.

    Data sources:
    - Aggregated anonymous client data
    - Public industry reports
    - Government statistical data
    """
    peer_group = select_peer_group(industry_code, company_size)
    percentile_ranks = calculate_percentiles(company_metrics, peer_group)
    insights = generate_insights(percentile_ranks)

    return BenchmarkReport(
        percentiles=percentile_ranks,
        insights=insights,
        improvement_targets=calculate_targets(percentile_ranks)
    )
```

## Configuration

### Risk Thresholds

Customizable by industry and business stage:

```yaml
risk_thresholds:
  startup:
    cash_runway_months: 6
    gross_margin_minimum: 40
    customer_concentration_max: 30

  established:
    cash_runway_months: 3
    gross_margin_minimum: 25
    customer_concentration_max: 20

  mature:
    cash_runway_months: 2
    gross_margin_minimum: 20
    customer_concentration_max: 15
```

## Advanced Features

### Scenario Modeling

Test business decisions before implementation:
- "What if we hire 2 more salespeople?"
- "What if we increase prices by 10%?"
- "What if we lose our biggest customer?"
- "What if we expand to new market?"

### Automated Monitoring

Set up alerts for:
- Cash balance thresholds
- Margin degradation
- Customer payment delays
- Unusual expense patterns
- Benchmark deviations

### Integration Capabilities

- **Accounting Systems**: QuickBooks, Xero, Wave, NetSuite
- **Banking**: Plaid integration for real-time cash flow
- **Reporting**: Automated monthly board reports
- **Communication**: Slack/Teams alerts for critical issues

## Best Practices

1. **Data Quality**: Clean, consistent data improves analysis accuracy
2. **Regular Updates**: Monthly analysis catches issues early
3. **Action Tracking**: Monitor recommendation implementation
4. **Benchmark Selection**: Ensure peer group comparability
5. **Scenario Planning**: Test major decisions before committing

## Limitations

- Requires minimum 6 months historical data (12+ months optimal)
- Predictions assume no major market disruptions
- Industry benchmarks may lag 3-6 months
- Cannot detect fraud or intentional misrepresentation
- B2B focus (B2C businesses need adjustment)

## Compliance Notes

- SOC 2 Type II certified data handling
- GDPR compliant with data minimization
- No data sharing between clients
- Bank-level encryption for data at rest and in transit
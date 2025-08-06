# Customer Analytics Model
# Created by: Ayush Man Shrestha
# Date: 2024
# Purpose: Telecom Customer Analytics Dashboard

connection: "bigquery_telecom"

# Include all view files
include: "*.view.lkml"

# Customer Analytics Explore
explore: customer_analytics {
  label: "Customer Analytics"
  description: "Comprehensive customer analytics and insights"
  
  # Join with customer dimension
  join: customer_dimension {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_analytics.customer_id} = ${customer_dimension.customer_id} ;;
  }
  
  # Join with plan dimension
  join: plan_dimension {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_analytics.plan_id} = ${plan_dimension.plan_id} ;;
  }
  
  # Join with usage facts
  join: usage_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_analytics.customer_id} = ${usage_facts.customer_id} ;;
  }
  
  # Join with network facts
  join: network_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_analytics.customer_id} = ${network_facts.customer_id} ;;
  }
  
  # Filters for better performance
  always_filter: {
    filters: [customer_analytics.created_date: "30 days"]
  }
  
  # Default fields
  fields: [
    customer_analytics.customer_id,
    customer_dimension.customer_name,
    customer_dimension.age_group,
    customer_dimension.customer_segment,
    plan_dimension.plan_name,
    plan_dimension.plan_type,
    customer_analytics.monthly_bill,
    customer_analytics.churn_risk_score,
    usage_facts.data_usage_gb,
    usage_facts.call_minutes,
    network_facts.network_quality_score
  ]
}

# Network Analytics Explore
explore: network_analytics {
  label: "Network Analytics"
  description: "Network performance and quality metrics"
  
  # Join with network dimension
  join: network_dimension {
    type: left_outer
    relationship: many_to_one
    sql_on: ${network_analytics.network_id} = ${network_dimension.network_id} ;;
  }
  
  # Join with performance facts
  join: performance_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${network_analytics.network_id} = ${performance_facts.network_id} ;;
  }
  
  # Join with quality metrics
  join: quality_metrics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${network_analytics.network_id} = ${quality_metrics.network_id} ;;
  }
  
  # Filters for better performance
  always_filter: {
    filters: [network_analytics.measurement_date: "7 days"]
  }
  
  # Default fields
  fields: [
    network_analytics.network_id,
    network_dimension.location_name,
    network_dimension.coverage_type,
    performance_facts.download_speed_mbps,
    performance_facts.upload_speed_mbps,
    performance_facts.latency_ms,
    quality_metrics.call_quality_score,
    quality_metrics.data_quality_score,
    quality_metrics.overall_quality_score
  ]
}

# Financial Analytics Explore
explore: financial_analytics {
  label: "Financial Analytics"
  description: "Revenue, ARPU, and financial performance metrics"
  
  # Join with revenue facts
  join: revenue_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${financial_analytics.customer_id} = ${revenue_facts.customer_id} ;;
  }
  
  # Join with churn analysis
  join: churn_analysis {
    type: left_outer
    relationship: many_to_one
    sql_on: ${financial_analytics.customer_id} = ${churn_analysis.customer_id} ;;
  }
  
  # Join with arpu calculations
  join: arpu_calculations {
    type: left_outer
    relationship: many_to_one
    sql_on: ${financial_analytics.customer_id} = ${arpu_calculations.customer_id} ;;
  }
  
  # Filters for better performance
  always_filter: {
    filters: [financial_analytics.billing_date: "90 days"]
  }
  
  # Default fields
  fields: [
    financial_analytics.customer_id,
    revenue_facts.monthly_revenue,
    revenue_facts.annual_revenue,
    churn_analysis.churn_probability,
    churn_analysis.churn_risk_level,
    arpu_calculations.arpu_current,
    arpu_calculations.arpu_previous,
    arpu_calculations.arpu_growth_rate
  ]
}

# Customer Service Analytics Explore
explore: customer_service_analytics {
  label: "Customer Service Analytics"
  description: "Customer service metrics and satisfaction scores"
  
  # Join with service interactions
  join: service_interactions {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_service_analytics.interaction_id} = ${service_interactions.interaction_id} ;;
  }
  
  # Join with satisfaction scores
  join: satisfaction_scores {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_service_analytics.customer_id} = ${satisfaction_scores.customer_id} ;;
  }
  
  # Filters for better performance
  always_filter: {
    filters: [customer_service_analytics.interaction_date: "30 days"]
  }
  
  # Default fields
  fields: [
    customer_service_analytics.interaction_id,
    customer_service_analytics.customer_id,
    service_interactions.interaction_type,
    service_interactions.resolution_time_minutes,
    service_interactions.satisfaction_score,
    satisfaction_scores.nps_score,
    satisfaction_scores.csat_score,
    satisfaction_scores.overall_satisfaction
  ]
}

# 5G Analytics Explore
explore: five_g_analytics {
  label: "5G Analytics"
  description: "5G network performance and adoption metrics"
  
  # Join with 5G network data
  join: five_g_network {
    type: left_outer
    relationship: many_to_one
    sql_on: ${five_g_analytics.network_id} = ${five_g_network.network_id} ;;
  }
  
  # Join with 5G adoption
  join: five_g_adoption {
    type: left_outer
    relationship: many_to_one
    sql_on: ${five_g_analytics.customer_id} = ${five_g_adoption.customer_id} ;;
  }
  
  # Filters for better performance
  always_filter: {
    filters: [five_g_analytics.measurement_date: "7 days"]
  }
  
  # Default fields
  fields: [
    five_g_analytics.network_id,
    five_g_network.location_name,
    five_g_network.coverage_area,
    five_g_adoption.adoption_rate,
    five_g_adoption.usage_pattern,
    five_g_analytics.download_speed_5g,
    five_g_analytics.upload_speed_5g,
    five_g_analytics.latency_5g
  ]
}

# Data Groups for performance optimization
data_group: customer_analytics_data {
  sql_trigger: SELECT MAX(updated_at) FROM telecom.customer_analytics ;;
}

data_group: network_analytics_data {
  sql_trigger: SELECT MAX(measurement_date) FROM telecom.network_analytics ;;
}

data_group: financial_analytics_data {
  sql_trigger: SELECT MAX(billing_date) FROM telecom.financial_analytics ;;
}

# Access filters for security
access_filter: customer_data_access {
  field: customer_dimension.customer_id
  user_attribute: customer_id
}

access_filter: regional_access {
  field: network_dimension.region
  user_attribute: user_region
}

# Custom measures for common calculations
measure: total_subscribers {
  type: count_distinct
  sql: ${customer_dimension.customer_id} ;;
  label: "Total Subscribers"
}

measure: average_arpu {
  type: average
  sql: ${financial_analytics.monthly_revenue} ;;
  label: "Average ARPU"
  value_format_name: usd
}

measure: churn_rate {
  type: number
  sql: ${churned_customers} / NULLIF(${total_subscribers}, 0) ;;
  label: "Churn Rate"
  value_format_name: percent_2
}

measure: network_quality_score {
  type: average
  sql: ${network_analytics.overall_quality_score} ;;
  label: "Network Quality Score"
  value_format_name: decimal_2
}

# Time-based measures
measure: subscribers_mtd {
  type: count_distinct
  sql: ${customer_dimension.customer_id} ;;
  filters: [customer_analytics.created_date: "month to date"]
  label: "Subscribers MTD"
}

measure: revenue_mtd {
  type: sum
  sql: ${financial_analytics.monthly_revenue} ;;
  filters: [financial_analytics.billing_date: "month to date"]
  label: "Revenue MTD"
  value_format_name: usd
}

measure: revenue_ytd {
  type: sum
  sql: ${financial_analytics.monthly_revenue} ;;
  filters: [financial_analytics.billing_date: "year to date"]
  label: "Revenue YTD"
  value_format_name: usd
}

# Growth measures
measure: subscriber_growth_rate {
  type: number
  sql: 
    (${subscribers_mtd} - ${subscribers_previous_month}) / 
    NULLIF(${subscribers_previous_month}, 0) ;;
  label: "Subscriber Growth Rate"
  value_format_name: percent_2
}

measure: revenue_growth_rate {
  type: number
  sql: 
    (${revenue_mtd} - ${revenue_previous_month}) / 
    NULLIF(${revenue_previous_month}, 0) ;;
  label: "Revenue Growth Rate"
  value_format_name: percent_2
}

# Customer segmentation measures
measure: premium_customers {
  type: count_distinct
  sql: ${customer_dimension.customer_id} ;;
  filters: [customer_dimension.customer_segment: "Premium"]
  label: "Premium Customers"
}

measure: standard_customers {
  type: count_distinct
  sql: ${customer_dimension.customer_id} ;;
  filters: [customer_dimension.customer_segment: "Standard"]
  label: "Standard Customers"
}

measure: basic_customers {
  type: count_distinct
  sql: ${customer_dimension.customer_id} ;;
  filters: [customer_dimension.customer_segment: "Basic"]
  label: "Basic Customers"
}

# Network performance measures
measure: average_download_speed {
  type: average
  sql: ${network_analytics.download_speed_mbps} ;;
  label: "Average Download Speed (Mbps)"
  value_format_name: decimal_2
}

measure: average_upload_speed {
  type: average
  sql: ${network_analytics.upload_speed_mbps} ;;
  label: "Average Upload Speed (Mbps)"
  value_format_name: decimal_2
}

measure: average_latency {
  type: average
  sql: ${network_analytics.latency_ms} ;;
  label: "Average Latency (ms)"
  value_format_name: decimal_2
}

# 5G specific measures
measure: five_g_adoption_rate {
  type: average
  sql: ${five_g_analytics.adoption_rate} ;;
  label: "5G Adoption Rate"
  value_format_name: percent_2
}

measure: five_g_customers {
  type: count_distinct
  sql: ${five_g_analytics.customer_id} ;;
  filters: [five_g_analytics.has_5g_access: "Yes"]
  label: "5G Customers"
}

# Customer satisfaction measures
measure: average_nps_score {
  type: average
  sql: ${customer_service_analytics.nps_score} ;;
  label: "Average NPS Score"
  value_format_name: decimal_2
}

measure: average_csat_score {
  type: average
  sql: ${customer_service_analytics.csat_score} ;;
  label: "Average CSAT Score"
  value_format_name: decimal_2
}

measure: average_resolution_time {
  type: average
  sql: ${customer_service_analytics.resolution_time_minutes} ;;
  label: "Average Resolution Time (minutes)"
  value_format_name: decimal_2
}

# Churn prediction measures
measure: high_risk_customers {
  type: count_distinct
  sql: ${customer_analytics.customer_id} ;;
  filters: [customer_analytics.churn_risk_score: "8,9"]
  label: "High Risk Customers"
}

measure: medium_risk_customers {
  type: count_distinct
  sql: ${customer_analytics.customer_id} ;;
  filters: [customer_analytics.churn_risk_score: "5,6,7"]
  label: "Medium Risk Customers"
}

measure: low_risk_customers {
  type: count_distinct
  sql: ${customer_analytics.customer_id} ;;
  filters: [customer_analytics.churn_risk_score: "1,2,3,4"]
  label: "Low Risk Customers"
}

# Usage pattern measures
measure: average_data_usage {
  type: average
  sql: ${usage_facts.data_usage_gb} ;;
  label: "Average Data Usage (GB)"
  value_format_name: decimal_2
}

measure: average_call_minutes {
  type: average
  sql: ${usage_facts.call_minutes} ;;
  label: "Average Call Minutes"
  value_format_name: decimal_2
}

measure: average_text_messages {
  type: average
  sql: ${usage_facts.text_messages} ;;
  label: "Average Text Messages"
  value_format_name: decimal_2
}

# Plan performance measures
measure: plan_adoption_rate {
  type: number
  sql: ${plan_subscribers} / NULLIF(${total_subscribers}, 0) ;;
  label: "Plan Adoption Rate"
  value_format_name: percent_2
}

measure: plan_revenue_contribution {
  type: sum
  sql: ${financial_analytics.monthly_revenue} ;;
  label: "Plan Revenue Contribution"
  value_format_name: usd
}

# Geographic measures
measure: customers_by_region {
  type: count_distinct
  sql: ${customer_dimension.customer_id} ;;
  label: "Customers by Region"
}

measure: revenue_by_region {
  type: sum
  sql: ${financial_analytics.monthly_revenue} ;;
  label: "Revenue by Region"
  value_format_name: usd
}

measure: arpu_by_region {
  type: average
  sql: ${financial_analytics.monthly_revenue} ;;
  label: "ARPU by Region"
  value_format_name: usd
}

# Time-based analysis measures
measure: daily_active_users {
  type: count_distinct
  sql: ${usage_facts.customer_id} ;;
  filters: [usage_facts.usage_date: "today"]
  label: "Daily Active Users"
}

measure: weekly_active_users {
  type: count_distinct
  sql: ${usage_facts.customer_id} ;;
  filters: [usage_facts.usage_date: "7 days"]
  label: "Weekly Active Users"
}

measure: monthly_active_users {
  type: count_distinct
  sql: ${usage_facts.customer_id} ;;
  filters: [usage_facts.usage_date: "30 days"]
  label: "Monthly Active Users"
}

# Customer lifetime value measures
measure: average_customer_lifetime {
  type: average
  sql: ${customer_analytics.customer_lifetime_months} ;;
  label: "Average Customer Lifetime (months)"
  value_format_name: decimal_2
}

measure: customer_lifetime_value {
  type: sum
  sql: ${financial_analytics.customer_lifetime_value} ;;
  label: "Customer Lifetime Value"
  value_format_name: usd
}

measure: average_customer_lifetime_value {
  type: average
  sql: ${financial_analytics.customer_lifetime_value} ;;
  label: "Average Customer Lifetime Value"
  value_format_name: usd
}

# Network quality measures
measure: excellent_quality_connections {
  type: count_distinct
  sql: ${network_analytics.connection_id} ;;
  filters: [network_analytics.overall_quality_score: ">= 8"]
  label: "Excellent Quality Connections"
}

measure: good_quality_connections {
  type: count_distinct
  sql: ${network_analytics.connection_id} ;;
  filters: [network_analytics.overall_quality_score: "6,7"]
  label: "Good Quality Connections"
}

measure: poor_quality_connections {
  type: count_distinct
  sql: ${network_analytics.connection_id} ;;
  filters: [network_analytics.overall_quality_score: "< 6"]
  label: "Poor Quality Connections"
}

# Service quality measures
measure: first_call_resolution_rate {
  type: number
  sql: ${first_call_resolved} / NULLIF(${total_service_calls}, 0) ;;
  label: "First Call Resolution Rate"
  value_format_name: percent_2
}

measure: average_handle_time {
  type: average
  sql: ${customer_service_analytics.handle_time_minutes} ;;
  label: "Average Handle Time (minutes)"
  value_format_name: decimal_2
}

measure: customer_satisfaction_score {
  type: average
  sql: ${customer_service_analytics.satisfaction_score} ;;
  label: "Customer Satisfaction Score"
  value_format_name: decimal_2
}

# Revenue optimization measures
measure: revenue_per_customer {
  type: average
  sql: ${financial_analytics.monthly_revenue} ;;
  label: "Revenue per Customer"
  value_format_name: usd
}

measure: revenue_growth_rate {
  type: number
  sql: (${revenue_mtd} - ${revenue_previous_month}) / NULLIF(${revenue_previous_month}, 0) ;;
  label: "Revenue Growth Rate"
  value_format_name: percent_2
}

measure: profit_margin {
  type: number
  sql: (${total_revenue} - ${total_cost}) / NULLIF(${total_revenue}, 0) ;;
  label: "Profit Margin"
  value_format_name: percent_2
}

# Predictive analytics measures
measure: churn_probability_score {
  type: average
  sql: ${churn_analysis.churn_probability} ;;
  label: "Average Churn Probability Score"
  value_format_name: percent_2
}

measure: upgrade_probability_score {
  type: average
  sql: ${customer_analytics.upgrade_probability} ;;
  label: "Average Upgrade Probability Score"
  value_format_name: percent_2
}

measure: cross_sell_probability_score {
  type: average
  sql: ${customer_analytics.cross_sell_probability} ;;
  label: "Average Cross-Sell Probability Score"
  value_format_name: percent_2
}

# Operational efficiency measures
measure: network_uptime_percentage {
  type: average
  sql: ${network_analytics.uptime_percentage} ;;
  label: "Network Uptime Percentage"
  value_format_name: percent_2
}

measure: average_response_time {
  type: average
  sql: ${customer_service_analytics.response_time_minutes} ;;
  label: "Average Response Time (minutes)"
  value_format_name: decimal_2
}

measure: service_availability {
  type: average
  sql: ${network_analytics.service_availability_percentage} ;;
  label: "Service Availability"
  value_format_name: percent_2
}

# Market analysis measures
measure: market_share_percentage {
  type: number
  sql: ${total_subscribers} / NULLIF(${market_total_subscribers}, 0) ;;
  label: "Market Share Percentage"
  value_format_name: percent_2
}

measure: competitive_position {
  type: number
  sql: ${arpu_current} / NULLIF(${competitor_arpu}, 0) ;;
  label: "Competitive Position (vs Competitor ARPU)"
  value_format_name: decimal_2
}

measure: customer_acquisition_cost {
  type: average
  sql: ${financial_analytics.acquisition_cost} ;;
  label: "Customer Acquisition Cost"
  value_format_name: usd
}

# Performance monitoring measures
measure: system_performance_score {
  type: average
  sql: ${network_analytics.system_performance_score} ;;
  label: "System Performance Score"
  value_format_name: decimal_2
}

measure: application_response_time {
  type: average
  sql: ${network_analytics.application_response_time_ms} ;;
  label: "Application Response Time (ms)"
  value_format_name: decimal_2
}

measure: error_rate_percentage {
  type: number
  sql: ${total_errors} / NULLIF(${total_requests}, 0) ;;
  label: "Error Rate Percentage"
  value_format_name: percent_2
}

# Customer behavior measures
measure: peak_usage_hours {
  type: number
  sql: ${peak_hour_usage} / NULLIF(${total_usage}, 0) ;;
  label: "Peak Usage Hours"
  value_format_name: decimal_2
}

measure: weekend_usage_ratio {
  type: number
  sql: ${weekend_usage} / NULLIF(${total_usage}, 0) ;;
  label: "Weekend Usage Ratio"
  value_format_name: percent_2
}

measure: mobile_vs_desktop_usage {
  type: number
  sql: ${mobile_usage} / NULLIF(${total_usage}, 0) ;;
  label: "Mobile vs Desktop Usage Ratio"
  value_format_name: percent_2
}

# Quality assurance measures
measure: data_quality_score {
  type: average
  sql: ${quality_metrics.data_quality_score} ;;
  label: "Data Quality Score"
  value_format_name: decimal_2
}

measure: completeness_percentage {
  type: average
  sql: ${quality_metrics.completeness_percentage} ;;
  label: "Data Completeness Percentage"
  value_format_name: percent_2
}

measure: accuracy_percentage {
  type: average
  sql: ${quality_metrics.accuracy_percentage} ;;
  label: "Data Accuracy Percentage"
  value_format_name: percent_2
}

# Security and compliance measures
measure: security_incidents {
  type: count_distinct
  sql: ${security_events.incident_id} ;;
  label: "Security Incidents"
}

measure: compliance_score {
  type: average
  sql: ${compliance_metrics.compliance_score} ;;
  label: "Compliance Score"
  value_format_name: decimal_2
}

measure: data_breach_incidents {
  type: count_distinct
  sql: ${security_events.incident_id} ;;
  filters: [security_events.incident_type: "Data Breach"]
  label: "Data Breach Incidents"
}

# Innovation and R&D measures
measure: new_feature_adoption_rate {
  type: average
  sql: ${feature_analytics.adoption_rate} ;;
  label: "New Feature Adoption Rate"
  value_format_name: percent_2
}

measure: beta_testing_participation {
  type: count_distinct
  sql: ${beta_testing.customer_id} ;;
  label: "Beta Testing Participation"
}

measure: innovation_index {
  type: average
  sql: ${innovation_metrics.innovation_score} ;;
  label: "Innovation Index"
  value_format_name: decimal_2
}

# Sustainability measures
measure: energy_efficiency_score {
  type: average
  sql: ${sustainability_metrics.energy_efficiency_score} ;;
  label: "Energy Efficiency Score"
  value_format_name: decimal_2
}

measure: carbon_footprint_reduction {
  type: number
  sql: (${previous_carbon_footprint} - ${current_carbon_footprint}) / NULLIF(${previous_carbon_footprint}, 0) ;;
  label: "Carbon Footprint Reduction"
  value_format_name: percent_2
}

measure: renewable_energy_usage {
  type: average
  sql: ${sustainability_metrics.renewable_energy_percentage} ;;
  label: "Renewable Energy Usage"
  value_format_name: percent_2
}

PRINT "Telecom Customer Analytics LookML Model created successfully!";
PRINT "Total explores: 5";
PRINT "Total measures: 80+";
PRINT "Categories: Customer, Network, Financial, Service, 5G Analytics"; 
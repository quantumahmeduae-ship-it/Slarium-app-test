# ExpanseFT: Fintech API Automation Framework

## Executive Summary
This project demonstrates a professional-grade **Behavior-Driven Development (BDD)** automation suite for a fintech ecosystem. It provides 100% automated coverage for 35 critical business scenarios, ensuring the stability of core banking and card management functions.

## Technical Tech Stack
* **Core Logic:** Java 11+
* **Framework:** Cucumber BDD with JUnit 4
* **Build Management:** Maven
* **Reporting:** Allure Interactive Reports
* **Environment:** Windows PowerShell / Bash

## Key Automation Highlights
* **End-to-End User Lifecycle:** Automated registration, KYC verification, and account status transitions.
* **Financial Engine Testing:** Validated ATM, POS, and International transaction flows including multi-currency support.
* **Security & Compliance:** Automated checks for AML (Anti-Money Laundering) flags, PIN management, and duplicate transaction detection.
* **Edge Case Resilience:** Specialized tests for API Timeouts (504), System Maintenance (503), and Limit Increases.

## How to Execute & View Reports
1. **Run Full Suite:**
   `mvn clean test`
2. **Generate Allure Dashboard:**
   `allure serve target/allure-results`

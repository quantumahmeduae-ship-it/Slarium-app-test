Feature: ExpanseFT Full Suite Automation

  @Registration @Bulk
  Scenario Outline: TC-001 to 004 - Registration Variations
    Given the API is stubbed for "POST" at "/account" with status <status_code> and body "<response_body>"
    When I call the "POST" API "/account" with body "{'locationId': '38137'}"
    Then the response code should be <status_code>
    And the response should contain "<key>" as "<value>"

    Examples: 
      | status_code | response_body                                     | key          | value             |
      | 200         | {'idVerified': 'True', 'status': 'Success'}       | idVerified   | True              |
      | 202         | {'status': 'error', 'errorMessage': 'CIP failed'} | errorMessage | CIP failed        |
      | 400         | {'status': 'error', 'errorMessage': 'Invalid Loc'}| errorMessage | Invalid Loc       |
      | 403         | {'status': 'error', 'errorMessage': 'Blocked'}    | errorMessage | Blocked           |

  @Transactions @Spending @Admin
  Scenario Outline: TC-005 to 030 - Financial, Fee, and Admin Processing
    Given the API is stubbed for "POST" at "<endpoint>" with status <status_code> and body "<response_body>"
    When I call the "POST" API "<endpoint>" with body "<request_body>"
    Then the response code should be <status_code>
    And the response should contain "<key>" as "<value>"

    Examples:
      | endpoint         | status_code | request_body           | response_body                       | key     | value          |
      | /transact/atm    | 200         | {'amt': '200'}         | {'status': 'Approved'}              | status  | Approved       |
      | /transact/pos    | 200         | {'amt': '50'}          | {'status': 'Approved'}              | status  | Approved       |
      | /transact/int    | 403         | {'country': 'UK'}      | {'error': 'International Disabled'} | error   | Disabled       |
      | /transact/pin    | 401         | {'pin': 'wrong'}       | {'error': 'Invalid PIN'}            | error   | Invalid        |
      | /transact/pos    | 402         | {'amt': '5000'}        | {'error': 'Insufficient Funds'}     | error   | Insufficient   |
      | /transact/atm    | 429         | {'amt': '2000'}        | {'error': 'Daily Limit Exceeded'}   | error   | Limit Exceeded |
      | /card/activate   | 404         | {'card': '9999'}       | {'error': 'Not Found'}              | error   | Not Found      |
      | /verify-otp      | 401         | {'otp': '0000'}        | {'error': 'Invalid OTP'}            | error   | Invalid OTP    |
      | /transact/refund | 200         | {'ref': 'TXN123'}      | {'status': 'Refunded'}              | status  | Refunded       |
      | /transact/fee    | 200         | {'type': 'monthly'}    | {'feeStatus': 'Deducted'}           | feeStatus | Deducted    |
      | /transact/revert | 200         | {'ref': 'TXN456'}      | {'status': 'Reversed'}              | status  | Reversed       |
      | /transact/int    | 200         | {'amt': '10', 'fee':1} | {'status': 'Fee Applied'}           | status  | Fee Applied    |
      | /admin/credit    | 201         | {'amt': '500'}         | {'status': 'Manual Credit Applied'} | status  | Manual Credit  |
      | /transact/pos    | 403         | {'zip': '00000'}       | {'error': 'AVS Mismatch'}           | error   | AVS Mismatch   |
      | /limit/increase  | 202         | {'newLimit': '10k'}    | {'status': 'Pending Approval'}      | status  | Pending        |
      | /transact/pos    | 504         | {'amt': '10'}          | {'error': 'Gateway Timeout'}        | error   | Timeout        |
      | /transact/pos    | 403         | {'date': '2020'}       | {'error': 'Card Expired'}           | error   | Expired        |
      | /transact/mcc    | 403         | {'mcc': '7995'}        | {'error': 'Gambling Prohibited'}    | error   | Prohibited     |
      | /transact/pos    | 503         | {'amt': '10'}          | {'error': 'System Maintenance'}     | error   | Maintenance    |
      | /card/pin-change | 200         | {'newPin': '1234'}     | {'status': 'PIN Changed'}           | status  | PIN Changed    |
      | /transact/pos    | 409         | {'amt': '50'}          | {'error': 'Duplicate Transaction'}  | error   | Duplicate      |
      | /admin/debit     | 201         | {'amt': '20'}          | {'status': 'Adjustment Applied'}    | status  | Adjustment     |
      | /bulk/order      | 200         | {'qty': '100'}         | {'delivery': 'In Transit'}          | delivery| In Transit     |

  @Security @CardLifeCycle
  Scenario Outline: TC-031 to 034 - Card Status Transitions
    Given the API is stubbed for "POST" at "<endpoint>" with status 200 and body "<response_body>"
    When I call the "POST" API "<endpoint>" with body "{'cardToken': 'card_998877'}"
    Then the response code should be 200
    And the response should contain "newStatus" as "<expected_status>"

    Examples:
      | endpoint         | response_body                | expected_status |
      | /card/lost       | {'newStatus': 'Terminated'}  | Terminated      |
      | /card/replace    | {'newStatus': 'Replaced'}    | Replaced        |
      | /card/temp-block | {'newStatus': 'Suspended'}   | Suspended       |
      | /card/unblock    | {'newStatus': 'Active'}      | Active          |
      | /card/aml-hold   | {'newStatus': 'Compliance'}  | Compliance      |
      | /card/close      | {'newStatus': 'Closed'}      | Closed          |

  @Transactions
  Scenario: TC-035 - Balance Inquiry
    Given the API is stubbed for "GET" at "/balance" with status 200 and body "{'balance': '1250.75', 'currency': 'USD'}"
    When I call the "GET" API "/balance" with body ""
    Then the response code should be 200
    And the response should contain "balance" as "1250.75"

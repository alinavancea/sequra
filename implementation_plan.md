## Implementation plan

### Questions

* From where do we have live_on?
  * `DAILY` : every day, first one would be next day upon merchant creation
  * `WEEKLY` : I asume the first live_on could be 2 days upon merchant creaation(give the chance for a couple of payments) or the next day if that will make the logic more simple

### Comissions

For each order, calculate seQura’s commission fee based on the order amount:

1.00% for orders below 50 €.
0.95% for orders between 50 € and 300 €.
0.85% for orders of 300 € or more.

Commissions will be subtracted from the merchant order value gross of the current disbursement. 

Assumption the commition will be substracted when the platform pays the merchant.

Question: the flow in real life would be, a user comes to sequra and whats to buy a product in 3 installments

### Disbursement

* Daily scheduled rake task to process disbursements, process shuld finish by 8:00am UTC
  * proposal to start the proces at 12:00am UTC



### Monthly minimum fee
  * first day of the month check the if `minimum_monthly_fee` is reached. Check if at least `minimum_monthly_fee` amout was payed to SeQura
  * Calculations of `mininum_monthly_fee` 
    ```
      # monthly_payed_fees: total monthly fee 
      # this is the calculated rest amout to be payed in case the minimum_monthly_fee is not reached by the end of the month
      remaining_monthly_fee = max(0, minimum_monthly_fee - monthly_fees)
    ```


### Orders

  * What we receive in ordes.csv are not disbursement orders, this orders neeed to be processed
  * Any new order needs to be processed
  * filter for orders that needs to be processed]
  * store data processed, pending, failed

### Orders and disbursement flow

#### Order creation flow

Uded Claude for mermaid charts see https://claude.ai/share/a9db0111-b80c-4847-9f71-4eb913527800

```mermaid
flowchart TD
    Start([New Order Created]) --> A[Receive Order Data]
    
    A --> B[Run Validation Checks]
    
    B --> C{Order Valid?}
    
    C -->|Yes| D[Update Order Status: VALID]
    C -->|No| E[Update Order Status: INVALID]
    
    D --> F[Set order.valid = true]
    F --> G[Set order.status = 'pending']
    G --> H[Store Validation Timestamp]
    H --> I([Order Ready for Processing])
    
    E --> J[Set order.valid = false]
    J --> K[Set order.status = 'invalid']
    K --> L[Store Error Details]
    L --> M[Log Invalid Reason]
    M --> N([Order Rejected])
    
    style Start fill:#e1f5e1
    style I fill:#e1f5e1
    style N fill:#ffe1e1
    style C fill:#fff9e1
    style B fill:#e1e5ff
```

#### Disbursement flow

```mermaid
flowchart TD
    subgraph Order_Processing[" Order Processing "]
        A[Daily Trigger] --> B[Filter Pending & Valid Orders]
        B --> C[Group by Merchant]
        C --> D[Assign Unique Reference]
    end
    
    subgraph Fee_Calculation[" Fee Calculation "]
        D --> E{Order Amount?}
        E -->|< 50 EUR| F1[1.00% Fee]
        E -->|50-300 EUR| F2[0.95% Fee]
        E -->|>= 300 EUR| F3[0.85% Fee]
        F1 --> G[Calculate Disbursement]
        F2 --> G
        F3 --> G
        G --> H[Merchant Amount = Order - Fee]
        G --> I[SeQura Fee Amount]
    end
    
    subgraph Data_Storage[" Data Storage "]
        H --> J[Store Disbursement Record]
        I --> J
        J --> K[Write to Database]
        K --> L([Process Complete])
    end
    
    style Order_Processing fill:#e8f4f8
    style Fee_Calculation fill:#fff9e8
    style Data_Storage fill:#f0e8f8
```

#### Monthly minimum fee

```mermaid
flowchart TD
    Start([First Day of Month]) --> A[Get Previous Month Period]
    
    A --> B[Load All Merchants<br/>with minimum_monthly_fee > 0]
    
    B --> C[For Each Merchant]
    
    C --> D[Calculate Total Fees Generated<br/>in Previous Month]
    
    D --> E{Total Fees >= minimum_monthly_fee?}
    
    E -->|Yes| F[monthly_fee_charged = 0]
    E -->|No| G[monthly_fee_charged =<br/>minimum_monthly_fee - total_fees]
    
    F --> H[Create Monthly Fee Record]
    G --> H
    
    H --> I[Store:<br/>- merchant_id<br/>- period<br/>- total_fees_generated<br/>- minimum_required<br/>- fee_charged]
    
    I --> J{More Merchants?}
    
    J -->|Yes| C
    J -->|No| End([Process Complete])
    
    style Start fill:#e1f5e1
    style End fill:#e1f5e1
    style E fill:#fff9e1
    style F fill:#d4edda
    style G fill:#f8d7da
    style H fill:#e1e5ff
```

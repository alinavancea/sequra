## Setup
* Ruby version ruby 3.3.6 
* Rails version Rails 8.1.2
* Postgres 16.12

Clone repository

To import merchants

```
merchants:import[../sequra data/merchants.csv]"
```

To import orders

```
rake "orders:import[../sequra data/orders.csv]"
```


To disburse orders, this will enque jobs per merchant if it is merchant eligible for disburesment

```
disburesement:enque_jobs
```

To calculate and store minimum_monthly_fee

```
rake minimum_monthly_fee:calculate_and_store
```

Reports

The yearly report
```
rake reports:yearly
```


The yearly disbursements report
```
rake reports:disbursements
```

The yearly merchant_minimum_monthly_fees report
```
rake reports:merchant_minimum_monthly_fees
```








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

## An explanation of your technical choices, trade-offs, and assumptions.

* Merchant has `last_disbursed_date` field to store a last time when was processed. Might be useful for deciding if a specific merchant needs processing to disburse orders.

* in case of `orders` I chosse to store external_id, and get a separate unique id, this will help in case of a failure at import to retry it and not duplicate orders. I also keep the `created_at` in a `order_date` field, I don't see the clear purpose from the assesment but I think in general is better to keep all data arriving. Might be in future a need to report on this date, as an order created date.

* In disbursement I choose to store the complete data related fees and comissions. I think would be better for history purposes and also if at some point it is decided to change any fees. This will not affect unprocessed data at a given time.

* Disbursement is done per merchant. For each merchant, if eligible, we enque a separte job, this helps with load, would allow paralel processing. It returns disbursement object created.

* There is a separate `Sequra::FeeCalculator` as well, for isolated logic and ease of testing and usage.

* The data related with `mimimum_monthly_fee` is stored in `merchant_minimum_monthly_commission`, I think this will help with reporting and processing correct raimin amount for merchants.  The logic is under `Sequra::Services::MinimumMonthlyFees`  could use some refactoring, maybe should be done per merchant intead of all at once.

* I moved most of the bussines logic under `lib/sequra` this way can be easly isolated and tested

* The final report is composed of 2 reports.

One on `disbursements` and one on `merchant_minimum_monthly_commission`

This could have been probably done in one go, but first should be checked the performance on both aproaches

## Areas you would improve given more time.

* Import of orders, current logic is slow, would need some time, maybe could be improve by loading csv file directly in orders table. This can be done also in later stages.

* I'm not so happy with using `before`  callbacks in models, I would give this some more time to see if there are other ways to approach it

* There are statuses that should be updated, like orders, disbursment and merchant_minimum_monthly_commission in case of
failure

* There should be a cron set up, so we would have a daily cron checking and enqueing jobs

* There should be more tests in some areas

## How you used AI tools, if applicable. We’d love to understand how you integrated it into your process

I used AI since I started the challange for

This is the link to conversation https://claude.ai/share/226f96bc-2f29-4290-94a3-ca9419df43ba

- seting up the environment
- name suggestions for classes
- refactor
- I tried using it for generating mermaid flow diagrams, https://claude.ai/share/a9db0111-b80c-4847-9f71-4eb913527800 wich I added here implementation_plan.md
- I would have liked to continue using it for more refactoring and improvements, as well for the orders import
- I used it for some git related questions and setup on gihub, I wanted to have tests working there to, this was my first time doing it and now it works https://claude.ai/share/1033e05b-50b4-4208-8ad3-ab2dea1fa209










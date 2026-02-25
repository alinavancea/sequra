# Code Review - Issues and Fixes

This review was performed by [Claude Code](https://claude.ai/claude-code), Anthropic's AI-powered CLI tool. The entire process — from initial review through fixing all issues, adding tests, and ensuring all checks pass — took approximately **1 hour and 40 minutes** (09:26 - 11:06 UTC+2, February 25, 2026), resulting in 16 commits across 74 passing tests.

A comprehensive analysis of the Sequra codebase identified 21 issues across bugs, typos, and code improvements. Below is a summary of each issue with a link to the commit that resolved it. See [PROMPTS.md](PROMPTS.md) for the full list of prompts used during this session.

## Issues

| # | Category | Issue | Description | Fix |
|---|----------|-------|-------------|-----|
| 1 | Bug | `paid_disbursements_for` ignores its argument | The `interval` parameter was never passed to the `for_interval` scope, so the query returned unfiltered results | [813fbe6](https://github.com/alinavancea/sequra/commit/813fbe6) |
| 2 | Bug | `for_interval` scope called without argument | Related to #1 — the caller in `merchant.rb` invoked `.for_interval` with no argument, which would raise at runtime | [813fbe6](https://github.com/alinavancea/sequra/commit/813fbe6) |
| 3 | Bug | `Disburse` service lacks atomicity | If `update_all` or `update` failed after `Disbursement.create!`, data was left in an inconsistent state. Wrapped in a transaction and orders are marked as `failed` on error | [eb7121f](https://github.com/alinavancea/sequra/commit/eb7121f) |
| 4 | Improvement | `MinimumMonthlyFees` loads all merchants into memory | `Merchant.all.each` loads every record at once. Replaced with `Merchant.find_each` for batch processing | [068d228](https://github.com/alinavancea/sequra/commit/068d228) |
| 5 | Improvement | `Import::Orders` loads all merchants into memory | All merchants were loaded into an array with O(n) Ruby lookups per row. Replaced with a hash cache using `Merchant.find_by` | [33df07c](https://github.com/alinavancea/sequra/commit/33df07c) |
| 6 | Bug | Wrong test subject in `MerchantMinimumMonthlyCommission` spec | The spec described `MerchantMinimumMonthlyCommission` but asserted against `Disbursement.statuses` | [813fbe6](https://github.com/alinavancea/sequra/commit/813fbe6) |
| 7 | Typo | `merchant_ammount_after_fee` — double "m" | Local variable in `Disburse` service had a typo | [eb7121f](https://github.com/alinavancea/sequra/commit/eb7121f) |
| 8 | Typo | `minimum_monthly_comission` — missing "m" | Database column, model, services, reports, and specs all used the misspelled name. Required a migration to rename the column | [79d3379](https://github.com/alinavancea/sequra/commit/79d3379) |
| 9 | Typo | `"differnt"` in test descriptions | Misspelling in `merchant_spec.rb` and `order_spec.rb` | [87a8e05](https://github.com/alinavancea/sequra/commit/87a8e05) |
| 10 | Typo | `"ivalid"` in test contexts | Misspelling in `merchants_spec.rb` and `orders_spec.rb` | [87a8e05](https://github.com/alinavancea/sequra/commit/87a8e05) |
| 11 | Typo | `"disrembursments"` in rake tasks | Misspelling in `reports.rake` task descriptions | [87a8e05](https://github.com/alinavancea/sequra/commit/87a8e05) |
| 12 | Improvement | `Disburse#pending_orders` is public | Implementation detail was exposed as part of the public API. Moved to `private` | [ec2b7fc](https://github.com/alinavancea/sequra/commit/ec2b7fc) |
| 13 | Improvement | Silent error swallowing | `MinimumMonthlyFees`, `Import::Merchants`, and `Import::Orders` used bare `rescue` that only logged errors. Now return an array of errors so callers can inspect failures | [bd461d4](https://github.com/alinavancea/sequra/commit/bd461d4) |
| 14 | Improvement | `DisburseJob` has unused `enqueue_time` parameter | The parameter was accepted but never used. The rake task caller also never passed it | [a063a05](https://github.com/alinavancea/sequra/commit/a063a05) |
| 15 | Improvement | `DisburseJob` has no tests | Only had a `pending` placeholder. Added tests for successful disbursement, order processing, and invalid merchant | [a063a05](https://github.com/alinavancea/sequra/commit/a063a05) |
| 16 | Improvement | Duplicate scopes in `Disbursement` | `for_month` and `for_interval` were identical. `for_month` was unused — removed it | [90a5f9f](https://github.com/alinavancea/sequra/commit/90a5f9f) |
| 17 | Improvement | `Merchant#should_disburse?` has no test coverage | Had a TODO comment but no tests. Added tests for daily/weekly merchants covering pending orders, already disbursed, and correct weekday logic | [8a97fda](https://github.com/alinavancea/sequra/commit/8a97fda) |
| 18 | Not a bug | `Disbursement#set_reference` format | Initially flagged as potentially generating non-unique references. However, the requirement states: *"Assign a unique alphanumerical reference to each disbursement, which represents the group of orders paid on the same date for a merchant."* The format `"#{Date.current}_#{merchant_id}"` correctly encodes this, and the uniqueness constraint prevents duplicate disbursements for the same merchant on the same day | N/A |
| 19 | Improvement | Order model lacks `amount` validation | No validation that `amount` is present or positive. Nil/negative amounts could flow into fee calculations | [394c037](https://github.com/alinavancea/sequra/commit/394c037) |
| 20 | Improvement | Missing unique database indexes | `orders.external_id`, `merchants.reference`, and `disbursements.reference` had uniqueness validations but no corresponding database indexes | [cefd84c](https://github.com/alinavancea/sequra/commit/cefd84c) |
| 21 | Improvement | Duplicate test description in `order_spec.rb` | Two `it` blocks both said `"creates a record with pending as default"` but the second tested `:processed` | [813fbe6](https://github.com/alinavancea/sequra/commit/813fbe6) |

## Additional Improvements

These improvements were made alongside the fixes above:

| Improvement | Description | Commit |
|-------------|-------------|--------|
| Fix `comssion_for_amount` typo | Renamed method to `commission_for_amount` across all files | [34644eb](https://github.com/alinavancea/sequra/commit/34644eb) |
| Extract fee rates into constant | Moved hardcoded fee rates into a `COMMISSION_FEES` constant | [a1ef67f](https://github.com/alinavancea/sequra/commit/a1ef67f) |
| Improve `FeeCalculator` | Use `BigDecimal` for precision, rename `for_amount` to `rate_for_amount`, add `ArgumentError` for negatives, consistent guard clauses | [6787ef5](https://github.com/alinavancea/sequra/commit/6787ef5) |
| Add FactoryBot | Set up `factory_bot_rails` with factories for all models and refactored all specs to use factories instead of `Model.create!` | [813fbe6](https://github.com/alinavancea/sequra/commit/813fbe6) |

# Prompts Used During Code Review

This file documents all prompts used during the [code review session](CODE_REVIEW.md), in chronological order.

## Understanding the Codebase

```
how does fee_calculator.rb work?
```

## FeeCalculator Improvements

```
fix the typo, consider all files where this method is used
```

```
run the tests
```

```
Use a constant to store the comission fee values in fee_calculator.rb
```

```
What other improvments you can suggest in this class
```

```
implement all of them and add tests coverage
```

## Testing Practices

```
is it a good practice to use Model.create! in tests?
```

```
yes, set up factories and refactor the tests
```

## Full Project Review

```
review the etire project list all issues and improvements that can be made,
focus on the code written and not on rails generated code and files
```

## Fixing Issues One by One

```
Let's take them one by one, start with first fix the bug and add tests
```

```
yes, commit this and move on to the next issue
```

```
yes continue
```

```
yes fix it
```

```
improve related tests, add more coverage if needed
```

```
continue with issue 8
```

```
yes continue with 9
```

```
go to next issue number 4
```

```
any tests coverage needed?
```

```
continue with 19
```

```
continue with 20
```

## Workflow Preferences

```
Allways run all tests and bin/rubocop -f github
```

## Clarifying Requirements

```
explain the issue
```

```
the requiremnt is: Assign a unique alphanumerical reference to each disbursement,
which represents the group of orders paid on the same date for a merchant.
```

## Git and PR Operations

```
create a commit for this changes
```

```
push this last commits
```

```
commit this changes push on current branch and open a PR on gihub including only this commit
```

```
create a PR on github including the last commit create a branch from work-with-claude
```

```
push this branch fix/return-errors-from-services and create a PR against the work-with-claude branch
```

```
update work-with-claude branch with remote
```

```
push commits to work-with-claude branch
```

```
brew install gh
```

```
gh client all set, create the PR
```

## Documentation

```
Add a markdown file in which we should have a descirption with all the 21 issues reported
with description and a link to the commit that fix it. Mention about the issue 18 that is
not a bug. Make this easy to read and acess the commit. I suggest to build a table
```

```
Clearly mention that this review was done by claude code
```

```
Include information about how long this took since the begining of work start
```

## Meta

```
How I can better write prompts so that the process of review can be effective
```

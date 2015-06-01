---
layout: post
title: Budgeting in an Ideal World
date: 2015-05-31
published: false
---
Last night, during a walk, I had a bit of a Twitter storm.

<blockquote>
  <p>I'm pondering improving budgeting software. <a href="https://twitter.com/simple">@simple</a> is near idea, but doesn't support spouses or shared incomes.</p>
  <p>I currently use <a href="https://twitter.com/ynab">@ynab</a>, but it's not very intelligent and very manual (intentionally, to be fair).</p>
  <p>I want a system that knows my bills, knows my goals, and knows my income. Tell me what I can spend today. Pay my bills when they're due.</p>
  <p>Start siphoning money from my immediate awareness and save for rainy days. Get me a month ahead. Six months ahead, even.</p>
  <p>Finally, let me easily see how I'm doing. Don't make me load an app every time I want to make a purchase.</p>
  <p>I'll file this all away under "Businesses that would be great but unsustainable without being creepy".</p>
</blockquote>
<p>&mdash; Adam Lukens (<a href="https://twitter.com/spawn968">@spawn968</a>) <a href="https://twitter.com/spawn968/status/604879335632289793">May 31, 2015</a></p>

There's a lot to unpack here, honestly, so let's break it down.

## YNAB

### The Four Rules
1. Give Every Dollar a Job
2. Save for a Rainy Day
3. Roll With the Punches
4. Live on Last Month's Income

As I said, I currently use [YNAB](http://www.ynab.com) for my budgeting. Their [four rules](http://www.youneedabudget.com/method) helped guide me to actually being ahead in payments back when I was excited about managing my money. My wife wasn't as excited, so I would check my various bank sites daily and add in all the transactions one-by-one. YNAB supports OFX import but they try to distance themselves from it. Transactions should be handled manually so they can influence purchasing decisions.

It's a few years later and I'm a bit lazier. I do my transactions once a week. I'm actually putting off dealing with it as I type this. The more manual intervention a process is, the more error-prone it is. I'll make mistakes. I'll put things off. My savings started sliding. I'm still better off than I was with no budget, but I'm not doing as well as I think I could. The bills still get paid, but I don't have the instant feedback needed to influence buying decisions and change behaviors.

I'm also tied to a laptop to do much with the budget. I can enter transactions on an iPhone. I can even reconcile on an iPad. Unfortunately, reconciling is a process that requires having the bank's site open and YNAB, making it either a bizarre juggling act or a multi-device affair. None of them are great answers to a process that is, as I said before, already manual.

## Simple
[Simple](https://www.simple.com) has a very nice [goal system](https://www.simple.com/goals). You put in the priorities and it slowly eeks away from the available balance, slow enough that you don't even notice it missing. The effect is dramatic, though. You'll always have the amount of money you need when you need it, at least for the goals you've set aside. I used it before YNAB and it worked quite well. Transactions are autotagged opening the possibility of budgets automatically pulling from goals in the future. There's a lot to like about this.

There were some problems with this solution, though. You need to manually create a goal for each thing you want to save for. My YNAB budget tracks 33 separate categories, and I imagine that would get unwieldy quick. Worse still, they do not support recurring goals (though a support article says that it's in the works). I'd be putting in 10-20 categories monthly.

Simple only supports one login person per account. They've talked about having support for couples, but it always results in separate accounts. From Simple support:

> We don't have a firm ETA on when they will be available, but our current plan is to roll out the features to support linked accounts as we are able to develop them. We're working really hard to offer instant transfers between Simple customers in the next few months, and then we will introduce data sharing between accounts sometime in the future.

My wife makes a decent income and neither transferring money back and forth or sharing a login sounds great to me. Hopefully it will get better in the future, but I'm stuck for now.

Lastly, you need all of your money in their account. They don't support joint accounts, credit cards, money markets, etc. Credit cards are worthwhile both for point programs and for transactions that may end up being fraudulent (as you're betting with the bank's money rather than yours while you wait for it to be refunded). Money market accounts can gain significant interest over savings accounts. While I enjoy their service, site, and app, I don't really want my budgeting solution to be typed to bank. I want the freedom to go where I feel our money is best held.

Their solution is a good 75% of the way there, but I have to choose their bank in order to take it.

## Mint
I'd like to say I've looked into Mint a great deal. Honestly, after they were bought by Intuit, I haven't been interested in giving them my information. Prior to the buyout, I had large problems with transactions being tagged incorrectly, being missing or repeated, etc.

## Ideal
Finally, on to what I'd like (and the bulk of what I'd tweeted earlier). The older I get, the more comfortable I am with my limitations and fundamental nature. I'd love to say that I'll be an economic model citizen, but things come up and babysitting transactions is a chore. It's a chore that is repetitive and punishes typos or math errors. I recognize a problem suited for a computer when I see one.

I also understand the inherent difficulties in this problem. I suspect YNAB endorses manual entry both for minding transactions and also because pulling financial data from multiple banks is hard. Really hard. Yodlee (who at least used to be the data feed for Mint) has made an entire business out of getting data out of various bank's websites. Screen scraping is a pain, and doing it at scale perfectly may be borderline impossible.

I'd like transactions to be pulled down in near-realtime. Transactions are tagged with a budget category if the payee has been seen before. The money immediately comes out of the budget category and updates the remaining amount.

You never set an arbitrary amount in a budget category. You set priorities for your money.

> "I need enough money to feed my family."

On a priority of 0-100, this is 100. Phone bills can wait. Eating out can wait. This is mandatory. The budget starts off with reasonable assumptions on what a family (or individual) needs in a month, adjusting as it learns more about a typical month of groceries. Money is taken out of the available pool from the very beginning of the month with adjustments flowing in as the needed amount is tweaked for the user.

> "Here are all my utility bills. I need to pay them on time."

Let's say this has a priority of 99. The family is fed, so now bills must be paid. Bills are input into the system either manually (including normal balance and schedule) or with URLs, usernames, and password. Bill amounts are pulled regularly to get new bills and ensure that payments were reached on time. The budget is updated with the amounts that have to be paid plus any overhead (if the bill increases like gas or electricity). A payment is sent via the cheapest means, be it the website through their payment services or a bank's online billpay. The amount is pulled out of the available balance as soon as there is enough to cover it to ensure bills get paid.

> "I need to buy birthday gifts for the following ten people this year."

Priority? 50. It will be embarassing to miss a gift, but understandable if your money is tight. Amounts can be manually added, assumed, or inferred based on historical data. If you normally buy your mother a $50 gift, it will start saving for a $50 gift by the time you normally buy it.

> "I want to take a trip to the Bahamas. It costs around $4,000."

This is a priority 25 and has no end date. We'll be skimming the remainder of funds gradually to get this as soon as safely possible. Worse comes to worse, this will be reallocated to pay for higher priority items. At all times, the budget can tell you when it expects you'll have the money, adjusting if it needs to move funds or finds more money.

As much as I like YNAB's rule that [every dollar has a job](https://www.youneedabudget.com/method/rule-one), I honestly don't think it's worth the overhead. I want to make sure that my priorities are met and that I'm saving for a rainy day. Most YNABers that I've talked to have a "catch all" savings category, be it "Rainy Day", "Spending Money", etc. This money doesn't have a job because I don't know when I'll take another vacation, need to go to a funeral, or need to loan money. Patterns can emerge if you give a couple of years of properly-tagged transaction history, but there will still be bumps in the road. I really like Simple's "Safe to Spend" concept. It tells you what's in your account that isn't earmarked for a future cause. So long a priorities are loaded, we're safe to spend the rest.

That doesn't mean you should spend all of it, but my suspicion is that people using budgeting software won't. Seeing your balance hit zero is traumatic for people who have clawed their way out of debt. In the mean time, it gives the software useful information on what *is* important to the user. This helps set up new categories, set balances for them, and set priorities. The system can learn simply by you voting on priorities with your remaining funds. You'd have the option of adjusting these fields if you're hoping to make a behavioral change ("I want to eat out less and cook more"), but you don't have to. More importantly, since you can say what's more important, you don't need to say *how* it's important by giving it a dollar amount.

The budget should try to inject intelligence in all things. If I'm near a restaurant where I've historically overspent, send me an alert reminding me to take it easy. Suggest alternate places nearby that I frequent and spend less on average. Send me weekly or monthly reports on how I could save money by frequenting a different grocery store. Let me scan in my receipts and let the budget track the average price of specific products and general goods between stores. Look them up on Amazon and find cheaper deals. Check my credit card's points site for bonus point offers when I step in an Apple Store. 

The budget should lie to you. Ever found money in your pocket you didn't know about? It feels *fantastic*. Possibilities open up. I'm using budget software because I can't trust myself to manage money intelligently on my own. I want to make sure my priorities are taken care of and that I have some walking-around money, but I also want to be saving in a way that doesn't readily show me that I have money available. Take 1-20% (depending on income available after mandatory priorities, prior spending during the year, and any other factor you can think of) and just hide it. Use it to pad out the bumps in the first year of spending before we have a rough idea of how a person acts. Use it to help boost the vacations and low priority items. Prompt me when it hits four figures and suggest I send some to an investment account or CD.

In fact, since we have some access to my various banks, intelligently move money between accounts to ensure that I have money to spend while simultaneously maximizing the interest returns I could be making. Keep the majority of money in Savings, Money Market, etc until it's needed for the month and simply transfer the needed amount. Work to increase my available funds at all times while not impinging on my day-to-day practices. Pay off credit cards weekly. Pay bills at the last possible second to wring out more interest. If I can pay for everything on my credit card instead of my debit card, I actually need a fairly low amount of emergency cash in a checking account. The rest can go to accounts with higher interest yields and varying levels of liquidity in order to maximize income. 

[TextExpander]() has a great dialog showing how many keystrokes you've saved using that product. Show me how much money I've earned using the budget software. 

Image of text expander

Finally, keep me updated on how I'm doing. Offer to send me daily, weekly, or monthly reports. Have a Today widget for iOS and a lock screen widget for Android. Have an Apple Watch glance. Give me an API to pull back basic stats on each priority, category, balance. I can make decisions better if I'm informed, but I'll likely stay ignorant if I have to open an app every time I want to buy lunch. This is another repetitive action that a computer could do for me. 

# Reality

It's hard. Possibly impossible

I can make it for me. Perhaps I should. But it won't help more people. And it really could.

My budget still isn't done. 



I'm pondering improving budgeting software. @simple is near idea, but doesn't support spouses or shared incomes.
I currently use @ynab, but it's not very intelligent and very manual (intentionally, to be fair).
I want a system that knows my bills, knows my goals, and knows my income. Tell me what I can spend today. Pay my bills when they're due.
Start siphoning money from my immediate awareness and save for rainy days. Get me a month ahead. Six months ahead, even.
Finally, let me easily see how I'm doing. Don't make me load an app every time I want to make a purchase.
I'll file this all away under "Businesses that would be great but unsustainable without being creepy".


<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">I'm pondering improving budgeting software. <a href="https://twitter.com/simple">@simple</a> is near idea, but doesn't support spouses or shared incomes.</p>&mdash; Adam Lukens (@spawn968) <a href="https://twitter.com/spawn968/status/604877774617231360">May 31, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">I currently use <a href="https://twitter.com/ynab">@ynab</a>, but it's not very intelligent and very manual (intentionally, to be fair).</p>&mdash; Adam Lukens (@spawn968) <a href="https://twitter.com/spawn968/status/604878101525299200">May 31, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">I want a system that knows my bills, knows my goals, and knows my income. Tell me what I can spend today. Pay my bills when they're due.</p>&mdash; Adam Lukens (@spawn968) <a href="https://twitter.com/spawn968/status/604878508465061888">May 31, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Start siphoning money from my immediate awareness and save for rainy days. Get me a month ahead. Six months ahead, even.</p>&mdash; Adam Lukens (@spawn968) <a href="https://twitter.com/spawn968/status/604878767971004416">May 31, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Finally, let me easily see how I'm doing. Don't make me load an app every time I want to make a purchase.</p>&mdash; Adam Lukens (@spawn968) <a href="https://twitter.com/spawn968/status/604879048217636865">May 31, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">I'll file this all away under "Businesses that would be great but unsustainable without being creepy".</p>&mdash; Adam Lukens (@spawn968) <a href="https://twitter.com/spawn968/status/604879335632289793">May 31, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

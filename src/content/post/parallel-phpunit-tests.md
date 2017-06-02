# Phpunit tests in parallel

## Problem: Growth.
Your tests start small. They are fast at first. But they will get ugly. You were probably okay with using a real database when testing, or not mocking that one function in that one class.

Now your app is a gigantic program with dozens of features and critical paths that must always work. Tests run in 15 minutes. You have 1000 tests and 2000 assertions.

You release a fix feature and seconds later you start getting reports of mayhem. Something went wrong. The site is down. No problem. You fix it and deploy to production. But first you hit your Continuous Integration and your tests begin. 15 minutes later you reach the last test only to realize that it fails and you have to fix something else. Another 15 minutes. Problem solved. But you have had 30 minutes of downtime. And for each failure in your tests, potentially another 15 minutes wiz by.

## Solution: ~~Service Oriented Architecture~~ Running tests in parallel.
The buzz word of the day is SOA, aka Service Oriented Architecture, aka "Microservices". Splitting off your monolithic application into cooperating and friendly services that balance the load, deploy by themselves and test independently.

But before you can get there, you still have to deal with that nasty ol' legacy app. By this point is smells real bad, and you need MUST keep the tests in place because it's the only thing holding this thing together. Like duct tape on the hull of a sinking ship. What do do? You run each of your tests in parallel. But you didn't write your tests to run this way, did you?

## Problem: 99 tests and connection of 1.
You never expected your application to get this big. At first it didn't matter that you talked to your database during your tests. Or maybe you decided to write more cross-functional tests and needed to connect to the database. But now you need to fix your tests so that it runs quickly again. You know you need to run things in parallel because that is the only way to speed up. You can't do that with one database. One test will start and might change data which another test is using.

## Solution: ~~Segregate your data~~ create a new database per test.
You could segregate your data, but it is unlikely that your boss is okay with taking 2 months to rewrite your tests to handle it. So the only other solution is to use different databases per test.

<<code sample>>

## Problem: Where to find an oven?
Your bread are mixed together and the dough has risen in it's bed pan, but we need an oven. Your tests CAN run in parallel, but how do we run them that way? Phpunit does not run tests in parallel. You could run brianium/paratest<link> but you are limited to CPU on whatever box is running them. But to really scale the story, you need to use a Continuous Integration/Pipelines solution that can also handle parallel tasks.

## Solution: GitLab!
Gitlab's Pipelines are legit. Yes, I am breaking format to say this. Put all the pieces together with GitLab, and your 15 minutes turns into 1-2 minutes. 20 workers/parallel tasks running 50 tests per worker, and watch your tests fly. For backup and redundancy, you setup a couple workers on a small EC2 instance on AWS and the rest on 2-3 beefy in-house boxes (with SSD's, since you are using Postgres and creating your databases from a template, which is really just a file copy)


TODO: Write a how to guide on how to setup a phpunit system to run tests in parallel.
















## Synopsis
Here at Canopy we are working to break up our monolithic application into services. Until then we have to deal with a less then pleasant set of Phpunit tests. When they were written, things were fast and all was well. But as the app became larger things started to slow down. We solved the problem wth Gitlab and their Pipelines.

## Some history
We originally built Canopy from a PHP framework called Laravel. When we sat down and decided what we wanted for test coverage, we broke our strategy into 2 types of tests. The first being unit tests. These were simple and mostly what you would expect. The second was end-to-end/functional tests. These tests hit the API from the front door and asserted specific responses. A smoke test of endpoints.

This was implemented and ran fairly quickly, taking no more than 20-30 seconds for 50 or so tests and 100-150 assertions. But then we started writing more features. Features incurred tests. Usage brought bugs, which brought tests. Typical dev cycles.

Now we were seeing our tests run in around 15 minutes, and for some reason, on my machine they would run in 45 minutes. This was no longer something we could maintain. Something had to be done.

## Speeding up the tests

### Finding the bottlenecks and eliminating them.
Using xdebug profiler we could see the bottleneck was truncating the database in preparation for the next test. Everything else the profiler found was negligible.

Our process for truncating was fairly simple: iterate all tables and truncate one at a time. Probably could have sped it up even more by keeping a list of tables that were actually used in the test and cleaning just those.

We found that dropping the database and recreating the schema was quite a bit faster. Postgres offered us further optimization by allowing us to create the database from a template database, allowing us to skip the schema step.

Okay, cool. We went from 15 minutes to about 10. Better. Far from "problem solved".

### Step 1. Independence day.
We had been testing with just one connection to the database. You can run your tests in parallel still, but in order to do so, you have to mock your data for each test so that they do not overlap in any way. Our tests were not written that way. We wrote our tests so that each time one ran, it nuked the tables and reseeded the data specific to the test. If you have two tests running at the same time, whichever one finished first would bork the other.

Simple solution, create new database/connection for each test. As a happy accident, we realized that while we drop the database and create from template, we could name the database something new each time. So the solution for our bottleneck also become the solution for preparing to run these tests in parallel.

###

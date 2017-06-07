+++
author = "nhumrich"
title = "Thoughts to Microservices"
draft = false
date = "2017-06-02T02:05:03-07:00"

+++


The programming world moves very quickly compared to other industries. Many things come an go
and it can often be hard to keep up with the latest trends. 
More often then not, it makes sense to not follow common trends, as they are untested, and 
might fade in a couple years anyways. How do we decide which trends to follow and which 
to pass on? This is a really hard problem, but can often be decided by digging further into
the trend. Who is else is doing it? Why? What problems are they trying to solve? What problems
are created?

{{< gtrend >}}
trends.embed.renderExploreWidget("TIMESERIES", {"comparisonItem":[{"keyword":"microservices","geo":"US","time":"2013-06-01 2017-06-02"}],"category":0,"property":""}, {"exploreQuery":"date=2013-06-01%202017-06-02&geo=US&q=microservices","guestPath":"https://trends.google.com:443/trends/embed/"});
{{< /gtrend >}}

Microservices are one of these trends. They have been quite a hot topic for a few years now. 
It might make sense to wait for others to vet microservices before adopting them. After all, based on google search trends, microservices seam to be a relatively new thing in the programming world.
Despite this, one of the main selling points of microservices is that its the pattern many large,
trusted, companies (such as Google, Amazon, Microsoft, Facebook, Netflix, Spotify, etc.) follow.
How do so many companies use microservices if it is so new? 
Turns out microservices is just a relatively new **term**. The concept of microservices has actually been around for a while, it just never had an official name. Microservices is actually a subset of Service-oriented Architecture (SOA). SOA, has actually been around for quite some time.

{{< gtrend >}}
trends.embed.renderExploreWidget("TIMESERIES", {"comparisonItem":[{"keyword":"/m/0315s4","geo":"US","time":"2004-01-01 2017-06-02"}],"category":0,"property":""}, {"exploreQuery":"date=all&geo=US&q=%2Fm%2F0315s4","guestPath":"https://trends.google.com:443/trends/embed/"});
{{< /gtrend >}}
 
SOA, however has created a bad name for itself due to certain patterns such as "Enterprise Service Bus" which are now considered anti-pattern. Thus a term for a specific "style" of SOA has been created, which is now called "microservices". This brings the question, what exactly **is** a microservice

## What is a Microservice

A microservice is a SOA where each service has a couple restraints imposed upon them.

1) **Smart endpoints and Dumb pipes**. A microservices should have endpoints that can convert a universal contract into objects. A microservice should own its own logic and form its own responses. 
This is in contradiction of the Enterprise Service Bus, where the bus itself often handles lots of choreography and transformations. It is important that logic be built into the actual service that its for. 

2) **Hard boundaries**. Microservices should always talk to each other using a standard protocol, and never using functions/libraries. This protocol is often HTTP. Microservices should never allow other services to reach into their code without going through the defined contract and protocol.

3) **Independently Deployable**. A Microservice should be able to be modified, tested, and deployed by itself.
If services require lock-steps or deploy together as a bundle, that is not a microservice.

4) **Separation of Data**. A microservice should own its own data. It should never reach into another services database.
**A database is not a contract**. If multiple services are sharing a database, these are not microservices.

These constraints must be kept in order to truly reap the benefits of microservices. To learn more about microservices,
feel free to read [Martin Fowlers post](https://www.martinfowler.com/articles/microservices.html), or read the book [Building Microservices by Sam Newman](https://www.amazon.com/Building-Microservices-Designing-Fine-Grained-Systems/dp/1491950358)

## Pros and Cons of Microservices

Nothing is a silver bullet and that includes Microservices. Microservices are not for everyone. Deciding whether to use  microservices or not is about deciding where your priorities lie. The typical comparison for most is Microservices vs Monolith.
A monolith is a single deployable app which contains all application code. There is only one code base, only one 
deployable, and one database (well, unless you're sharding). A monolith is the exact opposite of a SOA architecture, so it balances the cons of microservices very well. That being said, there might be some models that skirt the middle of the two.
But for this article I will compare the two.
For some companies/people, the monolith will be the correct approach. But for Canopy, the answer was Microservices. Here
are some of the pros/cons to microservices.

### Pros
1) **No shared code base**. Typically when you use microservices, a Microservice is owned by a specific team. 
When you have multiple code bases, your teams are less likely to step on each others toes.

2) **Limited Blast Zones**. If a team pushes bad code, or a service dies, it only affects that portion of the application. 
On a monolith, any change could potentially bring down the entire system.

3) **Enforced Boundaries**. In single repo projects, boundaries are often defined, but are very "theoretical". Breaking the boundaries by having separate code bases prevent people from creating code that crosses several boundaries. It is just too easy to cross boundaries in a single repo, and when people have deadlines, they are likely to cut corners.

4) **Autonomy**. Conway's Law says that a software architecture will eventually mirror the organization communication structure.
If you want "small blast zones" you have to create Autonomous teams. It is too difficult to create autonomous teams when
everyone if working on a single repo. If you go with the monolith you end up getting a very hierarchical structure in your organization, as you need certain people/teams to coordinate everything.

5) **Independent Scalability**. Some products simply aren't used nearly to the scale of the major products.
Having to worry about large scale for products that have small uses is troublesome. On Monoliths, every feature has to be built for your largest scale, since everything is deployed together.

6) **Frequent small deployments**. Large projects lead to big deployments. Big deployments lead to lots of lock-steps and process. Process leads to inrequent deployments. Because services are independently deployable, the deployments are smaller,
and have less lock-steps. This allows you to deploy frequently. Frequency matters when you want a low turn-around time on 
fixing bugs/security issues.

7) **Easier Rewrites**. Because services are smaller, it allows you to rewrite entire services without impacting anyone else. 
In a single repo, rewrites are near impossible without freezing feature development. 
Sometimes the entire app still needs to be rewritten or changed (perhaps you're changing your database?). 
In these cases, you can change one service at a time, and not have to full freeze feature development.

8) **Tech Stack agnostic**. Because services are broken up into hard boundaries, this allows you to use different tech stacks for
different products. Perhaps you have a new product could be written much faster/easier with a different language/database. 
In a monolith world, you are locked into your language/product decisions. You pick a framework and stick with it.
In microservices however, each service could have its own tech stack; you could even run your own experiments as to which
tech stack is working better, etc. If you decide you need to move to a new stack across services, you can do it one service at a time.

### Cons
1) **Performance**. Microservices often have to call many other services. Other services have to go to other databases.
What could have been a single database call with lots of joins, is now a multi-service call.

2) **Dependency Management**. There are no dependencies on a Monolith. You just deploy it. In Microservices, you could depend 
on a new api for a service that hasn't deployed yet. You have to manage those dependencies.

3) **Tools/Configuration Management**. That that there are more than one service to manage, tools are required to manage services and their configurations. Many new tools will have to enter your stack to manage the full picture. You might want 
a single place to aggregate all logs or all metrics etc. What used to be a simple log file or sql query is now a tool
that has to be built or used.

4) **Operations**. Managing a swarm of duplicate stateless servers is relatively easy. Managing a cluster of services, where every server
has different things on it, is much more of a headache. If services have different stacks, they are not all built the same. 
Tools are required to manage the operations overhead.

5) **Transaction Safety**. On a monolith, you can make every request a single transaction. If anything goes wrong anywhere,
the whole thing can be rolled back. In a microservice environment, a service could fail after it tells another service to 
do something. This could cause potential data issues.

6) **Service Discovery**. Now that there are many services, you need a way for the services to find/talk to each other.

7) **Backwards Compatibility**. When you deploy everything together, you can easily change things such as an API. The new code calls the new API, and everything is great. In a microservice world, you cant control other services; your API's must stay backwards compatible potentially forever. 

8) **Debugging**. Errors can potentially span many services. It can be hard to know which service an error is really coming from. There is no longer a single stack to debug, and its harder to trace
what happens across boundaries.

9) **Overall Complexity**. A microserviced system is a distributed system. There are a lot more parts, and the system as a whole gets a lot harder to manage and reason about.


## The answer is... Microservices!

At Canopy, we decided to bet on microservices despite its cons. We felt that **autonomy**, **Limited Blast Zones** and **Frequent Deploys** were the most important things for our company, and it outweighed the cons. We ultimately decided that Microservices would be a big buy in cost, but would pay dividends in the long run. Here are some our thoughts on the pros and cons and
why we went with the decision we did.


* **Autonomy**: Autonomy is very important to Canopy. Nothing good ever comes from micro-managing.
We believe that when you empower developers to make their own decisions, they move fast and make better decisions. Sure, at times they might make bad decisions, but as long as we fail fast, then we can learn from it.

* **Frequent Deploys**: The best way to be successfully is to make many mistakes and to fail. *Ken Robinson* said: "`If you're not prepared to be wrong, you'll never come up with anything original.`" At Canopy, if we are going to innovate, we need to be able to fail many times. Ideally we recover from our failures as quickly as possible. In order to do that, we need to have short frequent deploys. Infrequent deploys will scare us into trying new things.

* **Limited Blast Zones**: If we are failing a lot, then we need a way to fail "safely". Adding blast zones to our app allows us to feel more comfortable failing. If we fail we only affect some things. Customers enjoy when things dont constantly break. Very few customers use ALL features of the app in the same day.

* **Operation Management**: Microservices adds a very big overhead to operations. This could require an entire operations team. Instead, Canopy has decided to help mitigate this issue by building a culture of "You Build It - You Run It". Developers are essentially responsible for handling the operations of their services. 

* **Tools/Configuration Management**: Lots of tools are required to handle the many services. This can be mitigated by hiring a DevOps team. A team responsible for helping manage all the configuration and services by providing tools to help get various tasks done.


## Conclusion
In Summary, Canopy has chosen microservices despite the upfront cost and challenges in order to
help foster a culture of autonomy and fast-failing. As Canopy is growing really fast, the microservices separation of responsibilities should help us scale as an organization without slowing our rate of innovation. 

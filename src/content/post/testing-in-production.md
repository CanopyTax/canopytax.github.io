+++
author = "bret"
title = "Why You Should do all Your Testing in Prod"
draft = true
date = "2017-08-15T08:05:03-07:00"

+++

### Testing in prod?
As developers we typically run a local version of our application with fake data to preview the changes we're making as we develop before we deploy them to production. But what if you could run your app in production with pieces of it being loaded from your local machine? Then you could develop against real data and production. Also, you wouldn’t need to run the entire back-end stack while making only front-end changes. This can be done by building your app in a way in which functionality is resolved and loaded dynamically at run-time. Doing so allows you to test and develop in production by intercepting that run-time resolution.

### Run-time resolution
When building a single-page application, usually JavaScript code is statically built into one or more bundles. Those bundles are added to the page through traditional `script` tags:

{{< gist 7b7e6d1ce415ca1833aac7985923be4b >}}

Resolving code at run-time introduces an extra dynamic and imperative step. This can be done with libraries like RequireJS and SystemJS, or if your browser supports it, native ECMAScript modules:

{{< gist da7355fd4a187655bb1eef31f5ded83b >}}

Because the application is loaded dynamically, you can intercept the loading mechanism and change the location of your bundle. This allows you to set a `localStorage` flag and load the application in production while dynamically changing the bundle to load from your local machine:

{{< gist 8309fd0ee938a6b6bb9d845f41c0bffd >}}

### Micro-services
While you could use the above examples and define your application with one large bundle, it might be worth considering breaking up your application into microservices, or domain specific bundles. This allows you to define natural split points in your application. Instead of loading all code up front, bundles are loaded on demand as the user navigates throughout the application. This also allows you to override smaller portions of code while keeping the majority of the code based upon production.

### What about performance?
Dynamically loading modules definitely has an impact on application performance. Instead of immediately loading a static script tag, the browser first has to parse and execute an extra layer of JavaScript code before loading your application. This can be avoided by server rendering your script tags and utilizing a `cookie` to determine the override locations instead of `localStorage`.

### Learn more
1. [Sofe](https://github.com/CanopyTax/sofe) - At CanopyTax, we built a plugin on top of SystemJS that makes dynamically loading and overriding bundles easy.
1. We have over a dozen front-end services, some of which utilize Angular.js and others with React. We load and run both Angular and React in the same single-page application through a JavaScript metaframework called [single-spa](https://github.com/CanopyTax/single-spa).
1. [Micro frontends—a microservice approach to front-end web development](https://medium.com/@tomsoderlund/micro-frontends-a-microservice-approach-to-front-end-web-development-f325ebdadc16)
1. [Why imperative imports are slower than declarative imports](https://gist.github.com/Rich-Harris/41e8ccc755ea232a5e7b88dee118bcf5)

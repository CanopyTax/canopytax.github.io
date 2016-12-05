+++
author = "joel"
title = "A case against Angular Upgrade Adapter"
draft = false
date = "2016-09-16T08:05:03-07:00"

+++

If you’re hoping to migrate your Angular 1 application to Angular 2, you’re
going to hear about the [Angular Upgrade
Adapter](https://angular.io/docs/ts/latest/guide/upgrade.html), which let’s you
run ng1 and ng2 apps side by side.

It’s not that Angular Upgrade Adapter is bad or poorly written or doesn’t work.
And it’s not the Typescript or the Angular 2 or the SystemJS.

But here are two reasons that will make you think twice about using Angular
Upgrade Adapter:

### 1. You’ll still have to rewrite everything

![](https://cdn-images-1.medium.com/max/800/1*VhuRgvrW6GijrjEpZtqnxA.gif)

This comic strip is a real story, and I am the Dilbert. One time at Amazon I
made a joke to my product manager. It was about rewriting code. He didn’t laugh.
Then I joked about how he didn’t think it was funny. Still nothing. Then I
walked away.

### 2. You’ll probably have to do this again, anyways

{{< tweet 540481335362875392 >}}

Developers are just machines that consume Twitter and produce frameworks. And,
really, I wouldn’t have it any other way. Trying out a new framework is just too
fun to give up. And when *I’m* not the one pushing for us to try out the new
shiny, somebody else is. Even if we have that big meeting where we talk for an
hour and a half and everyone agrees that Angular 2 is the “framework we decided
on”, it won’t last.

### So is this just how new frameworks are?

For a long time I thought the solution to the “framework problem” was staying on
top of everything. If I migrate early to beta versions and release candidates,
somehow that makes my inability to switch frameworks okay. Another thing I
thought was that if I could just find the *right framework* that we’d be happy.
Or that somehow we could cure ourselves of the desire to switch frameworks.

Turns out that’s just not true. And once I accepted that, I realized it’s
totally okay!

### Let’s get meta.

I think it’s time for the Javascript community to get meta with frameworks.
Instead of finding the *right* framework and hoping that it works out, what if
we were capable of simultaneously using any number of frameworks?

What if we had a bring-your-own-framework mentality where multiple apps
cooperate within one SPA? A framework for using frameworks.

A Javascript metaframework.

Where I work this is what we’ve been trying to figure out. What would something
like this even mean? Could we start each project as a green field instead of
locked-in to our previous technology decisions? How do we pull it off?

### A different approach

What we’ve come up with is a project called
[single-spa](https://github.com/CanopyTax/single-spa) and so far we love it.
It’s an alternative to upgrade guides and migration tools. An early entry to the
nascent world of “Javascript metaframeworks.”

Instead of migrating your large Angular 1 application to Angular 2, single-spa
has you split it up into several small applications that coexist in the same
SPA. Once split up, you can tackle each one of the applications individually.
When Angular 2 makes sense, migrate one of the apps to be Angular 2. If React
makes sense, rewrite one of them in React.

Or if you don’t want to rewrite anything at all, just let your application
remain while still giving yourself the option to try something else for new
projects.

{{< figure src="https://cdn-images-1.medium.com/max/800/1*jiiG-Dxyk6OmVCy2EOtLCA.png" caption="" >}}

The benefit is that your approach is framework-agnostic. When you want to try
out a new framework, you have a way to do so. Compare this to Angular Upgrade
Adapter, which is a one-way door that leads to Angular 2. What do you do when
you want to try out React or something else?

What single-spa is doing is managing your applications for you. You can think of
it like a framework agnostic router on top of all other applications. It manages
which applications are active and which ones are dormant.

### How to try it out

Single-spa works with es5, es6+, typescript, webpack, systemjs, gulp, grunt,
bower, or really any build system you can think of. You can npm install it, jspm
install it, or even just use a script tag if you prefer. It works in Chrome,
Firefox, Safari, Edge, and (at least) IE11.

To give it a shot, you’ll have to [migrate your
SPA](https://github.com/CanopyTax/single-spa/blob/master/docs/migrating-existing-spas.md)
to become a single-spa child application. After you do so, the entry file to
your application will look something like this:

{{< figure src="https://cdn-images-1.medium.com/max/800/1*YNZMoyijJown_nOBrQ0wxA.png" caption=" " >}}

Once you’ve added a file like this to your app, you’re ready! You can keep your
existing ui-router configuration and your ng1 controllers, services, and
directives.

The docs for single-spa are [located
here](https://github.com/CanopyTax/single-spa/tree/master/docs), let us know
what you think!

*Originally posted at
[https://medium.com/@joeldenning/a-case-against-angular-update-adapter-d4e121282a11](https://medium.com/@joeldenning/a-case-against-angular-update-adapter-d4e121282a11)*

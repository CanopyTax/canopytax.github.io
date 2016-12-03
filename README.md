# canopy-tech-blog
Canopy Tech Blog

### Setup
The blog is statically built with Hugo. First install Hugo https://gohugo.io/

### Running the blog
Run the blog by executing `hugo server`

### Add an author
If you are a new author to the blog, add a new `author.yml` file. You can copy one of the existing https://github.com/CanopyTax/canopy-tech-blog/blob/master/data/authors/bret.yml

### Add a post
Add a new markdown file in https://github.com/CanopyTax/canopy-tech-blog/tree/master/content/post

Make sure the md file has at the top a header:

```
+++
author = "bret"
title = "A Case for SOA in the Browser"
draft = false
date = "2016-12-03T08:05:03-07:00"
+++
```

Within your post, you can easily include tweets, images, and gists:

```
{{< figure src="some/url/pic.jpg" caption="some caption" >}}
{{< tweet TWEET_ID >}}
{{< gist GIST_ID >}}
```

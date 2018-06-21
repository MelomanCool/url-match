# [Alpha] Url Match
Easily extract interesting bits of information from URLs.

Inspired by Clojure's [Compojure](https://github.com/weavejester/compojure) — awesome routing library.

Note: this library currently does not handle non-matching URLs. It only extracts parts from the matching ones.


## Example usage

```python
from url_match import make_schema, match

yt_be_schema = make_schema('https? youtu.be /:id {t=:ts}')
match(yt_be_schema, 'https://youtu.be/57Ykv1D0qEE?t=1m43s')
# => {'id': '57Ykv1D0qEE', 'ts': '1m43s'}
```


## Project Maturity
The project is in early stage of development, so anything could change.


## Installation
```
pip3 install git+https://github.com/MelomanCool/url-match.git#egg=url_match
```


## Schema syntax
Schema consists of four parts:
```
protocol hostname path query
```

They are separated by spaces.

Note: right now, **the query part is mandatory**. If you don't want to match any query parameters, just use `{}`.


### Protocol
Can be one of:  
`http`  
`https`  
`https?` — matches both http and https.


### Hostname
Consists of one or more subdomains, separated by the "." character. You can make some subdomains as optional, using ".?" after it.

Examples:  
`www.youtube.com` — matches only `www.youtube.com`  
`www.?youtube.com` — matches both `www.youtube.com` and `youtube.com`


### Path
Consists of several folders separated by the "/" character. A folder can be either name of a folder, like `foo`, or a keyword, like `:bar`. Names are matched as is, while keywords are used for name extraction.

The last "/" can be made optional, like so "/?".

Shortest possible path consists of a single character: "/", but in general it's better to use "/?".

Examples:  
`/` will match only the path `/`.  
`/?` will match empty path and `/`  
`/r/:subreddit` with the path `/r/photoshopbattles` will extract `{'subreddit': 'photoshopbattles'}`


### Query
Query's syntax consists of `{}`, containing pairs of the form `key=:val_name`, separated by spaces. Each key's is value extracted and will be stored under the name of the corresponding val_name.

The order of parameters doesn't matter. Treat `{}`-syntax as a dictionary.

Example: the pattern `{v=:id t=:ts}` with the query string `v=4YabUd9imQU&t=9m14s` will extract:
```python
{'id': '4YabUd9imQU', 'ts': '9m14s'}
```


# More Examples
```python
yt_schema = make_schema('https? www.?youtube.com /watch {v=:id t=:ts}')
match(yt_schema, 'https://www.youtube.com/watch?v=57Ykv1D0qEE&t=1m43s')
# => {'id': '57Ykv1D0qEE', 'ts': '1m43s'}

# note that now there is no "www." in the url
match(yt_schema, 'https://youtube.com/watch?v=57Ykv1D0qEE&t=1m43s')
# => {'id': '57Ykv1D0qEE', 'ts': '1m43s'}


reddit_schema = make_schema('https? www.?reddit.com /r/:subreddit/? {}')
match(reddit_schema, 'https://www.reddit.com/r/coolgithubprojects/')
# => {'subreddit': 'coolgithubprojects'}

# note the absence of the ending "/"
match(reddit_schema, 'https://www.reddit.com/r/coolgithubprojects')
# => {'subreddit': 'coolgithubprojects'}


reddit_thread_schema = make_schema('https? www.?reddit.com /r/:subreddit/comments/:thread_id/:thread_name/? {}') 
match(reddit_thread_schema, 
      'https://www.reddit.com/r/photoshopbattles/comments/8sgj7n/psbattle_english_football_team_riding_unicorns_in/')
# => {'subreddit': 'photoshopbattles', 'thread_id': '8sgj7n', 'thread_name': 'psbattle_english_football_team_riding_unicorns_in'}
```


## Why?
The library was created because I needed to extract parts of path and some query parameters from a YouTube url. Parsing whole URLs with regular expression was not an option, because query parameters can be listed in many different orders. [furl](https://github.com/gruns/furl) solves this problem, but I wanted something more declarative and specific.

In fact, current implementation uses both regular expessions and furl, applying patterns to different parts of a furl object. And the schema is parsed by [Lark](https://github.com/lark-parser/lark).

Replete – Redis autocomplete in Ruby
===

All the credit goes to Salvatore: [http://antirez.com/post/autocomplete-with-redis.html](http://antirez.com/post/autocomplete-with-redis.html) and [http://gist.github.com/574044](http://gist.github.com/574044).

Usage
-

Basic setup:

    require "replete"

    Replete.key = Nest.new("replete", Redis.connect)

Load test data:

    require "open-uri"

    Replete.index(open("http://antirez.com/misc/female-names.txt").read.split)

Now search:

    Replete.search("marcell")
    # => ["marcella", "marcelle", "marcellina", "marcelline"]

    Replete.search("marcell", 2)
    # => ["marcella", "marcelle"]

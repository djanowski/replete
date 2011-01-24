require "redis"
require "nest"

class Replete
  def self.index(words)
    iterate(words) { |w| key.zadd(0, w) }
  end

  def self.delete(words)
    iterate(words) { |w| key.zrem(w) }
  end

  def self.iterate(words)
    words.each do |word|
      size(word).times do |i|
        yield word[0...(i + 1)]
      end

      yield "#{word}*"
    end
  end

  def self.search(prefix, count = 50)
    start = key.zrank(prefix) or return []

    results = []

    while results.size < count
      key.zrange(start, start + BUFFER - 1).each do |entry|
        break count = results.size unless entry.index(prefix) == 0

        results << entry[0...-1] if entry[-1, 1] == "*" && results.size < count
      end

      start += BUFFER
    end

    results
  end

  BUFFER = 50 # This is not random, try to get replies < MTU size

  def self.key
    @key
  end

  def self.key=(key)
    @key = key
  end

  if "".respond_to?(:chars)
    def self.size(string)
      string.chars.count
    end
  else
    def self.size(string)
      string.size
    end
  end
end
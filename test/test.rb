require File.expand_path("../lib/replete", File.dirname(__FILE__))

require "cutest"

Replete.key = Nest.new("replete", Redis.connect)
Replete.index(open("./test/names.txt").read.split) unless Replete.key.exists

test "auto-completes words" do
  assert Replete.search("marcell") == %w(marcella marcelle marcellina marcelline)
  assert Replete.search("marcellina") == %w(marcellina)
  assert Replete.search("foobar").empty?
end

test "takes a maximum parameter" do
  assert Replete.search("marcell", 2) == %w(marcella marcelle)
end

test "allows deletion of words" do
  names = %w{
    abagael
    abagail
    abbe
    abbey
  }

  Replete.delete(names)

  names.each { |name| assert Replete.search(name).size == 0 }
end
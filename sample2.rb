#!/usr/bin/ruby

def test
  yield
end
test{ puts "Hello world"}
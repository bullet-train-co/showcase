showcase.description simple_format <<~end_of_string
  This shows how to use Showcase with Plain Ruby. Action View expects the file to end in .ruby instead of .rb.

  Find me in app/views/showcase/previews/_plain_ruby.html.ruby
end_of_string

showcase.sample "Upcase", syntax: :ruby do
  "hello".upcase
end

showcase.sample "+ Reverse", syntax: :ruby do |sample|
  sample.render do
    concat "hello".upcase
    concat "\n"
    concat "hello".reverse
  end

  sample.extract do
    "hello".upcase
    "hello".reverse
  end
end

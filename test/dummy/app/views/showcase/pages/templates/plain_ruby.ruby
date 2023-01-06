showcase.sample "Upcase" do
  "hello".upcase
end

showcase.sample "+ Reverse" do |sample|
  sample.preview do
    concat "hello".upcase
    concat "\n"
    concat "hello".reverse
  end

  sample.extract do
    "hello".upcase
    "hello".reverse
  end
end

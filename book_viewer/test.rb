query = "test"
test_string = "This is a test string dudes"
p test_string.split(query).join("<strong>#{query}</strong>")
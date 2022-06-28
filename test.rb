require 'RTesseract'
# require 'Tesseract'

image = RTesseract.new("receipt.jpeg")
puts image.to_s # Getting the value



# e = Tesseract::Engine.new {|e|
#   e.language  = :eng
#   e.blacklist = '|'
# }

# puts e.text_for('receipt.jpeg').strip 
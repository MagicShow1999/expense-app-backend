require 'RTesseract'
require 'FileUtils'

class ExpenseController < ApplicationController
  after_action :set_csrf_cookie
  skip_before_action :verify_authenticity_token


  def set_csrf_cookie
    if protect_against_forgery?
      cookies['XSRF-TOKEN'] = form_authenticity_token
    end
  end

  def index
    render json: {
      "msg" => "hello world"
    }
  end

  def parse_info(raw_info)
    lines = raw_info.split("\n")
    info = Hash.new
    lines.each_with_index { |line, index|
      if index == 0
        info["restaurant_name"] = line
      else
        amount = line.match(/\$?[0-9,]+(\.[0-9]{1,2})?/).to_s
        if amount.length > 3
          info["amount"] = amount
        end
        date = line.match(/((?:19|20)\d{2}[\/\.]\d{1,2}[\/\.]\d{1,2})|(\d{1,2}[\/\.]\d{1,2}[\/\
        .](19|20)?\d{2})/)
        if date
          puts date.to_s
          info["date"] = date.to_s
        end
      end
    }
    info
  end
  # /^(0[1-9]|1[012])[-\/.](0[1-9]|[12][0-9]|3[01])([-\/.](?:19|20)\d\d)$/
  def upload
    # puts request.body.read
    if params[:file]
      file = params[:file]
      path = "public/" + params[:file].original_filename

      File.open(path, "wb") {|f| f.write(params[:file].read)}
      image = RTesseract.new(path)
      raw_info = image.to_s
      info = parse_info(raw_info)
      render json: {
        "info" => info
      }
    else 
      raise "No file found"
    end
  end
end

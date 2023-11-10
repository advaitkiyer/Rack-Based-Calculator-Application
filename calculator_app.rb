require 'rack'
require 'json'
require 'rack/handler/webrick'

class CalculatorApp
    def call(env)
        request = Rack::Request.new(env)
        response = handle_request(request)
        response.finish
    end

    def handle_request(request)
        case request.path_info
        when '/add'
            if request.get?
                show_addition_form
            elsif request.post?
                perform_addition(request)
            end
        when '/subtract'
            if request.get?
                show_subtraction_form
            elsif request.post?
                perform_subtraction(request)
            end
        else
            not_found_response
        end
    end
    
    def show_addition_form
        # Generate HTML form for addition
        html = <<~HTML
            <html>
            <body>
            <h1>Addition</h1>
            <form action = "/add" method="POST">
            <input type = "number" name ="a" placeholder="Enter number a" required><br>
            <input type = "number" name ="b" placeholder="Enter number b" required><br>
            <input type = "submit" value = "Add">
            </form>
            </body>
            </html>
        HTML

        Rack::Response.new(html)
    end
    def perform_addition(request)
        # Extract numbers from request parameters and perform addition
#        data = JSON.parse(request.body.read)
        data = request.params
        a = data['a'].to_i
        b = data['b'].to_i
        sum = a+b 
        response_data = {'result': sum}
        
        Rack::Response.new(response_data.to_json, 200, {'Content_Type' => 'application/json' })
    end
    def show_subtraction_form
        # Generate HTML form for subtraction
        html = <<~HTML
            <html>
            <body>
            <h1>Subtraction</h1>
            <form action = "/subtract" method="POST">
            <input type = "number" name ="a" placeholder="Enter number a" required><br>
            <input type = "number" name ="b" placeholder="Enter number b" required><br>
            <input type = "submit" value = "Subtract">
            </form>
            </body>
            </html>
        HTML

        Rack::Response.new(html)
    end
    def perform_subtraction(request)
        # Extract numbers from request parameters and perform subtraction
        data = request.params
#        data = JSON.parse(request.body.read)
        a = data['a'].to_i
        b = data['b'].to_i
        difference = a-b 
        response_data = {'result': difference}

        Rack::Response.new(response_data.to_json, 200, {'Content_Type' => 'application/json' })
    end
    def not_found_response
        Rack::Response.new('Not Found', 404)
    end 
end


app = CalculatorApp.new
Rack::Handler::WEBrick.run app,
Port: 9292


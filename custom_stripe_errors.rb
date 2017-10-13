ustomStripeErrors
  def stripe_error_check(e)
    if e.instance_of?(Stripe::CardError => e)
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Charge ID is: #{err[:charge]}"
      # The following fields are optional
      puts "Code is: #{err[:code]}" if err[:code]
      puts "Decline code is: #{err[:decline_code]}" if err[:decline_code]
      puts "Param is: #{err[:param]}" if err[:param]
      puts "Message is: #{err[:message]}" if err[:message]
    elsif e.instance_of?(Stripe::RateLimitError => e)
      # Too many requests made to the API too quickly
      flash[:alert] = 'Stripe Error: You have made too many requests to the API too quickly.'
    elsif e.instance_of?(Stripe::InvalidRequestError => e)
      # Invalid parameters were supplied to Stripe's API
      flash[:alert] = 'Stripe Error: You have supplied invalid Params'
    elsif e.instance_of?(Stripe::AuthenticationError => e)
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      flash[:alert] = 'Stripe Error: Authentication with Stripe\'s API failed'
    elsif e.instance_of?(Stripe::APIConnectionError => e)
      # Network communication with Stripe failed
      flash[:alert] = 'Stripe Error: Network communication with Stripe failed.'
    elsif e.instance_of?(Stripe::StripeError => e)
      # Display a very generic error to the user, and maybe send
      # yourself an email
      flash[:alert] = 'Stripe Error: This is a generic error from Stripe. Needs investigation.'
    else
      flash[:alert] = e.to_s
      puts e
    end
  end
end

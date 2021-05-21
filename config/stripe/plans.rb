Stripe.plan :yearly_subscription do |plan|
  # plan name as it will appear on credit card statements
  plan.name = 'Fake News 12 month subscription'

  # amount in cents. This is 6.99
  plan.amount = 10000

  plan.currency = 'sek'

  plan.interval = 'month'

  plan.interval_count = 12

end

Stripe.plan :half_year_subscription do |plan|
  plan.name = 'Fake News 6 month subscription'

  plan.amount = 11000

  plan.currency = 'sek'

  plan.interval = 'month'

  plan.interval_count = 6
end

Stripe.plan :monthly_subscription do |plan|
  plan.name = 'Fake News 12 month subscription'

  plan.amount = 13000

  plan.currency = 'sek'

  plan.interval = 'month'

  plan.interval_count = 1
end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.

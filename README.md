# Stripe Subscription Management

This application is designed to manage subscriptions using Stripe. It handles the creation, updating, and cancellation of subscriptions based on Stripe webhooks.

## Prerequisites

1. **Ruby 3.2.2**: Ensure you have Ruby version 3.2.2 installed.
2. **PostgreSQL**: Make sure PostgreSQL is installed and running on your machine.
3. **Stripe CLI**: Ensure you have the [Stripe CLI](https://docs.stripe.com/stripe-cli) installed and running on your machine.
4. **Stripe account**: Ensure you have a Stripe account otherwise [Register](https://dashboard.stripe.com/register) a free Stripe account.


## Setup

### 1. Clone the Repository

```sh
git clone git@github.com:ramir2426/stripe_subscription_app.git
cd stripe_subscription_app
```
### 2.Install Dependencies
Install the required gems:
```sh
bundle install
```
### 3. Set Up the Database
Create and migrate the database:
```sh
rails db:create db:migrate
```

### 4. Strip CLI
Ensure you have the Stripe CLI installed and are logged in:
```sh
stripe login
```
You can download the Stripe CLI from [Stripe CLI Documentation](https://docs.stripe.com/stripe-cli).

### 5. Environment Variables
Duplicate the .env_example file and rename it to .env:
```sh
cp .env_example .env
```
Edit the .env file to include your actual Stripe keys:

- **STRIPE_SECRET_KEY**: Your Stripe secret key.
- **STRIPE_SECRET_KEY**: The webhook secret obtained from Stripe CLI.

To get the STRIPE_WEBHOOK_SECRET, use the following command and follow the instructions

```sh
stripe listen --forward-to localhost:3000/webhooks/stripe
```
Stripe will provide a webhook secret that you need to add to your .env file.

### 6. Testing
To run the test suite, use:
```sh
bundle exec rspec
```

### 7. Rails Server
Start the Rails server on port 3000:
```sh
rails server
```
## Usage

- Create a subscription on the [Stripe dashboard](https://dashboard.stripe.com)
- The subscription will initially be created with a status of unpaid.
- Pay the invoice for the subscription through the Stripe UI.
- The subscription status will automatically update to paid.
- If you cancel the subscription, the status will update to canceled. 
## Webhooks
The application listens to the following Stripe webhooks:

- customer.subscription.created
- invoice.payment_succeeded
- customer.subscription.deleted

Ensure your Stripe CLI is forwarding these events to your local server:
```sh
stripe listen --forward-to localhost:3000/webhooks/stripe
```

## Checking Subscription Status via Rails Console

1. Open the Rails console:
```sh
rails console
```

2. Find the subscription by its Stripe subscription ID:
```sh
subscription = Subscription.find_by(stripe_subscription_id: 'your_stripe_subscription_id')
```

3. Check the subscription's status:
```sh
subscription.status
```

## Contact
For any questions or issues, please contact [email](mailto:ramir2426@gmail.com).


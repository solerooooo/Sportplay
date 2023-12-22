const express = require('express');
const stripe = require('stripe')('sk_test_51OQ77jL9jiXabeNWIWpB3NvVkYun6KGfOlV7JBtkjDd1VpKyU8QI4ZSb2GtXcexsNYHZVI5Ii2avBL1ZVj2slMkB00VQ0wRdaZ');

const app = express();
app.use(express.json());

app.post('/create-payment-intent', async (req, res) => {
  try {
    const paymentIntent = await stripe.paymentIntents.create({
        amount: 100,  // Amount in cents
        currency: 'rm',
        // Add other parameters as needed
    });
    res.json({ clientSecret: paymentIntent.client_secret });
  } catch (err) {
    console.error(err);
    res.status(500).end();
  }
});

const PORT = 4242;  // Choose a port
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

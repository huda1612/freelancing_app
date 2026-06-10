const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
dotenv.config();
console.log(process.env.STRIPE_SECRET_KEY);
const host = process.env.NEXT_PUBLIC_HOST
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
//توابع الresponse الموحدة
const {
  success,
  badRequest,
  serverError
} = require("./utils/response");


//root
app.get("/", (req, res) => {
  res.send("Stripe backend is running 🚀");
});

// 1. Create Connect Account
app.post("/create-account", async (req, res) => {
  try {

    const account = await stripe.accounts.create({
      type: "express",
    });

    return success(res, {
      accountId: account.id,
    });

  } catch (error) {
    return serverError(res, error);
  }
});

// 2. Create Onboarding Link
app.post("/create-account-link", async (req, res) => {
  const { accountId } = req.body;

  const accountLink = await stripe.accountLinks.create({
    account: accountId,
    refresh_url: `${host}/reauth`,
    // return_url: `${host}/success`,
    return_url: `freelancity://deeplinks/stripe-success`,
    type: "account_onboarding",
  });

  res.status(200).json({ url: accountLink.url });
});

//انشاء حساب ورابط كمان بنفس الوقت وبرد ال2
app.post("/create-account-and-link", async (req, res) => {
  try {
    const account = await stripe.accounts.create({
      type: "express",
    });

    const accountLink = await stripe.accountLinks.create({
      account: account.id,
      refresh_url: `${host}/reauth`,
      return_url: `${host}/success`,
      type: "account_onboarding",
    });

    return success(res, {
      accountId: account.id,
      url: accountLink.url,
    });

  } catch (error) {
    return serverError(res, error);
  }
});

// فتح لوحة تحكم Stripe Express
app.post("/dashboard-link", async (req, res) => {
  try {
    console.log("dash board link request");
    const { accountId } = req.body;

    if (!accountId) {
      return badRequest(res, "accountId is required");
    }

    const loginLink = await stripe.accounts.createLoginLink(
      accountId
    );

    return success(res, {
      url: loginLink.url,
    });

  } catch (error) {
    return serverError(res, error);
  }
});

//!!!!!!!!!!!! هاد مفروض يعدي توجيه المستخدم للتطبيق بعد ما ينجح اعداد الحساب 
app.get("/success", (req, res) => {
  res.send("Success");
});

//بحال صارت مشكله فالستريب رح يوجهني لهالنقطه لان انا محددتها بالريفريش
app.post("/reauth", async (req, res) => {
  const { accountId } = req.body;

  const accountLink = await stripe.accountLinks.create({
    account: accountId,
    refresh_url: `${host}/reauth`,
    return_url: `${host}/success`,
    type: "account_onboarding",
  });

    res.redirect(accountLinks.url)
 
});


//لحذف حساب
app.post("/delete-account", async (req, res) => {
  try {
    const { accountId } = req.body;

     if (!req.body.accountId) {
      return badRequest(res, "accountId is required");
    }
    console.log(accountId);
    const deleted = await stripe.accounts.del(accountId);
    
    res.status(200).json({
      success: true,
      deleted,
    });

  } catch (error) {
     return serverError(res, error);
  }
});

//للتأكد من حالة الحساب اذا مكمل الاعداد ولا لا 
app.post("/account-status", async (req, res) => {
  try {
    const { accountId } = req.body;

    if (!accountId) {
      return badRequest(res, "accountId is required");
    }

    const account = await stripe.accounts.retrieve(accountId);

    const stripeOnboardingCompleted =
      account.charges_enabled && account.payouts_enabled;

    return success(res, {
      accountId: account.id,
      stripeOnboardingCompleted : stripeOnboardingCompleted,
      charges_enabled: account.charges_enabled,
      payouts_enabled: account.payouts_enabled,
      //new
      business_type: account.business_type,
      currently_due: account.requirements?.currently_due,
      eventually_due: account.requirements?.eventually_due,
      disabled_reason: account.requirements?.disabled_reason,
    });

  } catch (error) {
    return serverError(res, error);
  }
});

// 3. PaymentIntent + Commission
app.post("/payment-intent", async (req, res) => {
  try{
  const { amount, accountId } = req.body;
    if (!amount) {
      return badRequest(res, "amount is required");
    }
    if (!accountId) {
      return badRequest(res, "accountId is required");
    }
    console.log("amount =", amount);
console.log("accountId =", accountId);
    const account = await stripe.accounts.retrieve(accountId);
console.log(account);

  const paymentIntent = await stripe.paymentIntents.create({
    amount: Math.round(amount * 100),
    currency: "usd",
    // payment_method_types: ["card"],
  automatic_payment_methods: {
    enabled: true,
  },
    application_fee_amount: Math.round(amount * 0.02 * 100),
    transfer_data: {
      destination: accountId,
    },
  });

  console.log(paymentIntent);
  console.log(paymentIntent.transfer_data);
console.log(paymentIntent.application_fee_amount);
  return success(res, {
  clientSecret: paymentIntent.client_secret,
  });

  // res.json(paymentIntent);
}catch(error){
    return serverError(res, error);
}

});

//ما مستخدم
app.post("/create-checkout-session", async (req, res) => {
  try {
    console.log("paaaaayammmment staaart");
    const { amount, accountId, taskId } = req.body;

    if (!amount || !accountId) {
      return badRequest(res, "missing data");
    }

    const session = await stripe.checkout.sessions.create({
      mode: "payment",
payment_method_types: ["card"],
      line_items: [
        {
          price_data: {
            currency: "usd",
            product_data: {
              name: `Task Payment #${taskId || ""}`,
            },
            unit_amount: Math.round(amount * 100),
          },
          quantity: 1,
        },
      ],

      // payment_intent_data: {
      //   application_fee_amount: Math.round(amount * 0.02 * 100),
      //   transfer_data: {
      //     destination: accountId,
      //   },
      // },
// automatic_payment_methods: {
//   enabled: true,
// },
      success_url: `${host}/payment-success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${host}/payment-cancel`,
    });
    console.log("session : ");
    console.log(session );

    return success(res, {
      url: session.url,
    });
  } catch (error) {
    return serverError(res, error);
  }
});

app.listen(3000 , "0.0.0.0", () => {
  console.log("Server running on port 3000 🚀");
  // while(true){
  //   console.log("SERVER IS ALIVE");
  // }
});
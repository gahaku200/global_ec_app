/* eslint-disable @typescript-eslint/no-var-requires */
import * as functions from "firebase-functions";

const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

// PaymentIntent の作成
export const createPaymentIntent = functions.https.onCall(async (req) => {
  const amount = req.amount; // リクエストデータから金額を取得
  let customerId = req.customerId; // リクエストデータからcustomerIdを取得
  try {
    if (customerId === "") {
      // customerIdが存在しない場合は新しい顧客を作成
      const customer = await stripe.customers.create();
      customerId = customer.id;
    }
    // Ephemeral Key (一時的なアクセス権を付与するキー)を作成
    // https://stripe.com/docs/payments/accept-a-payment?platform=ios&ui=payment-sheet#add-server-endpoint
    const ephemeralKey = await stripe.ephemeralKeys.create(
      {customer: customerId},
      {apiVersion: "2022-11-15"}
    );
    // PaymentIntent の作成
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: "usd",
      customer: customerId,
      automatic_payment_methods: {
        enabled: true,
      },
    });
    // アプリ側で必要な値を返却
    return {
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer: customerId,
    };
  } catch (error) {
    console.error("error: %j", error);
    return {
      title: "An Error occurred",
      message: error,
    };
  }
});

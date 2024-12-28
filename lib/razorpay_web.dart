// // import 'dart:html' as html;
// // import 'dart:js' as js;

// // class RazorpayHelper {
// //   static void openCheckout({
// //     required String apiKey,
// //     required String amount,
// //     required String currency,
// //     required String name,
// //     required String description,
// //     required String orderId,
// //     required Function(String paymentId) onSuccess,
// //     required Function(String error) onFailure,
// //   }) {
// //     final options = {
// //       "key": apiKey,
// //       "amount": amount, // Amount in the smallest currency unit
// //       "currency": currency,
// //       "name": name,
// //       "description": description,
// //       "order_id": orderId,
// //       "prefill": {
// //         "email": "customer@example.com",
// //         "contact": "9876543210",
// //       },
// //       "theme": {
// //         "color": "#3399cc",
// //       },
// //     };

// //     // Ensure Razorpay script is loaded
// //     final script = html.ScriptElement()
// //       ..src = "https://checkout.razorpay.com/v1/checkout.js"
// //       ..defer = true;

// //     script.onLoad.listen((_) {
// //       // JavaScript Interop to invoke Razorpay Checkout
// //       try {
// //         final razorpay =
// //             js.JsObject(js.context['Razorpay'], [js.JsObject.jsify(options)]);

// //         // Define payment success handler
// //         razorpay.callMethod('on', [
// //           'payment.success',
// //           js.allowInterop((response) {
// //             onSuccess(response['razorpay_payment_id']);
// //           }),
// //         ]);

// //         // Define payment error handler
// //         razorpay.callMethod('on', [
// //           'payment.error',
// //           js.allowInterop((response) {
// //             print("Failed to load Razorpay script.");
// //             onFailure(response['error']['description']);
// //           }),
// //         ]);

// //         // Open Razorpay Checkout
// //         razorpay.callMethod('open');
// //       } catch (e) {
// //         print('Error initializing Razorpay: $e');
// //       }
// //     });

// //     html.document.body!.append(script);
// //   }
// // }

// import 'dart:html' as html;
// import 'dart:js' as js;

// class RazorpayHelper {
//   /// Opens Razorpay Checkout
//   static void openCheckout({
//     required String apiKey,
//     required String amount,
//     required String currency,
//     required String name,
//     required String description,
//     required String orderId,
//     required Function(String paymentId, String signature) onSuccess,
//     required Function(String error) onFailure,
//   }) {
//     // Razorpay Checkout options
//     final options = {
//       "key": apiKey,
//       "amount": amount,
//       "currency": currency,
//       "name": name,
//       "description": description,
//       "order_id": orderId,

//       "theme": {
//         "color": "#3399cc",
//       },
//       "debug": true, // Enable Razorpay debug mode
//     };

//     // Ensure the Razorpay script is loaded
//     final script = html.ScriptElement()
//       ..src = "https://checkout.razorpay.com/v1/checkout.js"
//       ..defer = true;

//     script.onLoad.listen((_) {
//       print("Razorpay script loaded successfully");
//       try {
//         // Initialize Razorpay Checkout
//         final razorpay =
//             js.JsObject(js.context['Razorpay'], [js.JsObject.jsify(options)]);

//       print("Options being sent to Razorpay: ${options.toString()}");

//         print("Razorpay initialized");

//         // Handle payment success
//         // razorpay.callMethod('on', [
//         //   'payment.success',
//         //   js.allowInterop((response) {
//         //     print("payment.success callback invoked");
//         //     final paymentId = response['razorpay_payment_id'];
//         //     final signature = response['razorpay_signature'];
//         //     print("Payment ID: $paymentId");
//         //     print("Signature: $signature");

//         //     if (paymentId != null && signature != null) {
//         //       onSuccess(paymentId, signature);
//         //     } else {
//         //       print("Invalid payment.success response");
//         //       onFailure('Invalid response from Razorpay.');
//         //     }
//         //   }),
//         // ]);
//         razorpay.callMethod('on', [
//           'payment.success',
//           js.allowInterop((response) {
//             if (response == null) {
//               print("No response received in payment.success");
//             } else {
//               print("payment.success triggered");
//               print("Response: $response");
//             }
//           }),
//         ]);

//         print("Event listener for payment.success added");

//         // Handle payment failure
//         razorpay.callMethod('on', [
//           'payment.error',
//           js.allowInterop((response) {
//             print("payment.error callback invoked");
//             final errorDescription =
//                 response['error']['description'] ?? 'Unknown error occurred.';
//             print("Error Description: $errorDescription");
//             onFailure(errorDescription);
//           }),
//         ]);

//         print("Event listener for payment.error added");

//         // Open Razorpay Checkout
//         razorpay.callMethod('open');
//         print("Razorpay Checkout Opened");
//       } catch (e) {
//         print("Error initializing Razorpay: $e");
//         onFailure('Error initializing Razorpay: $e');
//       }
//     });

//     script.onError.listen((_) {
//       print("Failed to load Razorpay script");
//       onFailure('Failed to load Razorpay script.');
//     });

//     // Append the Razorpay script to the HTML body
//     html.document.body?.append(script);
//   }
// }
import 'dart:html' as html;
import 'dart:js' as js;

class RazorpayHelper {
  /// Opens Razorpay Checkout
  static void openCheckout({
    required String apiKey,
    required String amount,
    required String currency,
    required String name,
    required String description,
    required String orderId,
    required Function(String paymentId, String signatureId) onSuccess,
    required Function(String error) onFailure,
  }) {
    // Razorpay Checkout options
    final options = {
      "key": apiKey,
      "amount": amount,
      "currency": currency,
      "name": name,
      "description": description,
      "order_id": orderId,
      "prefill": {},
      "theme": {
        "color": "#3399cc",
      },
      "handler": js.allowInterop((response) {
        try {
          // Handle payment success response
          final paymentId = response['razorpay_payment_id'];
          final signatureId = response['razorpay_signature'];

          if (paymentId != null && signatureId != null) {
            print(
                "Payment successful. Payment ID: $paymentId, Signature ID: $signatureId");
            onSuccess(paymentId, signatureId);
          } else {
            throw Exception("Payment ID or Signature is null in response.");
          }
        } catch (e) {
          print("Error in success handler: $e");
          onFailure('Error handling payment success: $e');
        }
      }),
    };

    // Ensure the Razorpay script is loaded
    final script = html.ScriptElement()
      ..src = "https://checkout.razorpay.com/v1/checkout.js"
      ..defer = true;

    script.onLoad.listen((_) {
      print("Razorpay script loaded successfully");
      try {
        // Initialize Razorpay Checkout
        final razorpay =
            js.JsObject(js.context['Razorpay'], [js.JsObject.jsify(options)]);

        print("Options being sent to Razorpay: ${options.toString()}");

        // Open Razorpay Checkout
        razorpay.callMethod('open');
        print("Razorpay Checkout Opened");
      } catch (e) {
        print("Error initializing Razorpay: $e");
        onFailure('Error initializing Razorpay: $e');
      }
    });

    script.onError.listen((_) {
      print("Failed to load Razorpay script");
      onFailure('Failed to load Razorpay script.');
    });

    // Append the Razorpay script to the HTML body
    html.document.body?.append(script);
  }
}

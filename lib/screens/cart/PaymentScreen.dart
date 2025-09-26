// payment_screen.dart
import 'package:flutter/material.dart';
import '../../services/order_service.dart';
// import 'package:flutter_paystack/flutter_paystack.dart'; // later

class PaymentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;
  final String address;

  const PaymentScreen({
    super.key,
    required this.cartItems,
    required this.total,
    required this.address,
  });

  // 🚧 Paystack setup (for later)
  // final PaystackPlugin _paystack = PaystackPlugin();
  //
  // Future<void> _payWithPaystack(BuildContext context) async {
  //   Charge charge = Charge()
  //     ..amount = (total * 100).toInt() // amount in kobo
  //     ..email = "testuser@example.com"
  //     ..currency = "NGN"
  //     ..reference = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //   CheckoutResponse response = await _paystack.checkout(
  //     context,
  //     method: CheckoutMethod.card,
  //     charge: charge,
  //   );
  //
  //   if (response.status == true) {
  //     await OrderService.placeOrder(
  //       items: cartItems,
  //       total: total,
  //       address: address,
  //       paymentMethod: "Paystack",
  //     );
  //     Navigator.popUntil(context, (route) => route.isFirst);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Order placed successfully!")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Payment failed, try again")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // 🚧 Pay with Paystack (commented out for now)
            // ElevatedButton(
            //   onPressed: () => _payWithPaystack(context),
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //   child: const Text("Pay with Paystack"),
            // ),
            // const SizedBox(height: 20),

            // ✅ Cash on Delivery (active now)
            ElevatedButton(
  onPressed: () async {
    try {
      await OrderService.placeOrder(
        items: cartItems,
        total: total,
        address: address,
        paymentMethod: "Cash on Delivery",
      );

      // ✅ Go back to Home instead of Onboarding
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home', // replace with your actual home route name
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order failed: $e")),
      );
    }
  },
  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
  child: const Text("Cash on Delivery"),
),
          ],
        ),
      ),
    );
  }
}

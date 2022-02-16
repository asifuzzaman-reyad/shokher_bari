import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shokher_bari/dashboard.dart';

class CheckoutOrder extends StatelessWidget {
  const CheckoutOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout (3/3)')),

      //
      body: Column(
        children: [
          // stepper
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: IconStepper(
                    enableNextPreviousButtons: false,
                    activeStepBorderWidth: 2,
                    stepColor: Colors.transparent,
                    activeStepColor: Colors.transparent,
                    activeStepBorderColor: Colors.transparent,
                    activeStepBorderPadding: 0,
                    lineColor: Colors.grey,
                    lineLength: 85,
                    lineDotRadius: 2,
                    icons: const [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.black87,
                      ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.black87,
                      ),
                      Icon(
                        Icons.adjust,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Delivery address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Payment method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Order placed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Divider(),

          // select address
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Order placed successfully',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  //
                  Text(
                    'Congratulations. Your order successfully placed.',
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You can track your order number ',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                      SelectableText(
                        '#456464646',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.orange,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Dashboard()),
                      (_) => false);
                },
                child: const Text('Continue shopping'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

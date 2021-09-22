import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart' as pay;
import 'package:stripe_payment/stripe_payment.dart';
class StripeHome extends StatefulWidget {
  StripeHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _StripeHomeState createState() => _StripeHomeState();
}

class _StripeHomeState extends State<StripeHome> {
  static const String STRIPE_KEY_TEST =
      "pk_test_51JGK1bF03rmokyhHx9qDjqf7jTBYgFjikJKMTE9ahuYSse2pHdtGhDWwWcls01YkcTY7hiMS85LqclTc6E2EcZdE00BZr2ejMz";
  String tokenCard="";
  int count = 1;
  String? _error;
bool view=false;
  final CreditCard testCard = CreditCard(
    number: '4242424242424242',
    expMonth: 12,
    expYear: 25,
    name: 'Phạm Văn Phương',
    cvc: '133',
    addressLine1: 'Address 1',
    addressLine2: 'Address 2',
    addressCity: 'City',
    addressState: 'CA',
    addressZip: '1337',
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: STRIPE_KEY_TEST,
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    setState(() {
      _error = error.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset("assets/images/image.jpg"),
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Price 9\$",style: TextStyle(fontSize: 23),)),
            _buildAddProduct(),
            InkWell(
              onTap: (){
                Get.dialog(_methodPayment(),
                    barrierDismissible: true);
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Thanh toán (${9*count})\$",style: TextStyle(fontSize: 18),)),
            ),
            SizedBox(
              height: 50,
            ),
            view?Text("Thanh toán thành công"):Container(),
            view?Text( "token:$tokenCard"):Container(),
          ],
        ),
      ),
    );
  }

  _buildAddProduct() {
    return Container(
      padding: EdgeInsets.only(top: 0, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (count > 1) count--;
              });

            },
            child: Icon(
              Icons.remove_circle,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            count.toString(),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                count++;
              });

            },
            child: Icon(
              Icons.add_circle,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
  _methodPayment() {
    return  Center(
      child: Container(
        height: 400,
        width: 330,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color:Colors.white),
        child: Scaffold(
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("Hình thức thanh toán",style: TextStyle(fontSize: 18),),
                ),
                Spacer(),
                InkWell(
                    child: Center(
                      child: Container(
                          width: 280,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.black)),
                          child: Center(
                            child: Text("Apple"),
                          )),
                    ),
                    onTap: () {
                      // _paymentPayMe();
                    }),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                    child: Container(
                        width: 280,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.black)),
                        child: Center(
                          child: Text("GooglePay"),
                        )),
                    onTap: () {

                    }),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                    child: Container(

                        width: 280,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.black)),
                        child: Center(
                          child: Text("Credit Card"),
                        )),
                    onTap: () {
                      paymentCard();
                    }),
                SizedBox(
                  height: 15,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _paymentGooglePay() async {
  }
  paymentCard() {
    StripePayment.createTokenWithCard(
      testCard,
    ).then((token) {
      print(token.tokenId);
      setState(() {
        tokenCard=token.tokenId!;
       view=true;
      });
      Get.back();
    }).catchError(setError);
  }
}

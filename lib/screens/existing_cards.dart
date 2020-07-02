import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:thriftit/db/payment-service.dart';

class ExistingCards extends StatefulWidget {
  ExistingCards({Key key}) : super(key: key);

  @override
  _ExistingCardsState createState() => _ExistingCardsState();
}

class _ExistingCardsState extends State<ExistingCards> {

  payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: '2500',
        currency: 'USD',
        card: stripeCard
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        )
    ).closed.then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.red[300]),
        title: Text('Your cards',style: TextStyle(color: Colors.red[300]),),
        actions: <Widget>[

        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('CreditCard').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const Text('Loading cards...'));
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  var card = snapshot.data.documents[index];
                  return InkWell(
                    onTap: () {
                      payViaExistingCard(context, card);
                    },
                    child: CreditCardWidget(
                      cardNumber: snapshot.data.documents[index]['CardNumber'] ,
                      expiryDate: snapshot.data.documents[index]['expiryDate'],
                      cardHolderName: snapshot.data.documents[index]['cardHolderName'],
                      cvvCode: snapshot.data.documents[index]['cvvCode'],
                      showBackView: false,
                    ),
                  );
                });
          }),
    );
  }
  }




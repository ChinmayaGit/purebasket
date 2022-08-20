import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purebasket/Config/config.dart';
import 'package:purebasket/Orders//placeOrder.dart';
import 'package:purebasket/Widgets/customAppBar.dart';
import 'package:purebasket/Widgets/loadingWidget.dart';
import 'package:purebasket/Widgets/wideButton.dart';
import 'package:purebasket/Models//address.dart';
import 'package:purebasket/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{
  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(

    );
  }

  noAddressCard() {
    return Card(

    );
  }
}

class AddressCard extends StatefulWidget {

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {

    return InkWell(

    );
  }
}





class KeyText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}

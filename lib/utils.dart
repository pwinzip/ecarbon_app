import 'package:flutter/material.dart';

PreferredSize createAppbar(BuildContext context,
    {bool isBack = false, double leftPad = 30}) {
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, 200.0),
    child: Container(
      height: 150,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF91CA6B), Color(0xFF36BEBE)]),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9E9E9E),
            blurRadius: 20.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: leftPad, top: 20.0, bottom: 4.0),
        child: Row(
          children: [
            isBack
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ))
                : Container(),
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("assets/images/plant.png")),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'eCarbon Application',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  "Science and Digital Innovation",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[300]),
                ),
                Text(
                  "Thaksin University",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[300]),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Padding buildNumberInput(
    BuildContext context, TextEditingController controller, String suffix) {
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            suffixText: suffix,
            border: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}

class ReusableGradientCard extends StatelessWidget {
  const ReusableGradientCard({
    super.key,
    required this.colour,
    required this.cardChild,
  });
  final List<Color> colour;
  final Widget cardChild;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      // margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        // color: colour,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colour),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: cardChild,
    );
  }
}

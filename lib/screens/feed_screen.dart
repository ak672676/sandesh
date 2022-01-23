import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:sandesh/utils/colors.dart';
import 'package:sandesh/utils/gloal_variables.dart';
import 'package:sandesh/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset("assets/ic_instagram.svg",
                  color: primaryColor, height: 32),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.messenger_outline),
                )
              ],
            ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(
                  snap: snapshot.data!.docs[index],
                );
              },
            );
          }),
    );
  }
}

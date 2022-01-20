import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:sandesh/screens/add_post_screen.dart';
import 'package:sandesh/screens/feed_screen.dart';
import 'package:sandesh/screens/profile_screen.dart';
import 'package:sandesh/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("Notifiction"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

import "package:flutter/material.dart";
import 'package:sandesh/screens/add_post_screen.dart';
import 'package:sandesh/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text("Search"),
  AddPostScreen(),
  Text("Notifiction"),
  Text("Profile"),
];

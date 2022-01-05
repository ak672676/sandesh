import "package:flutter/material.dart";
import 'package:sandesh/screens/add_post_screen.dart';
import 'package:sandesh/screens/feed_screen.dart';
import 'package:sandesh/screens/profile_screen.dart';
import 'package:sandesh/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("Notifiction"),
  ProfileScreen(),
];

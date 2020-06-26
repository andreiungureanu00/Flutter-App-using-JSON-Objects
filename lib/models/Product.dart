import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String title;
  // ignore: non_constant_identifier_names
  final String short_description;
  final String imageUrl;
  final int price;
  final String details;

  Product(
      this.id, this.title, this.short_description, this.imageUrl, this.price, this.details);
}
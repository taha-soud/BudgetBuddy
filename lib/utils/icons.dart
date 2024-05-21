import 'package:flutter/material.dart';

IconData getIconData(String icon) {
  switch (icon) {
    case 'Icons.local_dining':
      return Icons.local_dining;
    case 'Icons.fastfood':
      return Icons.fastfood;
    case 'Icons.emoji_food_beverage_rounded':
      return Icons.emoji_food_beverage_rounded;

    case 'Icons.local_taxi':
      return Icons.local_taxi;

    case 'Icons.airplanemode_on':
      return Icons.airplanemode_on;

    case 'Icons.build':
      return Icons.build;

    case 'Icons.local_parking':
      return Icons.local_parking;

    case 'Icons.local_gas_station':
      return Icons.local_gas_station;

    case 'Icons.hotel':
      return Icons.hotel;

    case 'Icons.child_care':
      return Icons.child_care;

    case 'Icons.pets':
      return Icons.pets;

    case 'Icons.local_library':
      return Icons.local_library;

    case 'Icons.work_history':
      return Icons.work_history;

    case 'Icons.shopping_bag':
      return Icons.shopping_bag;

    case 'Icons.monitor_heart_sharp':
      return Icons.monitor_heart_sharp;

    case 'Icons.card_giftcard':
      return Icons.card_giftcard;

    default:
      return Icons.error;
  }
}

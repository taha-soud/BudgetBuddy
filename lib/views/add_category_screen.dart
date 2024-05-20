import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/custom_color.dart';
import '../utils/icons.dart';
import '../view_models/add_category_viewmodel.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddCategoryViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Add Category', style: TextStyle(color: AppColors.secondary)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Consumer<AddCategoryViewModel>(
              builder: (context, viewModel, _) {
                return IconButton(
                  icon: const Icon(Icons.check, color: AppColors.secondary),
                  onPressed: () {
                    if (viewModel.validateForm()) {
                      viewModel.saveForm();
                      viewModel.saveCategory(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter all fields')),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AddCategoryViewModel>(
            builder: (context, viewModel, _) {
              return Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                        labelStyle: TextStyle(color: AppColors.secondary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.secondary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        viewModel.updateCategoryName(value!);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Choose an icon',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: iconNames.length,
                        itemBuilder: (context, index) {
                          final String iconName = iconNames[index];
                          final IconData iconData = getIconData(iconName);
                          return GestureDetector(
                            onTap: () {
                              viewModel.updateSelectedIcon(iconName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: viewModel.selectedIcon == iconName
                                    ? AppColors.secondary.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(iconData, color: AppColors.secondary, size: 36.0),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

const List<String> iconNames = [
  'Icons.local_dining',
  'Icons.fastfood',
  'Icons.emoji_food_beverage_rounded',
  'Icons.local_taxi',
  'Icons.airplanemode_on',
  'Icons.build',
  'Icons.local_parking',
  'Icons.local_gas_station',
  'Icons.hotel',
  'Icons.child_care',
  'Icons.pets',
  'Icons.local_library',
  'Icons.work_history',
  'Icons.shopping_bag',
  'Icons.monitor_heart_sharp',
  'Icons.card_giftcard',
];

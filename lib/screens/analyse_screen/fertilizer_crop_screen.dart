import 'package:cropnurture/models/doctor_list_screen.dart';
import 'package:cropnurture/screens/analyse_screen/treatment_crop_screen.dart';
import 'package:flutter/material.dart';

import 'cause_crop_screen.dart';

class FertilizerScreen extends StatefulWidget {
  @override
  _FertilizerScreenState createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Glow',
      'organic': true,
      'image': 'assets/ecommerce/compost.png',
      'price': '₹500',
      'description': 'Premium compost for soil health.'
    },
    {
      'name': 'Edge - 100',
      'organic': false,
      'image': 'assets/ecommerce/copper_based_fungicides.png',
      'price': '₹750',
      'description': 'Effective copper-based fungicide.'
    },
    {
      'name': 'Arm',
      'organic': true,
      'image': 'assets/ecommerce/fish_emulsion.png',
      'price': '₹350',
      'description': 'Organic fish emulsion fertilizer.'
    },
    {
      'name': 'Glow - 71',
      'organic': false,
      'image': 'assets/ecommerce/insectiside.png',
      'price': '₹400',
      'description': 'Powerful insecticide for pest control.'
    },
    {
      'name': 'Fine 5 SC',
      'organic': true,
      'image': 'assets/ecommerce/manure.png',
      'price': '₹600',
      'description': 'Natural manure for healthy crops.'
    },
    {
      'name': 'Max Crop',
      'organic': true,
      'image': 'assets/ecommerce/npk.png',
      'price': '₹700',
      'description': 'Balanced NPK fertilizer for crops.'
    },
    {
      'name': 'Pest Control',
      'organic': false,
      'image': 'assets/ecommerce/potash.png',
      'price': '₹450',
      'description': 'Potash-based fertilizer for pest resistance.'
    },
    {
      'name': 'Nutri Blend',
      'organic': true,
      'image': 'assets/ecommerce/seaweed.png',
      'price': '₹550',
      'description': 'Seaweed-based fertilizer for plants.'
    },
    {
      'name': 'Soil Booster',
      'organic': true,
      'image': 'assets/ecommerce/manure.png',
      'price': '₹650',
      'description': 'Organic soil booster for yield increase.'
    },
    {
      'name': 'Plant Care',
      'organic': false,
      'image': 'assets/ecommerce/fish_emulsion.png',
      'price': '₹800',
      'description': 'Advanced care for plants.'
    },
    // Add more products here...
  ];

  String searchQuery = '';
  bool showOnlyOrganic = false;

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((product) =>
    (showOnlyOrganic ? product['organic'] : true) &&
        product['name']
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              setState(() {
                showOnlyOrganic = !showOnlyOrganic;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Popular Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      // Optional: Navigate to a product details page
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    image: DecorationImage(
                                      image: AssetImage(product['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  product['price'],
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                if (product['organic'])
                                  Text(
                                    'Organic',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                SizedBox(height: 4),
                                Text(
                                  product['description'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0,bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to the previous page or perform an action
                Navigator.pop(context);
              },
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0,bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to the next page or perform an action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorListScreen()),
                );
              },
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

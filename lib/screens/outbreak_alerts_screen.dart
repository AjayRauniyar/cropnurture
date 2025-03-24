import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/api_provider.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final Map<String, dynamic> inputs = {
    "soil_nitrogen": "",
    "soil_phosphorus": "",
    "soil_potassium": "",
    "soil_ph": "",
    "temperature": "",
    "humidity": "",
    "rainfall": "",
    "time": "Day",
    "ndvi": "",
  };

  void resetInputs() {
    setState(() {
      inputs.forEach((key, value) {
        inputs[key] = "";
      });
      inputs["time"] = "Day"; // Reset the dropdown to default value
    });

    // Reset prediction state in the provider
    Provider.of<ApiProvider>(context, listen: false).resetPrediction();
  }

  void handleInputChange(String key, String value) {
    setState(() {
      inputs[key] = value;
    });
  }

  void handleTimeChange(String value) {
    setState(() {
      inputs["time"] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: CurvedAppBar(title: "Crop Disease Prediction"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: apiProvider.prediction.isEmpty
            ? InputForm(
          inputs: inputs,
          onInputChanged: handleInputChange,
          onTimeChanged: handleTimeChange,
          onPredict: () async {
            await apiProvider.fetchPrediction(inputs);
          },
        )
            : PredictionResult(
          prediction: apiProvider.prediction,
          onTryAgain: resetInputs,
        ),
      ),

    );
  }
}
class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CurvedAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: Container(
        color: Colors.teal,
        height: preferredSize.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/growplant.json', // Replace with your Lottie file path
                height: 90,
                width: 90,
              ),


              // Space between animation and text
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(160.0);
}
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class InputForm extends StatelessWidget {
  final Map<String, dynamic> inputs;
  final Function(String, String) onInputChanged;
  final Function(String) onTimeChanged;
  final VoidCallback onPredict;

  const InputForm({
    Key? key,
    required this.inputs,
    required this.onInputChanged,
    required this.onTimeChanged,
    required this.onPredict,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> inputLabels = [
      "Soil Nitrogen",
      "Soil Phosphorus",
      "Soil Potassium",
      "Soil pH",
      "Temperature",
      "Humidity",
      "Rainfall",
      "NDVI"
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: inputLabels.length,
            itemBuilder: (context, index) {
              String label = inputLabels[index];
              String key = label.toLowerCase().replaceAll(" ", "_");
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: label,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => onInputChanged(key, value),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: DropdownButtonFormField(
                value: inputs["time"] as String,
                items: [
                  DropdownMenuItem(value: "Day", child: Text("Day")),
                  DropdownMenuItem(value: "Night", child: Text("Night")),
                ],
                onChanged: (value) => onTimeChanged(value!),
                decoration: InputDecoration(
                  labelText: "Time",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: onPredict,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Predict",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class PredictionResult extends StatelessWidget {
  final String prediction;
  final VoidCallback onTryAgain;

  const PredictionResult({
    Key? key,
    required this.prediction,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/sucesss.json',
            height: 150,
          ),
          Text(
            "Prediction Result:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            prediction,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTryAgain,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: Text("Try Again"),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> with SingleTickerProviderStateMixin {
  int? activeIndex;
  late TabController _tabController;

  final List<Map<String, String>> resources = [
    {
      'title': 'Understanding Crop Diseases',
      'link': 'https://geopard.tech/blog/how-to-control-crop-diseases-with-smart-agriculture/#:~:text=Crop%20diseases%20symptoms%20caused%20by,and%20the%20entire%20plant%3B%20and',
      'description': 'A comprehensive guide to common crop diseases and their management. Includes references for wheat, maize, and soybean diseases.'
    },
    {
      'title': 'Organic Treatments for Crop Diseases',
      'link': 'https://cropprotectionnetwork.org/',
      'description': 'Explore organic and natural treatment methods for various crop diseases. Detailed information on managing diseases in vegetables, fruits, and grains.'
    },
    {
      'title': 'Using AI in Agriculture',
      'link': 'https://intellias.com/artificial-intelligence-in-agriculture/',
      'description': 'Learn how AI is revolutionizing the agriculture industry. Focuses on AI applications in monitoring and managing diseases in various crops, including rice and potatoes.'
    },
    {
      'title': 'Disease Management for Wheat Crops',
      'link': 'https://www.myfields.info/book/9-disease-management-wheat',
      'description': 'An in-depth guide to common diseases in wheat crops and effective management strategies. Includes information on Fusarium head blight and wheat rust.'
    },
    {
      'title': 'Soybean Disease Management',
      'link': 'https://cals.cornell.edu/field-crops/soybeans/diseases-soybeans',
      'description': 'Resource on soybean diseases like soybean rust and white mold, including integrated management practices and resistance strategies.'
    },
    {
      'title': 'Maize Crop Health',
      'link': 'https://www.dairynz.co.nz/feed/crops/maize/',
      'description': 'Focuses on diseases affecting maize, such as maize leaf blight and northern corn leaf blight, with strategies for prevention and control.'
    }
  ];

  final List<Map<String, String>> videos = [
    {
      'title': 'Crop Diseases and their control',
      'thumbnail': 'https://img.youtube.com/vi/OtiqxEaNY2o/hqdefault.jpg',
      'link': 'https://www.youtube.com/watch?v=OtiqxEaNY2o'
    },
    {
      'title': 'Organic Farming Techniques',
      'thumbnail': 'https://img.youtube.com/vi/oQ1KltEBydE/hqdefault.jpg',
      'link': 'https://www.youtube.com/watch?v=oQ1KltEBydE'
    },
    {
      'title': 'Identify Plants disease with help of leaves color',
      'thumbnail': 'https://img.youtube.com/vi/zj9NHDhYWbU/hqdefault.jpg',
      'link': 'https://www.youtube.com/watch?v=zj9NHDhYWbU'
    },
    {
      'title': 'Artificial Intelligence (AI) in Agriculture',
      'thumbnail': 'https://img.youtube.com/vi/_tijHjup-gM/hqdefault.jpg',
      'link': 'https://www.youtube.com/watch?v=_tijHjup-gM'
    },
  ];

  final List<Map<String, String>> faqs = [
    {
      'question': 'What are the most common causes of crop diseases?',
      'answer': 'Crop diseases are typically caused by pathogens such as fungi, bacteria, viruses, and nematodes. Environmental factors like poor soil conditions, excessive moisture, and temperature fluctuations can also contribute to the spread of diseases.'
    },
    {
      'question': 'How can I identify if my crops are diseased?',
      'answer': 'Common signs of crop diseases include discoloration, wilting, spots on leaves, stunted growth, and abnormal development. Early identification is crucial for effective management.'
    },
    {
      'question': 'What are some natural methods for managing crop diseases?',
      'answer': 'Natural methods include crop rotation, using disease-resistant crop varieties, applying organic fungicides, and encouraging beneficial insects that can help control disease-spreading pests.'
    },
    {
      'question': 'Can crop diseases spread from one plant to another?',
      'answer': 'Yes, many crop diseases can spread through water, wind, soil, insects, or contaminated tools. It\'s important to implement good hygiene practices and proper crop spacing to minimize the risk of spreading diseases.'
    },
    {
      'question': 'How can I prevent crop diseases from affecting my harvest?',
      'answer': 'Preventative measures include selecting resistant crop varieties, ensuring proper soil health, rotating crops, practicing good irrigation management, and maintaining proper plant spacing to reduce humidity around plants.'
    },
    {
      'question': 'Are there any technologies that can help in detecting and managing crop diseases?',
      'answer': 'Yes, modern technologies such as drones, AI-based disease detection tools, and mobile apps can help farmers monitor crop health, detect early signs of diseases, and manage them more efficiently.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleFAQ(int index) {
    setState(() {
      activeIndex = activeIndex == index ? null : index;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Learn more Education',
          style: TextStyle(fontWeight: FontWeight.bold),

        ),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
          tabs: const [
            Tab(
              icon: Icon(Icons.article),
              text: 'Resources',
            ),
            Tab(
              icon: Icon(Icons.video_library),
              text: 'Videos',
            ),
            Tab(
              icon: Icon(Icons.question_answer),
              text: 'FAQs',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResourcesTab(),
          _buildVideosTab(),
          _buildFAQsTab(),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource['description']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _launchUrl(resource['link']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Learn More'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosTab() {
    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => _launchUrl(video['link']!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      video['thumbnail']!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.error, size: 40, color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.play_circle_filled, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            video['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  Widget _buildFAQsTab() {
    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isActive = activeIndex == index;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                InkWell(
                  onTap: () => toggleFAQ(index),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.remove_circle : Icons.add_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            faq['question']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: isActive ? null : 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 48,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Text(
                      faq['answer']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
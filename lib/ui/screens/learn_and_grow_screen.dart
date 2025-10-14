import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/resource_loader.dart';
import '../models/educational_resource.dart';
import '../ui/theme/colors.dart';

// track_that_money
// lib/ui/screens/learn_and_grow_screen.dart

class LearnAndGrowScreen extends StatefulWidget {
  const LearnAndGrowScreen({Key? key}) : super(key: key);

  @override
  State<LearnAndGrowScreen> createState() => _LearnAndGrowScreenState();
}

class _LearnAndGrowScreenState extends State<LearnAndGrowScreen> {
  late Future<List<EducationalResource>> _resources;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _resources = ResourceLoader.loadAllResources();
  }

  Future<void> _refreshResources() async {
    setState(() => _resources = ResourceLoader.loadAllResources());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cloud,
      appBar: AppBar(
        title: const Text("Learn & Grow),
        centerTitle: true,
        backgroundColor: AppColors.moneyGreen,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<EducationalResource>>(
        future: _resources,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allResources = snapshot.data ?? [];

          /// Filtering
          final filtered = allResources.where((r) {
            final matchesCategory = _selectedCategory == 'All' ||
                r.category.toLowerCase() == _selectedCategory.toLowerCase();
            final matchesSearch = _searchQuery.isEmpty ||
                r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                r.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
            return matchesCategory && matchesSearch;
          }).toList();

          final categories = [
            'All',
            ...{for (var r in allResources) r.category}
          ];

          return RefreshIndicator(
            color: AppColors.moneyGreen,
            onRefresh: _refreshResources,
            child: Column(
              children: [
                /// Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    cursorColor: AppColors.deepNavy,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search topics...",
                      filled: true,
                      fillColor: AppColors.cloud,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: AppColors.mintGreen, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: AppColors.forestGreen, width: 2),
                      ),
                    ),
                  ),
                ),

                /// Category dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizonal: 16, vertical: 8),
                  child: DecoratedBox(
                    decoration: BoxDecoraton(
                      color: AppColors.cloud,
                      border: Border.all(color: AppColors.mintGreen),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCategory,
                        underline: const SizedBox.shrink(),
                        iconEnabledColor: AppColors.deepNavy,
                        items: categories
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                      ),
                    ),
                  ),
                ),

                /// Resource list
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final r = filtered[index];
                      return Card(
                        color: AppColors.mistGreen,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            r.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              r.description,
                              style: TextStyle(
                                color: AppColors.graphite,
                                height: 1.3,
                              ),
                            ),
                          ),
                          trailing: Chip(
                            label: Text(r.tag),
                            backgroundColor: AppColors.leafGreen.withOpacity(.2),
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () async {
                            final url = Uri.parse(r.url);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          },
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
    );
  }
}

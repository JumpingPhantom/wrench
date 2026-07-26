import 'package:flutter/material.dart';
import 'package:wrench/features/home/presentation/widgets/request_item.dart';

class RecentRequestsBody extends StatelessWidget {
  const RecentRequestsBody({super.key, required this.requests});

  final List<Map<String, String>> requests;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: RequestItem(request: request),
        );
      },
    );
  }
}

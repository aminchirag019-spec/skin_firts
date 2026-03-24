import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(radius: 60, backgroundColor: Colors.white),
          SizedBox(height: 10),

          Container(height: 16, width: 120, color: Colors.white),

          SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (_, __) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Container(height: 14, width: 150, color: Colors.white),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


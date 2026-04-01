import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import '../../Data/doctor_model.dart';
import '../../Helper/app_localizations.dart';
import '../../Router/router_class.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';
import '../DoctorScreens/doctor_info_screen.dart';

class ReviewScreen extends StatefulWidget {
  final AddDoctor? doctor;
  const ReviewScreen({super.key, this.doctor});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              topRow(
                context,
                text: localization?.translate('Review') ?? "Review",
                onPressed: () => context.go(RouterName.appointmentScreen.path),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSize.height(context) * 0.02),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.03),
                      CircleAvatar(
                        radius: AppSize.width(context) * 0.18,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: const AssetImage("assets/images/user_image.png"),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.02),
                      Text(
                        widget.doctor?.getLocalized(widget.doctor?.doctorName, langCode, localization) ?? "Dr. Olivia Turner, M.D.",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.doctor?.getLocalized(widget.doctor?.specialization, langCode, localization) ?? "Dermato-Endocrinology",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.favorite, color: colorScheme.primary, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < _rating ? Icons.star : Icons.star_border,
                                  color: colorScheme.primary,
                                  size: 20,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.height(context) * 0.04),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: localization?.translate('enter_comment') ?? "Enter Your Comment Here...",
                            hintStyle: TextStyle(color: colorScheme.primary.withOpacity(0.4)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.05),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add review logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            localization?.translate('Add Review') ?? "Add Review",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

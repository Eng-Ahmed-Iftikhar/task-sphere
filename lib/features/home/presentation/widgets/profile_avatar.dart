import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final ImageProvider? imageProvider;
  final Color borderColor;
  final VoidCallback? onEdit;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.imageProvider,
    required this.borderColor,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? 'US'
        : name
              .split(' ')
              .map((part) => part.isEmpty ? '' : part[0])
              .take(2)
              .join()
              .toUpperCase();

    final backgroundImage =
        imageProvider ??
        (imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!) as ImageProvider
            : null);

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: borderColor.withValues(alpha: 0.15),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: borderColor.withValues(alpha: 0.3),
            backgroundImage: backgroundImage,
            child: backgroundImage == null
                ? Text(
                    initials,
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
        if (onEdit != null)
          Positioned(
            bottom: 4,
            right: 4,
            child: Material(
              color: Colors.white,
              type: MaterialType.circle,
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onEdit,
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: borderColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

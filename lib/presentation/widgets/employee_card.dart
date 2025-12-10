import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.userName,
    this.employeeNumber,
    this.userId,
    this.onTap,
    this.leading,
    this.trailing,
    this.subtitle,
    this.backgroundColor,
    this.avatarBackgroundColor,
    this.avatarTextColor,
  });

  final String userName;
  final String? employeeNumber;
  final int? userId;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  final Color? backgroundColor;
  final Color? avatarBackgroundColor;
  final Color? avatarTextColor;

  String get _idLabel {
    if (employeeNumber != null && employeeNumber!.isNotEmpty) {
      return employeeNumber!;
    }
    return userId?.toString() ?? '?';
  }

  String get _userInitial {
    if (userName.isNotEmpty) {
      return userName[0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color defaultAvatarBg = avatarBackgroundColor ?? primaryColor;
    final Color defaultAvatarText = avatarTextColor ?? Colors.white;
    final Color cardBg = backgroundColor ?? Colors.grey.shade50;

    Widget cardContent = Container(
      margin: EdgeInsets.only(bottom: 1.0.h),
      padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 1.5.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (leading != null) ...[
            leading!,
            SizedBox(width: 1.5.w),
          ] else
            CircleAvatar(
              radius: 2.0.h,
              backgroundColor: defaultAvatarBg,
              child: Text(
                _userInitial,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: defaultAvatarText,
                  fontSize: 1.6.h,
                ),
              ),
            ),
          SizedBox(width: 1.2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Emp #$_idLabel',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 1.1.h,
                      ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 1.4.h,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 1.2.w),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(1.5.h),
        child: cardContent,
      );
    }

    return cardContent;
  }
}


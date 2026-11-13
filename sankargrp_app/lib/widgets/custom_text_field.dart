import 'package:flutter/cupertino.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String placeholder;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.placeholder,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.errorMessage,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Slate 100 soft background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.errorMessage != null && widget.errorMessage!.isNotEmpty
                  ? const Color(0xFFEF4444)
                  : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          child: CupertinoTextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.isPassword ? _obscureText : false,
            onChanged: widget.onChanged,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: null,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
            ),
            placeholder: widget.placeholder,
            placeholderStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
            ),
            prefix: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 14, right: 6),
                    child: Icon(
                      widget.prefixIcon,
                      size: 19,
                      color: const Color(0xFF64748B),
                    ),
                  )
                : null,
            suffix: widget.isPassword
                ? CupertinoButton(
                    padding: const EdgeInsets.only(right: 14),
                    minimumSize: Size.zero,
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                    child: Icon(
                      _obscureText
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      size: 19,
                      color: const Color(0xFF64748B),
                    ),
                  )
                : null,
          ),
        ),
        if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

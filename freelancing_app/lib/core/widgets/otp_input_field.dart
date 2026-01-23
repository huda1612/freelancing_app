import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// عنصر إدخال OTP يتكون من عدة حقول إدخال رقمية
class OTPInputField extends StatefulWidget {
  final int length; // عدد خانات OTP

  const OTPInputField({super.key, this.length = 6});

  @override
  OTPInputFieldState createState() => OTPInputFieldState();
}

class OTPInputFieldState extends State<OTPInputField> {
  late List<FocusNode> _focusNodes; // قائمة لإدارة التركيز على كل حقل
  late List<TextEditingController> _controllers; // قائمة للتحكم في محتوى كل حقل

  @override
  void initState() {
    super.initState();

    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());

    for (var node in _focusNodes) {
      node.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String getCurrentCode() {
    return _controllers.map((c) => c.text).join();
  }

  void _handlePaste(String pastedText) {
    final cleanText = pastedText.replaceAll(RegExp(r'\D'), '');
    final chars = cleanText.split('');

    for (int i = 0; i < widget.length && i < chars.length; i++) {
      _controllers[i].text = chars[i];
    }

    if (chars.length < widget.length) {
      _focusNodes[chars.length].requestFocus();
    } else {
      _focusNodes.last.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return Container(
            width: 56.w,
            height: 48.h,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    _controllers[index].text.isEmpty &&
                    index > 0) {
                  _focusNodes[index - 1].requestFocus();
                  _controllers[index - 1].clear();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    focusNode: _focusNodes[index],
                    style: TextStyle(fontSize: 18.sp),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.length > 1) {
                        _handlePaste(value);
                        return;
                      }
                      if (value.isNotEmpty && index < widget.length - 1) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.grey.shade200, // خلفية الحقل
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Colors.blue), // عند التركيز
                      ),
                    ),
                  ),
                  if (_focusNodes[index].hasFocus)
                    Positioned(
                      bottom: 14.h,
                      child: SizedBox(
                        width: 23.8.w,
                        height: 2.h,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(color: Colors.blue),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

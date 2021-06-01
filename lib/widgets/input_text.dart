import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<String> labels;
  final List<TextEditingController> textControllers;
  final List<FocusNode> focusNodes;
  InputText({
    Key? key,
    required this.formKey,
    required this.labels,
    required this.textControllers,
    required this.focusNodes,
  }) : super(key: key);

  bool _visible = true;

  void _setvisibility() {
    _visible = !_visible;
  }

  @override
  Widget build(BuildContext context) {
    final list = labels
        .asMap()
        .map(
          (index, label) => MapEntry(
            index,
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: TextFormField(
                controller: textControllers[index],
                obscureText: index == 1 ? _visible : false,
                validator: (input) => input!.isEmpty ? 'can not be null' : null,
                decoration: InputDecoration(
                  labelText: label,
                  prefixIcon: (() {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.person,
                          color: Colors.red,
                        );
                      case 1:
                        return Icon(
                          Icons.work_sharp,
                          color: Colors.red,
                        );
                      case 2:
                        return Icon(
                          Icons.vpn_key,
                          color: Colors.red,
                        );
                    }
                  }()),
                  // suffixIcon: index == 1
                  //     ? IconButton(
                  //         onPressed: _setvisibility,
                  //         icon: Icon(
                  //           _visible ? Icons.visibility : Icons.visibility_off,
                  //         ),
                  //       )
                  //     : SizedBox.shrink(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        )
        .values
        .toList();

    return Positioned(
      top: 200.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: list,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CloseWidget extends StatelessWidget {
  const CloseWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IconButton(
          icon: const Icon(Icons.close),
          color: Theme.of(context).iconTheme.color,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

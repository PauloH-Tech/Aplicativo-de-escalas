import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class PostoBadge extends StatelessWidget {
  final int posicao;

  const PostoBadge(this.posicao, {super.key});

  @override
  Widget build(BuildContext context) {
    final isFirst = posicao == 1;
    final isSecond = posicao == 2;
    final isThird = posicao == 3;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isFirst
            ? AppTheme.gold
            : isSecond
            ? AppTheme.silver
            : isThird
            ? AppTheme.bronze
            : AppTheme.primary.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$posicao',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isFirst ? Colors.white : AppTheme.primary,
          ),
        ),
      ),
    );
  }
}

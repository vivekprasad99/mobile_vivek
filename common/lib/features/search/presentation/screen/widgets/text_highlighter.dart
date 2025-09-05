import 'package:flutter/material.dart';

class TitleTextHighlighter extends StatelessWidget {
  const TitleTextHighlighter(
      {super.key, required this.text, required this.query,});

  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    return _buildHighlightedText(text, query, context);
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    BuildContext context,
  ) {
    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final List<String> queryWords = query
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty && word.length >= 3)
        .toList();

    if (queryWords.isEmpty) {
      return Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.w400),
      );
    }

    final RegExp regExp = RegExp(
        queryWords.map((word) => RegExp.escape(word)).join('|'),
        caseSensitive: false);
    final Iterable<Match> matches = regExp.allMatches(lowerText);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.w400),
        children: spans,
      ),
    );
  }
}

import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class FormDescriptionHtmlContent extends StatelessWidget {
  const FormDescriptionHtmlContent({
    super.key,
    required this.html,
  });

  final String html;

  @override
  Widget build(BuildContext context) {
    if (StringHelper.isEmptyString(html)) {
      return const SizedBox.shrink();
    }

    final borderColor = dividerColor_(context);
    final linkColor = defaultAccentColor_(context);
    final textColor = primaryTextColor_(context);
    final segments = _splitHtmlSegments(html)
        .where((segment) => !_isEmptyHtml(segment.content))
        .toList();

    final tableSegmentIndexes = [
      for (var i = 0; i < segments.length; i++)
        if (segments[i].isTable) i,
    ];
    final lastTableIndex =
        tableSegmentIndexes.isEmpty ? -1 : tableSegmentIndexes.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < segments.length; index++)
          if (segments[index].isTable)
            _DescriptionTableView(
              tableHtml: segments[index].content,
              borderColor: borderColor,
              textColor: textColor,
              bottomSpacing: index == lastTableIndex ? 0 : 8,
            )
          else if (!StringHelper.isEmptyString(segments[index].content.trim()))
            Html(
              data: segments[index].content,
              shrinkWrap: true,
              onLinkTap: (url, attributes, element) {
                _launchDescriptionLink(url);
              },
              style: _htmlStyles(
                textColor: textColor,
                linkColor: linkColor,
                borderColor: borderColor,
              ),
            ),
      ],
    );
  }

  static Map<String, Style> _htmlStyles({
    required Color textColor,
    required Color linkColor,
    required Color borderColor,
  }) {
    return {
      'body': Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        fontSize: FontSize(15),
        fontWeight: FontWeight.w400,
        color: textColor,
        lineHeight: const LineHeight(1.4),
      ),
      'p': Style(
        margin: Margins.only(bottom: 8),
        padding: HtmlPaddings.zero,
      ),
      'a': Style(
        color: linkColor,
        textDecoration: TextDecoration.underline,
        textDecorationColor: linkColor,
      ),
      'img': Style(
        width: Width(100, Unit.percent),
        display: Display.block,
        margin: Margins.symmetric(vertical: 8),
      ),
      'ol': Style(
        margin: Margins.only(left: 18, bottom: 8),
        padding: HtmlPaddings.zero,
      ),
      'ul': Style(
        margin: Margins.only(left: 18, bottom: 8),
        padding: HtmlPaddings.zero,
      ),
      'li': Style(
        margin: Margins.only(bottom: 8),
        display: Display.listItem,
      ),
    };
  }

  static List<_HtmlSegment> _splitHtmlSegments(String html) {
    final segments = <_HtmlSegment>[];
    final tablePattern = RegExp(
      r'<table[\s\S]*?</table>',
      caseSensitive: false,
    );

    var lastEnd = 0;
    for (final match in tablePattern.allMatches(html)) {
      if (match.start > lastEnd) {
        segments.add(_HtmlSegment(content: html.substring(lastEnd, match.start)));
      }
      segments.add(
        _HtmlSegment(content: match.group(0)!, isTable: true),
      );
      lastEnd = match.end;
    }

    if (lastEnd < html.length) {
      segments.add(_HtmlSegment(content: html.substring(lastEnd)));
    }

    if (segments.isEmpty) {
      segments.add(_HtmlSegment(content: html));
    }

    return segments;
  }

  static bool _isEmptyHtml(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return true;

    final withoutEmptyParagraphs = trimmed
        .replaceAll(RegExp(r'<p>\s*</p>', caseSensitive: false), '')
        .trim();

    return withoutEmptyParagraphs.isEmpty;
  }

  static Future<void> _launchDescriptionLink(String? url) async {
    if (StringHelper.isEmptyString(url)) return;

    var target = url!.trim();
    if (!target.startsWith('http://') && !target.startsWith('https://')) {
      target = 'https://$target';
    }

    final uri = Uri.tryParse(target);
    if (uri == null) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _HtmlSegment {
  const _HtmlSegment({
    required this.content,
    this.isTable = false,
  });

  final String content;
  final bool isTable;
}

class _DescriptionTableView extends StatelessWidget {
  const _DescriptionTableView({
    required this.tableHtml,
    required this.borderColor,
    required this.textColor,
    this.bottomSpacing = 0,
  });

  final String tableHtml;
  final Color borderColor;
  final Color textColor;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final rows = _parseTableRows(tableHtml);
    if (rows.isEmpty) return const SizedBox.shrink();

    final columnCount = rows.fold<int>(
      0,
      (max, row) => row.length > max ? row.length : max,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Table(
        border: TableBorder.all(color: borderColor, width: 1),
        defaultColumnWidth: const FlexColumnWidth(1),
        columnWidths: {
          for (var index = 0; index < columnCount; index++)
            index: const FlexColumnWidth(1),
        },
        children: [
          for (final row in rows)
            TableRow(
              children: [
                for (var index = 0; index < columnCount; index++)
                  _TableCell(
                    text: index < row.length ? row[index] : '',
                    textColor: textColor,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  static List<List<String>> _parseTableRows(String tableHtml) {
    final innerHtml = tableHtml
        .replaceFirst(
          RegExp(r'^<table[^>]*>', caseSensitive: false),
          '',
        )
        .replaceFirst(
          RegExp(r'</table>\s*$', caseSensitive: false),
          '',
        )
        .replaceAll(
          RegExp(r'<colgroup[\s\S]*?</colgroup>', caseSensitive: false),
          '',
        );

    final rows = <List<String>>[];
    final rowMatches = RegExp(
      r'<tr[^>]*>([\s\S]*?)</tr>',
      caseSensitive: false,
    ).allMatches(innerHtml);

    for (final rowMatch in rowMatches) {
      final rowContent = rowMatch.group(1) ?? '';
      final cells = <String>[];
      final cellMatches = RegExp(
        r'<t[dh][^>]*>([\s\S]*?)</t[dh]>',
        caseSensitive: false,
      ).allMatches(rowContent);

      for (final cellMatch in cellMatches) {
        cells.add(_stripHtmlTags(cellMatch.group(1) ?? '').trim());
      }

      if (cells.isNotEmpty) {
        rows.add(cells);
      }
    }

    return rows;
  }

  static String _stripHtmlTags(String value) {
    return value
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+\n'), '\n')
        .trim();
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    required this.textColor,
  });

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.3,
        ),
      ),
    );
  }
}

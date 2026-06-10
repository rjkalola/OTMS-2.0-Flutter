import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
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

    final preparedHtml = _prepareDescriptionHtml(html);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Html(
            data: preparedHtml,
            shrinkWrap: true,
            extensions: [
              const TableHtmlExtension(),
              TagWrapExtension(
                tagsToWrap: const {'table'},
                builder: (child) {
                  return _DescriptionTableScroller(
                    minWidth: constraints.maxWidth,
                    child: child,
                  );
                },
              ),
            ],
            onLinkTap: (url, attributes, element) {
              _launchDescriptionLink(url);
            },
            style: {
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
              'table': Style(
                margin: Margins.only(bottom: 12),
                border: Border.all(color: borderColor, width: 1),
              ),
              'td': Style(
                padding: HtmlPaddings.symmetric(horizontal: 6, vertical: 6),
                border: Border.all(color: borderColor, width: 1),
                alignment: Alignment.centerLeft,
                fontSize: FontSize(14),
              ),
              'th': Style(
                padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 6),
                border: Border.all(color: borderColor, width: 1),
                fontWeight: FontWeight.w600,
                alignment: Alignment.centerLeft,
                fontSize: FontSize(14),
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
            },
          ),
        );
      },
    );
  }

  static String _prepareDescriptionHtml(String html) {
    return html.replaceAllMapped(
      RegExp(r'<table([^>]*)>', caseSensitive: false),
      (match) {
        var attrs = match.group(1) ?? '';
        attrs = attrs.replaceAll(
          RegExp(r'\s*width="100%"', caseSensitive: false),
          '',
        );
        attrs = attrs.replaceAll(
          RegExp(r'width:\s*100%;?', caseSensitive: false),
          '',
        );
        return '<table$attrs>';
      },
    );
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

class _DescriptionTableScroller extends StatelessWidget {
  const _DescriptionTableScroller({
    required this.minWidth,
    required this.child,
  });

  final double minWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.hardEdge,
      child: UnconstrainedBox(
        alignment: Alignment.centerLeft,
        constrainedAxis: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: child,
        ),
      ),
    );
  }
}

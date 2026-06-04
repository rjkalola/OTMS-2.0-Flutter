import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateDetailsPreview extends StatelessWidget {
  const CertificateDetailsPreview({
    super.key,
    required this.fileUrl,
    required this.onTap,
  });

  final String? fileUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (StringHelper.isEmptyString(fileUrl)) {
      return const SizedBox.shrink();
    }

    final isPdf = (fileUrl ?? "").toLowerCase().endsWith('.pdf');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextView(
            text: 'preview'.tr,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isPdf
                  ? _PdfPreviewPlaceholder()
                  : _ImagePreview(url: fileUrl!),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (_, __) => const _PreviewPlaceholder(),
        errorWidget: (_, __, ___) => _PreviewPlaceholder(hasError: true),
      ),
    );
  }
}

class _PdfPreviewPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewPlaceholder(isPdf: true);
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  const _PreviewPlaceholder({
    this.hasError = false,
    this.isPdf = false,
  });

  final bool hasError;
  final bool isPdf;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: lightGreyColor(context),
      alignment: Alignment.center,
      child: hasError
          ? Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: secondaryExtraLightTextColor_(context),
            )
          : isPdf
              ? Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 48,
                  color: secondaryExtraLightTextColor_(context),
                )
              : ImageUtils.setSvgAssetsImage(
                  path: Drawable.galleryImage,
                  width: 56,
                  height: 56,
                  color: secondaryExtraLightTextColor_(context),
                ),
    );
  }
}

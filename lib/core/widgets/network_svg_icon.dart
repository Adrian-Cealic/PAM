import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../network/http_client_scope.dart';

class NetworkSvgIcon extends StatelessWidget {
  const NetworkSvgIcon(this.url, {super.key, this.size = 24, this.fallback = Icons.circle_outlined});

  final String url;
  final double size;
  final IconData fallback;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return Icon(fallback, size: size);

    return SvgPicture(
      SvgNetworkLoader(url, httpClient: HttpClientScope.maybeOf(context)),
      width: size,
      height: size,
      placeholderBuilder: (_) => SizedBox.square(dimension: size),
      errorBuilder: (_, _, _) => Icon(fallback, size: size),
    );
  }
}
